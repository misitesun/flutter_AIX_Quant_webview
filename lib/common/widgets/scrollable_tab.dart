import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 可滚动Tab
/* 使用示例
  Widget _buildTab() {
    return ScrollableTab(
      tabs: [
        ScrollableTabData(title: '星火', value: 1),
        ScrollableTabData(title: '余额', value: 2),
        ScrollableTabData(title: '信用分', value: 3),
      ],
      currentIndex: controller.currentTab,
      onTabChanged: (index) {
        controller.onTabChanged(index);
      },
      selectedColor: AppTheme.primary,
      unselectedColor: AppTheme.colorfff,
      selectedTextColor: AppTheme.colorfff,
      unselectedTextColor: AppTheme.color7981,
    );
  }

  // 当前选中的tab
  int currentTab = 1;

  // 切换tab
  void onTabChanged(int index) {
    currentTab = index;
    update(["assets_record"]);
  }
*/
class ScrollableTabData {
  final String title;
  final int value;

  ScrollableTabData({required this.title, required this.value});
}

class ScrollableTab extends StatefulWidget {
  /// Tab数据列表
  final List<ScrollableTabData> tabs;

  /// 当前选中的索引值
  final int currentIndex;

  /// Tab切换回调
  final Function(int) onTabChanged;

  /// 是否可滚动，当Tab项较多时，设置为true
  final bool scrollable;

  /// 单个Tab的最小宽度
  final double minTabWidth;

  /// 单个Tab的高度
  final double tabHeight;

  /// 背景颜色
  final Color backgroundColor;

  /// 选中时的颜色
  final Color selectedColor;

  /// 未选中时的颜色
  final Color unselectedColor;

  /// 选中时的文字颜色
  final Color selectedTextColor;

  /// 未选中时的文字颜色
  final Color unselectedTextColor;

  /// 边框圆角
  final double borderRadius;

  /// 字体大小
  final double fontSize;

  /// 边框颜色
  final Color borderColor;

  /// 动画持续时间
  final Duration animationDuration;

  const ScrollableTab({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.scrollable = false,
    this.minTabWidth = 100,
    this.tabHeight = 68,
    this.backgroundColor = Colors.blue,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.transparent,
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.grey,
    this.borderRadius = 16,
    this.fontSize = 28,
    this.borderColor = Colors.blue,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  State<ScrollableTab> createState() => _ScrollableTabState();
}

class _ScrollableTabState extends State<ScrollableTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  late double _tabWidth;
  late int _prevIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scrollController = ScrollController();
    _prevIndex = widget.currentIndex;

    // 计算每个Tab的宽度
    _updateTabWidth();
  }

  @override
  void didUpdateWidget(ScrollableTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 更新Tab宽度
    if (oldWidget.tabs.length != widget.tabs.length ||
        oldWidget.minTabWidth != widget.minTabWidth) {
      _updateTabWidth();
    }

    // 如果索引变化，执行动画并滚动
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0.0);
      _prevIndex = oldWidget.currentIndex;

      // 自动滚动到可见区域
      if (widget.scrollable) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelectedTab();
        });
      }
    }
  }

  void _updateTabWidth() {
    // 计算可用总宽度 (屏幕宽度 - 左右边距)
    final availableWidth = 750.w - 60.w;

    // 根据Tab数量计算每个Tab的宽度
    if (widget.tabs.length <= 3 || !widget.scrollable) {
      // 如果Tab数量较少或不可滚动，平均分配宽度
      _tabWidth = availableWidth / widget.tabs.length;
    } else {
      // 如果可滚动且数量较多，使用最小宽度
      _tabWidth = math.max(widget.minTabWidth.w, availableWidth / 3);
    }
  }

  void _scrollToSelectedTab() {
    final double targetPosition = widget.currentIndex * _tabWidth;
    final double screenWidth = 750.w - 60.w;
    final double offset = targetPosition - (screenWidth / 2) + (_tabWidth / 2);

    _scrollController.animateTo(
      math.max(0, math.min(offset, _scrollController.position.maxScrollExtent)),
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.tabHeight.w + 10.w,
      margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 6.w),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: widget.borderColor),
        borderRadius: BorderRadius.circular(widget.borderRadius.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius.w - 5.w),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: widget.scrollable
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // 计算容器总宽度
                final containerWidth = _tabWidth * widget.tabs.length;

                return SizedBox(
                  width: containerWidth,
                  height: widget.tabHeight.w,
                  child: Stack(
                    children: [
                      // 动画背景 - 现在放在滚动内容的Stack中
                      Positioned(
                        left: _calculateBackgroundPosition(),
                        top: 0,
                        child: Container(
                          width: _tabWidth,
                          height: widget.tabHeight.w,
                          decoration: BoxDecoration(
                            color: widget.selectedColor,
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius.w - 5.w),
                          ),
                        ),
                      ),

                      // Tab内容
                      Row(
                        children: List.generate(
                          widget.tabs.length,
                          (index) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (widget.currentIndex !=
                                  widget.tabs[index].value) {
                                widget.onTabChanged(widget.tabs[index].value);
                              }
                            },
                            child: Container(
                              width: _tabWidth,
                              height: widget.tabHeight.w,
                              alignment: Alignment.center,
                              child: Text(
                                widget.tabs[index].title,
                                style: TextStyle(
                                  fontSize: widget.fontSize.sp,
                                  color: widget.currentIndex ==
                                          widget.tabs[index].value
                                      ? widget.selectedTextColor
                                      : widget.unselectedTextColor,
                                  fontWeight: widget.currentIndex ==
                                          widget.tabs[index].value
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // 计算背景位置，考虑动画效果
  double _calculateBackgroundPosition() {
    // 找到当前和上一个索引对应的值的索引位置
    int currentTabIndex =
        widget.tabs.indexWhere((tab) => tab.value == widget.currentIndex);
    int prevTabIndex = widget.tabs.indexWhere((tab) => tab.value == _prevIndex);

    // 防止找不到索引的情况（通常不会发生）
    if (currentTabIndex == -1) currentTabIndex = 0;
    if (prevTabIndex == -1) prevTabIndex = 0;

    // 计算开始和结束位置
    final double beginPosition = prevTabIndex * _tabWidth;
    final double endPosition = currentTabIndex * _tabWidth;

    // 根据动画进度计算当前位置
    return beginPosition + (endPosition - beginPosition) * _controller.value;
  }
}
