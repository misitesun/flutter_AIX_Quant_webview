import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';

class MarqueeNotice extends StatefulWidget {
  /// 公告数据列表，每条公告包含title和desc
  final List<Map<String, String>> notices;

  /// 滚动速度，数值越小滚动越快（像素/秒）
  final double scrollSpeed;

  /// 背景颜色
  final Color backgroundColor;

  /// 公告栏高度
  final double height;

  /// 公告图标
  final Widget? icon;

  /// 公告文本颜色
  final Color textColor;

  /// 公告字体大小
  final double fontSize;

  /// 公告条目间距
  final double itemSpacing;

  const MarqueeNotice({
    super.key,
    required this.notices,
    this.scrollSpeed = 50.0,
    this.backgroundColor = Colors.transparent,
    this.height = 40,
    this.icon,
    this.textColor = Colors.white,
    this.fontSize = 24,
    this.itemSpacing = 60,
  });

  @override
  State<MarqueeNotice> createState() => _MarqueeNoticeState();
}

class _MarqueeNoticeState extends State<MarqueeNotice>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Timer _timer;
  late List<Map<String, String>> _extendedNotices;
  double _scrollOffset = 0.0;
  double _maxScrollExtent = 0.0;

  @override
  void initState() {
    super.initState();

    // 扩展公告列表使其可以循环滚动（复制一份公告列表）
    _extendedNotices = [...widget.notices, ...widget.notices];

    _scrollController = ScrollController();

    // 在布局完成后开始滚动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  // 开始滚动动画
  void _startScrolling() {
    // 测量滚动区域总宽度的一半（原始公告列表的宽度）
    _maxScrollExtent = _scrollController.position.maxScrollExtent / 2;

    // 设置定时器，实现滚动效果
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _scrollOffset += 1.0;

      // 当滚动到第一份公告列表的末尾时，重置到开头位置
      if (_scrollOffset >= _maxScrollExtent) {
        _scrollOffset = 0.0;
        _scrollController.jumpTo(_scrollOffset);
      } else {
        _scrollController.animateTo(
          _scrollOffset,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.w,
      color: widget.backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(), // 禁用手动滚动
        child: Row(
          children: _buildNoticeItems(),
        ),
      ),
    );
  }

  List<Widget> _buildNoticeItems() {
    return _extendedNotices.map((notice) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: widget.itemSpacing.w / 2),
        child: Row(
          children: [
            // 如果提供了图标，则显示图标
            if (widget.icon != null) ...[
              widget.icon!,
              SizedBox(width: 10.w),
            ],

            // 公告文本
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${notice['title']} ",
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: notice['desc'],
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
