import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';

/// 进度条
/* 使用示例
ProgressBar(
  progress: 70,
  width: 300,
  height: 24,
);
*/
class ProgressBar extends StatelessWidget {
  /// 进度值，范围0.0-1.0
  final double progress;

  /// 进度条宽度
  final double width;

  /// 进度条高度
  final double height;

  /// 背景颜色
  final Color backgroundColor;

  /// 高亮（进度）颜色
  final Color highlightColor;

  /// 圆角大小（背景和进度条使用相同的圆角）
  final double borderRadius;

  /// 动画持续时间
  final Duration animationDuration;

  /// 是否显示动画
  final bool animate;

  const ProgressBar({
    super.key,
    required this.progress,
    required this.width,
    this.height = 40,
    this.backgroundColor = const Color(0xFF1D1D1D),
    this.highlightColor = Colors.blue,
    this.borderRadius = 20,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animate = true,
  }) : assert(progress >= 0.0 && progress <= 1.0, "进度值必须在0.0到1.0之间");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.w),
      ),
      child: Stack(
        children: [
          // 进度条高亮部分
          animate
              ? AnimatedContainer(
                  duration: animationDuration,
                  width: width.w * progress,
                  height: height.w,
                  decoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: BorderRadius.circular(borderRadius.w),
                  ),
                )
              : Container(
                  width: width.w * progress,
                  height: height.w,
                  decoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: BorderRadius.circular(borderRadius.w),
                  ),
                ),
        ],
      ),
    );
  }
}

// 示例：如何使用
// ProgressBar(
//   progress: 0.7,
//   width: 300,
//   height: 24,
//   backgroundColor: Colors.grey[800]!,
//   highlightColor: Colors.blue,
//   borderRadius: 12,
// )
