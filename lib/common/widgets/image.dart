import 'package:cached_network_image/cached_network_image.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// 图片组件
class ImgWidget extends StatefulWidget {
  const ImgWidget({
    super.key,
    required this.path,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.elevation,
    this.color,
  });

  /// 文件路径
  final String path;

  /// 圆角
  final double? radius;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 自适应方式
  final BoxFit? fit;

  /// 占位图
  final Widget? placeholder;

  /// 错误图
  final Widget? errorWidget;

  /// 阴影
  final double? elevation;

  /// 颜色
  final Color? color;

  const ImgWidget.img(
    this.path, {
    super.key,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.elevation,
    this.color,
  });

  const ImgWidget.svg(
    this.path, {
    super.key,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.elevation,
    this.color,
  });

  const ImgWidget.svgRaw(
    String raw, {
    super.key,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.elevation,
    this.color,
  }) : path = raw;

  @override
  State<ImgWidget> createState() => _ImgWidgetState();
}

class _ImgWidgetState extends State<ImgWidget> {
  Widget _buildView() {
    Widget ws = widget.placeholder ?? const SizedBox();

    // 判断图片类型
    bool isNetwork = widget.path.startsWith('http') ||
        widget.path.startsWith('https') ||
        widget.path.startsWith('//');
    bool isSvg = widget.path.toLowerCase().endsWith('.svg');
    bool isSvgRaw = widget.path.contains('<svg');

    // 确定 fit 属性
    BoxFit finalFit = widget.fit ?? BoxFit.scaleDown;
    if (widget.width != null && widget.height != null) {
      finalFit = BoxFit.fill;
    }

    // 1 图片
    if (isSvgRaw) {
      // svg raw
      ws = SvgPicture.string(
        widget.path,
        fit: finalFit,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (BuildContext context) =>
            widget.placeholder ??
            Center(
              child: const CircularProgressIndicator().tightSize(20).center(),
            ),
      );
    } else if (isSvg) {
      // svg 图片
      if (isNetwork) {
        ws = SvgPicture.network(
          widget.path,
          fit: finalFit,
          colorFilter: widget.color != null
              ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (BuildContext context) =>
              widget.placeholder ??
              Center(
                child: const CircularProgressIndicator().tightSize(20).center(),
              ),
        );
      } else {
        ws = SvgPicture.asset(
          widget.path,
          fit: finalFit,
          colorFilter: widget.color != null
              ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: (BuildContext context) =>
              widget.placeholder ??
              Center(
                child: const CircularProgressIndicator().tightSize(20).center(),
              ),
        );
      }
    } else {
      // 普通图片
      if (isNetwork) {
        ws = CachedNetworkImage(
          imageUrl: widget.path,
          fit: finalFit,
          cacheKey: widget.path.hashCode.toString(),
          color: widget.color,
          placeholder: (context, url) =>
              widget.placeholder ??
              const CircularProgressIndicator().tightSize(20).center(),
          errorWidget: (context, url, error) =>
              widget.errorWidget ?? const Icon(Icons.error),
        );
      } else {
        ws = Image.asset(
          widget.path,
          fit: finalFit,
          color: widget.color,
        );
      }
    }

    // 2 约束
    if (widget.width != null || widget.height != null) {
      ws = ws.tight(
        width: widget.width,
        height: widget.height,
      );
    }

    // 3 圆角
    ws = ws.clipRRect(all: widget.radius ?? 0);

    return ws;
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
