import 'dart:async';
import 'package:flutter/material.dart';

/*
  倒计时组件
  
  // 基本使用
  CountdownTimer(
    seconds: 3600, // 1小时
  )

  // 自定义样式
  CountdownTimer(
    seconds: 3600,
    fontSize: 20,
    textColor: Colors.red,
  )

  // 只显示分秒
  CountdownTimer(
    seconds: 3600,
    showDays: false,
    showHours: false,
  )

  // 自定义分隔符
  CountdownTimer(
    seconds: 3600,
    separator: " - ",
  )

 */

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final double? fontSize;
  final Color? textColor;
  final bool showDays;
  final bool showHours;
  final bool showMinutes;
  final bool showSeconds;
  final String separator;

  const CountdownTimer({
    super.key,
    required this.seconds,
    this.fontSize,
    this.textColor,
    this.showDays = true,
    this.showHours = true,
    this.showMinutes = true,
    this.showSeconds = true,
    this.separator = " : ",
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int _remainingSeconds;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.seconds;
    _startTimer();
  }

  @override
  void dispose() {
    _mounted = false;
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_mounted) return;

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingSeconds ~/ (24 * 3600);
    final hours = (_remainingSeconds % (24 * 3600)) ~/ 3600;
    final minutes = (_remainingSeconds % 3600) ~/ 60;
    final seconds = _remainingSeconds % 60;

    List<String> timeParts = [];

    if (widget.showDays && days > 0) {
      timeParts.add(_formatNumber(days));
    }
    if (widget.showHours) {
      timeParts.add(_formatNumber(hours));
    }
    if (widget.showMinutes) {
      timeParts.add(_formatNumber(minutes));
    }
    if (widget.showSeconds) {
      timeParts.add(_formatNumber(seconds));
    }

    return Text(
      timeParts.join(widget.separator),
      style: TextStyle(
        fontSize: widget.fontSize ?? 14,
        color: widget.textColor ?? Colors.black,
      ),
    );
  }
}
