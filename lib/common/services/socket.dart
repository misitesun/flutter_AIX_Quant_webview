import 'package:XSmartPay/common/index.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

/// WebSocket连接状态
enum SocketConnectionState {
  disconnected, // 未连接
  connecting, // 连接中
  connected, // 已连接
  reconnecting, // 重连中
}

/// WebSocket管理器，处理连接、消息收发、重连和心跳
///
/// 使用示例:
/// ```dart
/// // 初始化
/// final socket = SocketService();
///
/// // 连接
/// socket.connect();
///
/// // 监听消息
/// socket.onMessage((data) {
///   print('收到消息: $data');
/// });
///
/// // 发送消息
/// socket.sendMessage({'type': 'chat', 'content': '你好'});
///
/// // 断开连接
/// socket.disconnect();
/// ```
class SocketService extends GetxService {
  // 单例模式
  static final SocketService _instance = SocketService._internal();
  // 单例模式
  factory SocketService() => _instance;
  // 单例模式
  SocketService._internal();

  // WebSocket连接和状态
  WebSocketChannel? _channel;
  // 消息流
  final StreamController<dynamic> _messageController =
      StreamController<dynamic>.broadcast();
  // 连接状态
  SocketConnectionState _connectionState = SocketConnectionState.disconnected;
  // 重连相关
  Timer? _reconnectTimer;
  // 重连次数
  int _reconnectAttempts = 0;
  // 最大重连次数
  final int _maxReconnectAttempts = 10;
  // 重连延迟
  final Duration _reconnectDelay = const Duration(seconds: 3);
  // 连接参数
  late String _wsUrl;
  // Stream订阅
  StreamSubscription? _subscription;
  // 维护所有已订阅的频道
  final Set<String> _subscribedChannels = {};
  // 在 SocketService 类中添加
  final StreamController<SocketConnectionState> _stateController =
      StreamController<SocketConnectionState>.broadcast();
  Stream<SocketConnectionState> get stateStream => _stateController.stream;

  /// 当前连接状态
  SocketConnectionState get connectionState => _connectionState;

  /// 消息流，可用于监听接收到的所有消息
  Stream<dynamic> get messageStream => _messageController.stream;

  /// 初始化WebSocket
  Future<void> init() async {
    _wsUrl = Constants.wpSocketUrl;
  }

  /// 连接到WebSocket服务器
  Future<void> connect() async {
    _wsUrl = Constants.wpSocketUrl;
    final token = Storage().getString('token');
    if (token.isEmpty) {
      // log.w('未登录，不连接WebSocket');
      return;
    }

    _connectionState = SocketConnectionState.connecting;
    _stateController.add(_connectionState);
    _closeConnection();

    try {
      final wsUrl = Uri.parse(_wsUrl);
      // log.i('正在连接WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(wsUrl);

      // 等待连接准备就绪
      await _channel!.ready.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('WebSocket连接超时');
        },
      );

      _connectionState = SocketConnectionState.connected;
      _stateController.add(_connectionState);
      _reconnectAttempts = 0;

      // 监听消息
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onDone: _handleDisconnect,
        onError: _handleError,
        cancelOnError: false,
      );

      // log.i('WebSocket连接成功');
      _onConnected();
    } catch (e) {
      // log.e('WebSocket连接失败', error: e);
      _connectionState = SocketConnectionState.disconnected;
      _stateController.add(_connectionState);
      _attemptReconnect();
    }
  }

  /// 重新连接
  Future<void> reconnect() async {
    // log.i('执行重连...');
    await disconnect();
    await Future.delayed(const Duration(milliseconds: 500)); // 短暂延迟确保完全断开
    await connect();
  }

  /// 处理接收到的消息
  void _handleMessage(dynamic message) {
    try {
      if (message is String) {
        try {
          final dynamic jsonData = jsonDecode(message);

          // 1. 被动心跳处理
          if (jsonData is Map && jsonData['type'] == 'ping') {
            // 收到ping，回复pong
            sendMessage({'cmd': 'pong'});
            // log.d('收到ping，已回复pong');
            return;
          }

          // 2. 其它心跳包（如果有）
          if (jsonData is Map && jsonData['event'] == 'heartbeat') {
            // log.d('收到心跳响应: $jsonData');
            return;
          }

          // 3. 正常业务数据
          _messageController.add(jsonData);
          // _processChatMessage(jsonData);
        } catch (e) {
          // 非JSON字符串直接发送
          _messageController.add(message);
        }
      } else {
        // 非字符串消息直接发送
        _messageController.add(message);
      }
    } catch (e) {
      // log.e('处理消息出错', error: e);
    }
  }

  /// 处理连接断开
  void _handleDisconnect() async {
    // log.w('WebSocket连接已断开');
    _connectionState = SocketConnectionState.disconnected;
    _stateController.add(_connectionState);

    // 检查token是否仍然有效
    if (Storage().getString('token').isNotEmpty) {
      _attemptReconnect();
    }
  }

  /// 处理连接错误
  void _handleError(dynamic error) {
    // log.e('WebSocket连接错误', error: error);
    _connectionState = SocketConnectionState.disconnected;
    _stateController.add(_connectionState);
    _attemptReconnect();
  }

  /// 尝试重连
  void _attemptReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      // log.e('重连失败: 已达到最大重试次数 ($_maxReconnectAttempts)');
      return;
    }

    _connectionState = SocketConnectionState.reconnecting;
    _stateController.add(_connectionState);
    _reconnectAttempts++;

    // 使用指数退避算法计算延迟时间
    final delay = Duration(
        milliseconds: _reconnectDelay.inMilliseconds *
            (1 << _reconnectAttempts.clamp(0, 5)));

    // log.i('尝试重连 #$_reconnectAttempts, $delay 后重试');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  /// 发送原始消息
  void sendRaw(String message) {
    if (_connectionState != SocketConnectionState.connected ||
        _channel == null) {
      // log.w('发送失败: 未连接到WebSocket服务器');
      return;
    }

    try {
      _channel!.sink.add(message);
    } catch (e) {
      // log.e('发送消息失败', error: e);
      _handleDisconnect();
    }
  }

  /// 发送JSON消息
  void sendMessage(dynamic data) {
    // log.d('发送订阅消息: $data');
    if (data == null) {
      // log.w('无法发送: 数据为空');
      return;
    }

    try {
      final String jsonStr = data is String ? data : jsonEncode(data);
      sendRaw(jsonStr);
    } catch (e) {
      // log.e('JSON编码失败', error: e);
    }
  }

  /// 关闭WebSocket连接
  Future<void> disconnect({int? code, String? reason}) async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    // log.i('正在断开WebSocket连接...');
    await _closeConnection(code: code, reason: reason);
    _connectionState = SocketConnectionState.disconnected;
    _stateController.add(_connectionState);
    // log.i('WebSocket连接已断开');
  }

  /// 关闭连接
  Future<void> _closeConnection({int? code, String? reason}) async {
    _subscription?.cancel();
    _subscription = null;

    if (_channel != null) {
      try {
        await _channel!.sink.close(code ?? status.normalClosure, reason);
      } catch (e) {
        // log.e('关闭连接时出错', error: e);
      } finally {
        _channel = null;
      }
    }
  }

  /// 添加消息监听器
  void onMessage(void Function(dynamic data) callback) {
    messageStream.listen(callback);
  }

  /// 添加特定事件监听器
  StreamSubscription onEvent(
      String eventName, void Function(dynamic data) callback) {
    return messageStream.listen((data) {
      if (data is Map &&
          data.containsKey('event') &&
          data['event'] == eventName) {
        callback(data);
      }
    });
  }

  /// 释放资源
  void dispose() {
    disconnect();
    _messageController.close();
  }

  // 连接成功后自动补发所有订阅
  void _onConnected() {
    for (var msg in _subscribedChannels) {
      sendMessage({"cmd": "sub", "msg": msg});
    }
  }

  // 订阅频道
  void subscribe(String msg) {
    _subscribedChannels.add(msg);
    if (_connectionState == SocketConnectionState.connected) {
      sendMessage({"cmd": "sub", "msg": msg});
    }
  }

  // 取消订阅频道
  void unsubscribe(String msg) {
    _subscribedChannels.remove(msg);
    if (_connectionState == SocketConnectionState.connected) {
      sendMessage({"cmd": "unsub", "msg": msg});
    }
  }
}

/*
  使用示例：
  final socket = SocketService();
  socket.connect();
  socket.onMessage((data) {
    print('收到消息: $data');
  });
  socket.sendMessage({'type': 'chat', 'content': '你好'});
  socket.disconnect();

  
 */
