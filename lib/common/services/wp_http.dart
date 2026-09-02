import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../index.dart';

class WPHttpService extends GetxService {
  static WPHttpService get to => Get.find();

  late final Dio _dio;
  // final CancelToken _cancelToken = CancelToken(); // 默认去掉
  // 添加标记变量
  bool _isLoggingOut = false;

  @override
  void onInit() {
    super.onInit();

    // 初始 dio
    var options = BaseOptions(
      baseUrl: Constants.wpApiBaseUrl,
      connectTimeout: const Duration(seconds: 20), // 10秒
      receiveTimeout: const Duration(seconds: 15), // 5秒
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    _dio = Dio(options);

    // 拦截器
    _dio.interceptors.add(RequestInterceptors());
  }

  // 401：退出并重新登录
  Future<void> errorNoAuthLogout() async {
    // 添加标记防止重复执行
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await Storage().remove('token');
      // 使用 Get.offAllNamed 而不是 Get.offAll
      Get.offAllNamed('/loginPage');
    } finally {
      _isLoggingOut = false;
    }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }
}

/// 拦截
class RequestInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print("Get 参数: ${options.queryParameters}");
    // print("Post 参数: ${options.data}");
    // super.onRequest(options, handler);

    // http header 头加入 Authorization
    var lang = '';
    if (PlatformUtils().isWeb) {
      lang = 'en';
    } else {
      if (ConfigService.to.locale.toLanguageTag() == 'zh-CN') {
        lang = 'zh-Hans';
      } else if (ConfigService.to.locale.toLanguageTag() == 'zh-TW') {
        lang = 'zh-TW';
      } else if (ConfigService.to.locale.toLanguageTag() == 'en-US') {
        lang = 'en';
      }
    }
    if (Storage().getString('token').isNotEmpty) {
      // print('token=${Storage().getString('token')}');
      options.headers['Authorization'] =
          'Bearer ${Storage().getString('token')}';
      options.headers['Lang'] = lang;
    }
    return handler.next(options);
    // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      handler.next(response);
    } else {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    }
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final exception = HttpException(err.message ?? "error message");
    // 打印错误的请求URL
    print(
        '请求错误 URL: ${err.requestOptions.uri}，内容：${err.response?.data}，状态码：${err.response?.statusCode}');

    switch (err.type) {
      case DioExceptionType.badResponse: // 服务端自定义错误体处理
        final response = err.response;
        if (response != null) {
          // 假设Loading.error接受String类型的参数，并且你想要显示响应体的数据
          Loading.error(response.data?.toString() ?? 'Error response is empty');
          if (err.response?.statusCode == 401) {
            // 调用 WPHttpService 的方法
            WPHttpService.to.errorNoAuthLogout();
          }
        } else {
          Loading.error('No response from server');
        }
        break;
      case DioExceptionType.unknown:
        Loading.error('连接超时，请稍后重试');
        break;
      case DioExceptionType.cancel:
        Loading.error('取消');
        break;
      case DioExceptionType.connectionTimeout:
        Loading.error('连接超时');
        break;
      default:
        // print('其他错误----------------拦截错误=${err.message}，状态码=${err.response?.statusCode}');
        Loading.error('其他错误');
        break;
    }
    DioException errNext = err.copyWith(
      error: exception,
    );
    handler.next(errNext);
  }
}
