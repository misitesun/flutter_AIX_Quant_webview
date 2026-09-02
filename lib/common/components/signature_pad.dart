import 'dart:typed_data';
import 'package:XSmartPay/common/index.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// 签名板
/*
  使用示例
  // 弹出签名框
  void onSignPopup() async{
    SignaturePad.show(
      backgroundColor: Colors.white,
      titleColor: AppTheme.colorfff,
      penColor: Colors.black,
      convertToJpg: true, // 转换为JPG格式
      jpgQuality: 90, // JPG质量
      onConfirm: (data) async {
        Loading.show();
        if (data != null) {
          // 保存签名图片到本地文件
          final filePath = await SignaturePad.saveSignatureToFile(
            data, 
            isJpg: true
          );
          
          if (filePath != null) {
            // 调用图片合成
            final composedPath = await ImageComposer.composeImages(
              contractImageUrl: machineAgreement, // 合同图片
              signatureImagePath: filePath, // 签名图片
              signaturePosition: SignaturePosition.bottomRight, // 签名定位
              margin: const EdgeInsets.only(left: 40,right: 20,bottom: 200), // 定位偏移
              dateMargin: const EdgeInsets.only(left: 40,right: 20,bottom: 100), // 日期偏移
            );
            String imageUrl = await UploadApi.uploadImage(File(composedPath));
            Loading.success('签名成功');
            // 返回签名图片的URL
            Get.back(result: imageUrl);
          } else {
            Loading.error('签名失败');
          }
        }
      },
    );
  }
 */
class SignaturePad {
  /// 显示签名板
  /// [backgroundColor] 签名区域背景色
  /// [titleColor] 标题文字颜色
  /// [penColor] 签名笔颜色
  /// [onConfirm] 确认回调，返回签名图片的PNG字节数据
  static Future<void> show({
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.white,
    Color penColor = Colors.black,
    required Function(Uint8List?) onConfirm,
    bool convertToJpg = false,
    int jpgQuality = 90,
  }) async {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: penColor,
      exportBackgroundColor: backgroundColor,
    );

    await Get.bottomSheet(
      PopScope(
        canPop: false, // 禁止通过返回键或滑动关闭
        child: Container(
          height: 800.w,
          decoration: BoxDecoration(
            color: AppTheme.blockTwoBgColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.w),
            ),
          ),
          child: Column(
            children: [
              // 顶部标题栏
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
                child: Column(
                  children: [
                    // 标题和清除按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget.body(
                          '签署'.tr,
                          size: 32.sp,
                          color: titleColor,
                          weight: FontWeight.w600,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            child: TextWidget.body(
                              '清除'.tr,
                              size: 28.sp,
                              color: titleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    // 提示文字
                    TextWidget.body(
                      '请在下方区域签名'.tr,
                      size: 24.sp,
                      color: AppTheme.color999,
                    ),
                  ],
                ),
              ),
              // 签名区域
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Signature(
                    controller: controller,
                    // backgroundColor: backgroundColor,
                  ),
                ),
              ),
              // 底部按钮
              Container(
                padding: EdgeInsets.all(30.w),
                child: Row(
                  children: [
                    // 取消按钮
                    Expanded(
                      child: Container(
                        height: 90.w,
                        decoration: BoxDecoration(
                          color: AppTheme.blockBgColor,
                          borderRadius: BorderRadius.circular(45.w),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45.w),
                            ),
                          ),
                          child: TextWidget.body(
                            '取消'.tr,
                            size: 28.sp,
                            color: titleColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    // 确认按钮
                    Expanded(
                      child: Container(
                        height: 90.w,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(45.w),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (controller.isEmpty) {
                              Loading.toast('请签名后再确认'.tr);
                              return;
                            }

                            final pngData = await controller.toPngBytes();

                            if (pngData != null) {
                              if (convertToJpg) {
                                try {
                                  // 转换为JPG格式
                                  final jpgData = await _convertPngToJpg(
                                      pngData, jpgQuality);
                                  Get.back();
                                  onConfirm(jpgData);
                                } catch (e) {
                                  Loading.toast('图片转换失败'.tr);
                                  Get.back();
                                  onConfirm(pngData); // 转换失败时返回原始PNG数据
                                }
                              } else {
                                Get.back();
                                onConfirm(pngData);
                              }
                            } else {
                              Loading.toast('签名生成失败'.tr);
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45.w),
                            ),
                          ),
                          child: TextWidget.body(
                            '确认'.tr,
                            size: 28.sp,
                            color: Colors.white,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false, // 禁止拖拽关闭
      isDismissible: false, // 禁止点击外部关闭
    );

    // 释放控制器
    controller.dispose();
  }

  /// 将PNG字节数据转换为JPG格式
  static Future<Uint8List> _convertPngToJpg(
      Uint8List pngData, int quality) async {
    // 使用image包解码PNG
    final pngImage = img.decodePng(pngData);
    if (pngImage == null) {
      throw Exception('无法解码PNG图片');
    }

    // 转换为JPG格式
    final jpgData = img.encodeJpg(pngImage, quality: quality);
    return Uint8List.fromList(jpgData);
  }

  /// 保存签名图片到本地文件
  static Future<String?> saveSignatureToFile(Uint8List imageData,
      {bool isJpg = false}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = isJpg ? 'jpg' : 'png';
      final path = '${directory.path}/signature_$timestamp.$extension';

      final file = File(path);
      await file.writeAsBytes(imageData);
      return path;
    } catch (e) {
      // print('保存签名图片失败: $e');
      return null;
    }
  }
}
