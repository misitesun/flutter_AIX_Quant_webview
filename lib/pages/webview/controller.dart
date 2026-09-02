import 'dart:convert';
import 'dart:io';

import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class WebviewController extends GetxController {
  WebviewController();
  final GlobalKey qrKey = GlobalKey();
  // 当前版本号
  String currentVersion = '';
  // WebView 控制器
  WebViewController webViewController = WebViewController();
  // 页面URL
  String url = '';
  // 操作类型
  String type = '';
  // 钱包地址
  String address = '';
  dynamic data; 

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    // 清理资源
    webViewController.clearCache();
    super.onClose();
  }

  _initData() async {
    // 最新公告弹窗
    currentVersion = ConfigService.to.version;
    onVersionUpdate();
    // 添加时间戳，防止缓存
    String timestamp = (DateTime.now().millisecondsSinceEpoch/1000).floor().toString();
    print('timestamp: $timestamp');
    String h5Url = '${Constants.h5Url}?timestamp=$timestamp';
    print('h5Url: $h5Url');

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.pageBgColor) // 设置WebView背景色为黑色
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          // 收到Flutter消息: ?type=downloadImage&address=688da8c5e8516
          print('收到Flutter消息: ${message.message}');
          handleH5Message(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // 页面开始加载时立即注入，早于 H5 业务代码执行
            _injectJavaScript();
          },
          onPageFinished: (String url) {
            // 页面加载完成后再注入一次，防止漏注入
            _injectJavaScript();
          },
        ),
      )
      ..loadRequest(Uri.parse(h5Url));
    update(["webView"]);
  }

  // 注入JavaScript代码
  void _injectJavaScript() {
    const String javascript = '''
      window.__FROM_FLUTTER__ = true;

      if (!window.receiveMessageFromFlutter) {
        window.receiveMessageFromFlutter = function(message) {
          console.log('收到Flutter消息:', message);
        };
      }
      
      if (!window.sendMessageToFlutter) {
        window.sendMessageToFlutter = function(message) {
          Flutter.postMessage(message);
        };
      }
    ''';

    webViewController.runJavaScript(javascript);
  }

  // 向H5发送消息
  void sendMessageToH5(String message) {
    webViewController
        .runJavaScript('window.receiveMessageFromFlutter("$message")');
  }

  // 处理从H5接收到的消息
  void handleH5Message(String message) {
    print('处理H5消息: $message');
    
    // 异步处理，避免阻塞主线程
    Future.microtask(() async {
      try {
        data = jsonDecode(message);
        print('解析H5消息: $data');
        
        if (data != null && data['token'] != null) {
          await Storage().setString('token', data['token']);
          // Storage().setString('token', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NjAxNTIwMzgsIm5iZiI6MTc2MDE1MjAzNywiZXhwIjoxNzYwNzU2ODM4LCJ1aWQiOjMxMjQzMywidGhpcmRfcGFydHlfdWlkIjozMjM2NjB9.utAG83WsK9Qb5zjy1KFclma0Q_BA4aKagnWmnTtFbyo');
          print('Token已保存: ${data['token']}');
        }
        
        if (data != null && data['type'] == 'uploadImage') {
          print('收到图片上传请求');
          _pickImage();
        }
      } catch (e) {
        print('处理H5消息出错: $e');
        Loading.toast('处理消息失败: $e');
      }
    });
  }

  // 保存二维码
  downloadImage() {
    try {
      print('二维码地址: $address');

      // 检查地址是否为空
      if (address.isEmpty) {
        print('二维码地址为空');
        Get.snackbar('提示', '二维码地址为空', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      Get.dialog(
        Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
            child: <Widget>[
              <Widget>[
                // 关闭弹窗
                Icon(Icons.close, size: 24, color: Colors.white).onTap(() {
                  Get.back();
                }),
              ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.end)
                  .paddingOnly(top: 30.w, right: 30.w, bottom: 30.w),
              RepaintBoundary(
                  key: qrKey,
                  child: <Widget>[
                    ImgWidget(
                        path: 'assets/img/ewm.png',
                        width: 480.w,
                        height: 480.w),
                    <Widget>[
                      QrImageView(
                        data: address,
                        version: QrVersions.auto,
                        size: 350.w,
                        gapless: false,
                        backgroundColor: Colors.white,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: Size(350.w, 350.w),
                        ),
                      ),
                    ]
                        .toRow(mainAxisAlignment: MainAxisAlignment.center)
                        .tight(width: 480.w, height: 480.w)
                  ].toStack().tight(width: 480.w, height: 480.w)),
              // 保存按钮
              SizedBox(height: 100.w),
              <Widget>[
                ButtonWidget(
                  text: '保存'.tr,
                  height: 88,
                  borderRadius: 44,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onTap: () {
                    saveImage();
                  },
                ),
              ].toRow().paddingHorizontal(20.w),
            ]
                .toColumn()
                .tight(width: 480.w, height: 820.w)
                .backgroundColor(AppTheme.blockBgColor)
                .clipRRect(all: 30.w)),
      );
    } catch (e) {
      print('显示二维码弹窗时发生错误: $e');
      Get.snackbar('提示', '显示二维码失败: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 保存二维码到本地相册
  void saveImage() async {
    try {
      // 检查控制器是否仍然活跃
      if (!Get.isRegistered<WebviewController>()) {
        print('控制器已销毁，取消保存操作');
        return;
      }

      // 安全获取 RenderRepaintBoundary
      final context = qrKey.currentContext;
      if (context == null) {
        print('无法获取当前上下文');
        Get.snackbar('提示', '无法获取图片上下文', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final renderObject = context.findRenderObject();
      if (renderObject == null) {
        print('无法获取渲染对象');
        Get.snackbar('提示', '无法获取渲染对象', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (renderObject is! RenderRepaintBoundary) {
        print('渲染对象类型错误');
        Get.snackbar('提示', '渲染对象类型错误', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final boundary = renderObject;
      print('boundary: $boundary');

      // 等待一下确保UI已经完全渲染
      await Future.delayed(const Duration(milliseconds: 100));

      // 再次检查控制器状态
      if (!Get.isRegistered<WebviewController>()) {
        print('控制器已销毁，取消图片转换');
        return;
      }

      // 将 Widget 转换成图片
      final image = await boundary.toImage(pixelRatio: 3.0);
      print('image: $image');

      // 将图片转换成字节数据
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      print('byteData: $byteData');

      if (byteData != null) {
        final success = await ImageSaverHelper.saveUint8ListImage(
          byteData.buffer.asUint8List(),
          showLoading: false, // 不显示加载弹窗，因为已经有对话框了
        );
        print('保存结果: $success');

        if (success) {
          Get.snackbar('提示', '二维码保存成功', snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('提示', '二维码保存失败', snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        print('图片数据为空');
        Get.snackbar('提示', '图片数据生成失败', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('保存图片时发生错误: $e');
      Get.snackbar('提示', '保存失败: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // 版本更新
  void onVersionUpdate() async {
    String device = PlatformUtils().isAndroid ? 'android' : 'ios';
    // // 接口拿到更新数据
    var res = await HomeApi.versionUpdate(
        VersionUpdateReq(version: currentVersion, device: device));
    print('版本更新: ${res.toJson()}');
    // 使用工具类检查更新，为了方便展示，把更新数据写死测试安装
    if (res.editionNumber != null && res.editionNumber! > 0) {
      VersionUpdateUtil.checkUpdate(
        currentVersion: currentVersion,
        latestVersion: res.editionName ?? '',
        description: res.describe ?? '',
        apkUrl: res.downloadUrl ?? '',
        isForce: 1,
      );
    }
    update(["webView"]);
  }

  // 选择图片
  void _pickImage() async {
    print('token=${Storage().getString('token')}');
    final List<Map<String, dynamic>> actions = [
      {"id": 1, "title": "相机", "type": "camera"},
      {"id": 2, "title": "相册", "type": "gallery"},
    ];
    ActionSheetUtil.showActionSheet(
      context: Get.context!,
      title: '请选择',
      items: actions,
      onConfirm: (item) async {
        try {
          final file = await ImagePicker().pickImage( source: item['type'] == 'camera' ? ImageSource.camera : ImageSource.gallery);
          final avatarFile = File(file!.path);
          String uploadImageUrl = await UploadApi.uploadImage(avatarFile, '/api/uploads');
          sendMessageToH5('uploadImageUrl:$uploadImageUrl');
        } catch (e) {
          // print(e.toString());
        }
      },
    );
  }
}
