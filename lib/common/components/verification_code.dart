import 'package:XSmartPay/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

/// 验证码组件
/* 使用示例
  VerificationCodeWidget(
    mobile: '1234567890',
    type: 'register',
    onRequestCode: (mobile, type) async {
      return await controller.sendCode();
    },
  );

  // 发送验证码
  Future<bool> sendCode() async {
    if (emailController.text.isEmpty) {
      Loading.toast('请输入邮箱号');
      return false;
    }
    Loading.show();
    var res = await UserApi.sendCode(
        UserSendCodeReq(email: emailController.text, type: 'register'));
    if (res) {
      Loading.success('发送成功');
      return true;
    } else {
      return false;
    }
  }
*/
class VerificationCodeWidget extends StatefulWidget {
  final String mobile;
  final String type;
  final Future<bool> Function(String mobile, String type) onRequestCode;

  const VerificationCodeWidget({
    super.key,
    required this.mobile,
    required this.type,
    required this.onRequestCode,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VerificationCodeWidgetState createState() => _VerificationCodeWidgetState();
}

class _VerificationCodeWidgetState extends State<VerificationCodeWidget> {
  int _seconds = 0;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _seconds = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _timer?.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _seconds == 0
          ? () async {
              bool success =
                  await widget.onRequestCode(widget.mobile, widget.type);
              if (success) {
                _startTimer();
              }
            }
          : null,
      child: Text(
        _seconds == 0 ? '获取验证码'.tr : '$_seconds S',
        style: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.w600,
          color: _seconds == 0 ? AppTheme.primary : AppTheme.color999,
        ),
      ),
    );
  }
}
