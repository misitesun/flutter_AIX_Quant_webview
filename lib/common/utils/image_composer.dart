import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// 图片合成工具类
/*
  使用示例
  final composedPath = await ImageComposer.composeImages(
    contractImageUrl: machineAgreement, // 合同图片
    signatureImagePath: filePath, // 签名图片
    signaturePosition: SignaturePosition.bottomRight, // 签名定位
    margin: const EdgeInsets.only(left: 40,right: 20,bottom: 200), // 定位偏移
    dateMargin: const EdgeInsets.only(left: 40,right: 20,bottom: 100), // 日期偏移
  );
*/
class ImageComposer {
  /// 合成图片
  /// [contractImageUrl] 合同图片URL
  /// [signatureImagePath] 签名图片本地路径
  /// [signaturePosition] 签名在合同上的位置，默认右下角
  /// [signatureSize] 签名图片大小，默认宽度为合同宽度的1/4
  /// [margin] 签名距离边缘的边距
  /// [dateMargin] 日期距离边缘的边距
  /// 返回合成后的图片路径
  static Future<String> composeImages({
    required String contractImageUrl,
    required String signatureImagePath,
    SignaturePosition signaturePosition = SignaturePosition.bottomRight,
    Size? signatureSize,
    EdgeInsets margin = const EdgeInsets.all(20),
    EdgeInsets? dateMargin,
  }) async {
    try {
      // 下载合同图片
      final contractImageBytes = await _downloadImage(contractImageUrl);
      final contractImage = img.decodeImage(contractImageBytes);
      if (contractImage == null) {
        throw Exception('无法解码合同图片');
      }

      // 读取签名图片
      final signatureImageFile = File(signatureImagePath);
      final signatureImageBytes = await signatureImageFile.readAsBytes();
      final signatureImage = img.decodeImage(signatureImageBytes);
      if (signatureImage == null) {
        throw Exception('无法解码签名图片');
      }

      // 计算签名图片大小
      double signatureWidth = signatureSize?.width ?? (contractImage.width / 4);
      double signatureHeight = signatureSize?.height ??
          (signatureImage.height * signatureWidth / signatureImage.width);

      // 调整签名图片大小
      final resizedSignature = img.copyResize(
        signatureImage,
        width: signatureWidth.toInt(),
        height: signatureHeight.toInt(),
        interpolation: img.Interpolation.linear,
      );

      // 计算签名位置
      int x = 0;
      int y = 0;

      switch (signaturePosition) {
        case SignaturePosition.bottomRight:
          x = contractImage.width -
              resizedSignature.width -
              margin.right.toInt();
          y = contractImage.height -
              resizedSignature.height -
              margin.bottom.toInt();
          break;
        case SignaturePosition.bottomLeft:
          x = margin.left.toInt();
          y = contractImage.height -
              resizedSignature.height -
              margin.bottom.toInt();
          break;
        case SignaturePosition.topRight:
          x = contractImage.width -
              resizedSignature.width -
              margin.right.toInt();
          y = margin.top.toInt();
          break;
        case SignaturePosition.topLeft:
          x = margin.left.toInt();
          y = margin.top.toInt();
          break;
        case SignaturePosition.center:
          x = (contractImage.width - resizedSignature.width) ~/ 2;
          y = (contractImage.height - resizedSignature.height) ~/ 2;
          break;
        case SignaturePosition.custom:
          x = margin.left.toInt();
          y = margin.top.toInt();
          break;
      }

      // 合成图片
      img.compositeImage(
        contractImage,
        resizedSignature,
        dstX: x,
        dstY: y,
      );

      // 添加签署日期
      final dateMarginToUse =
          dateMargin ?? const EdgeInsets.only(left: 40, right: 20, bottom: 200);
      final date = DateFormat('yyyy年MM月dd日').format(DateTime.now());

      // 创建日期图片
      final dateImage = await _createDateImage(date);
      final dateImageBytes =
          await dateImage.toByteData(format: ui.ImageByteFormat.png);
      if (dateImageBytes == null) {
        throw Exception('无法转换日期图片');
      }

      final dateImg = img.decodeImage(dateImageBytes.buffer.asUint8List());
      if (dateImg == null) {
        throw Exception('无法解码日期图片');
      }

      // 计算日期位置
      final dateX =
          contractImage.width - dateImg.width - dateMarginToUse.right.toInt();
      final dateY = contractImage.height -
          dateImg.height -
          dateMarginToUse.bottom.toInt();

      img.compositeImage(
        contractImage,
        dateImg,
        dstX: dateX,
        dstY: dateY,
      );

      // 保存合成后的图片
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${tempDir.path}/composed_image_$timestamp.png';
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodePng(contractImage));

      return outputPath;
    } catch (e) {
      throw Exception('图片合成失败: $e');
    }
  }

  /// 创建日期图片
  static Future<ui.Image> _createDateImage(String dateText) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final textPainter = TextPainter(
      text: TextSpan(
        text: dateText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();
    final size = Size(textPainter.width + 20, textPainter.height + 10);

    // 绘制文字
    textPainter.paint(canvas, const Offset(10, 5));

    final picture = recorder.endRecording();
    return picture.toImage(size.width.ceil(), size.height.ceil());
  }

  /// 下载图片
  static Future<Uint8List> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('下载图片失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('下载图片失败: $e');
    }
  }
}

/// 签名位置枚举
enum SignaturePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center,
  custom,
}
