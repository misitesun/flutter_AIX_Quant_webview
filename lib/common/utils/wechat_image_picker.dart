import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:XSmartPay/common/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
/*
  使用示例

/// WechatImagePicker 使用示例
class WechatImagePickerExample {
  /// 示例1：选择单张图片（自动压缩）
  static void pickSingleImage(BuildContext context) {
    WechatImagePicker.showImagePicker(
      context: context,
      maxAssets: 1, // 单张选择
      autoCompress: true, // 自动压缩
      onSingleResult: (File? compressedFile) {
        if (compressedFile != null) {
          print('单张图片选择成功: ${compressedFile.path}');
          // 这里处理选择的图片，已经是压缩后的
        } else {
          print('用户取消选择或选择失败');
        }
      },
    );
  }

  /// 示例2：选择多张图片（最多9张，自动压缩）
  static void pickMultipleImages(BuildContext context) {
    WechatImagePicker.showImagePicker(
      context: context,
      maxAssets: 9, // 最多选择9张
      autoCompress: true, // 自动压缩
      onMultiResult: (List<File> compressedFiles) {
        if (compressedFiles.isNotEmpty) {
          print('多张图片选择成功: ${compressedFiles.length}张');
          for (int i = 0; i < compressedFiles.length; i++) {
            print('图片${i + 1}: ${compressedFiles[i].path}');
          }
          // 这里处理选择的图片列表，都是压缩后的
        } else {
          print('用户取消选择或选择失败');
        }
      },
    );
  }

  /// 示例3：选择单张图片（不压缩）
  static void pickSingleImageWithoutCompress(BuildContext context) {
    WechatImagePicker.showImagePicker(
      context: context,
      maxAssets: 1,
      autoCompress: false, // 不压缩
      onSingleResult: (File? originalFile) {
        if (originalFile != null) {
          print('单张原图选择成功: ${originalFile.path}');
          // 这里处理原始图片
        }
      },
    );
  }

  /// 示例4：选择多张图片（最多3张，不压缩）
  static void pickMultipleImagesWithoutCompress(BuildContext context) {
    WechatImagePicker.showImagePicker(
      context: context,
      maxAssets: 3, // 最多选择3张
      autoCompress: false, // 不压缩
      onMultiResult: (List<File> originalFiles) {
        if (originalFiles.isNotEmpty) {
          print('多张原图选择成功: ${originalFiles.length}张');
          // 这里处理原始图片列表
        }
      },
    );
  }
}


 */

/// 微信风格图片选择器封装
class WechatImagePicker {
  /// 显示图片选择弹窗（相机 + 相册）
  /// 选择图片后自动压缩，返回压缩后的文件
  /// [maxAssets] 最大选择数量，1为单选，>1为多选
  /// [onSingleResult] 单张图片选择回调
  /// [onMultiResult] 多张图片选择回调
  static void showImagePicker({
    required BuildContext context,
    Function(File?)? onSingleResult,
    Function(List<File>)? onMultiResult,
    int maxAssets = 1,
    bool autoCompress = true,
  }) {
    // 验证回调参数
    if (maxAssets == 1 && onSingleResult == null) {
      throw ArgumentError('单张选择时必须提供 onSingleResult 回调');
    }
    if (maxAssets > 1 && onMultiResult == null) {
      throw ArgumentError('多张选择时必须提供 onMultiResult 回调');
    }

    List<Map<String, dynamic>> actions = [];

    // 单张选择时显示相机和相册选项
    if (maxAssets == 1) {
      actions = [
        {"id": 1, "title": "相机".tr, "type": "camera"},
        {"id": 2, "title": "相册".tr, "type": "gallery"},
      ];
    } else {
      // 多张选择时只显示相册选项
      actions = [
        {"id": 1, "title": "相册选择($maxAssets张)".tr, "type": "gallery"},
      ];
    }

    ActionSheetUtil.showActionSheet(
      context: context,
      title: '请选择'.tr,
      items: actions,
      onConfirm: (item) async {
        try {
          if (item['type'] == 'camera') {
            // 相机拍照（仅单张）
            final selectedFile = await _pickFromCamera(context);
            if (selectedFile != null && autoCompress) {
              final compressedFile = await _compressImage(selectedFile);
              onSingleResult!(compressedFile);
            } else {
              onSingleResult!(selectedFile);
            }
          } else if (item['type'] == 'gallery') {
            if (maxAssets == 1) {
              // 单张相册选择
              final selectedFile = await _pickFromGallery(context);
              if (selectedFile != null && autoCompress) {
                final compressedFile = await _compressImage(selectedFile);
                onSingleResult!(compressedFile);
              } else {
                onSingleResult!(selectedFile);
              }
            } else {
              // 多张相册选择
              final selectedFiles =
                  await _pickMultipleFromGallery(context, maxAssets);
              if (autoCompress && selectedFiles.isNotEmpty) {
                final compressedFiles =
                    await _compressMultipleImages(selectedFiles);
                onMultiResult!(compressedFiles);
              } else {
                onMultiResult!(selectedFiles);
              }
            }
          }
        } catch (e) {
          print('图片选择异常: $e');
          if (maxAssets == 1) {
            onSingleResult!(null);
          } else {
            onMultiResult!([]);
          }
        }
      },
    );
  }

  /// 直接从相机拍照
  static Future<File?> _pickFromCamera(BuildContext context) async {
    try {
      final AssetEntity? entity = await CameraPicker.pickFromCamera(
        context,
        pickerConfig: CameraPickerConfig(
          enableRecording: false,
          enableAudio: false,
          enableSetExposure: true,
          enableExposureControlOnPoint: true,
          enablePinchToZoom: true,
          shouldDeletePreviewFile: true,
          maximumRecordingDuration: const Duration(seconds: 15),
        ),
      );

      if (entity != null) {
        final File? file = await entity.file;
        if (file != null && await file.exists()) {
          print('相机拍照成功: ${file.path}');
          return file;
        }
      }
      return null;
    } catch (e) {
      print('相机拍照失败: $e');
      Loading.toast('相机拍照失败'.tr);
      return null;
    }
  }

  /// 直接从相册选择
  static Future<File?> _pickFromGallery(BuildContext context) async {
    try {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
          themeColor: Theme.of(context).primaryColor,
          textDelegate: const AssetPickerTextDelegate(),
        ),
      );

      if (assets != null && assets.isNotEmpty) {
        final File? file = await assets.first.file;
        if (file != null && await file.exists()) {
          print('相册选择成功: ${file.path}');
          return file;
        }
      }
      return null;
    } catch (e) {
      print('相册选择失败: $e');
      if (e.toString().contains('permission')) {
        Loading.toast('请允许访问相册权限'.tr);
      } else {
        Loading.toast('相册选择失败'.tr);
      }
      return null;
    }
  }

  /// 选择多张图片（仅相册）
  static Future<List<File>> pickMultipleImages(
    BuildContext context, {
    int maxAssets = 9,
  }) async {
    try {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssets,
          requestType: RequestType.image,
          themeColor: Theme.of(context).primaryColor,
          textDelegate: const AssetPickerTextDelegate(),
        ),
      );

      if (assets != null && assets.isNotEmpty) {
        final List<File> files = [];
        for (final asset in assets) {
          final File? file = await asset.file;
          if (file != null && await file.exists()) {
            files.add(file);
          }
        }
        return files;
      }
      return [];
    } catch (e) {
      print('多图片选择失败: $e');
      Loading.toast('图片选择失败'.tr);
      return [];
    }
  }

  /// 从相册选择多张图片
  static Future<List<File>> _pickMultipleFromGallery(
      BuildContext context, int maxAssets) async {
    try {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: maxAssets,
          requestType: RequestType.image,
          themeColor: Theme.of(context).primaryColor,
          textDelegate: const AssetPickerTextDelegate(),
        ),
      );

      if (assets != null && assets.isNotEmpty) {
        final List<File> files = [];
        for (final asset in assets) {
          final File? file = await asset.file;
          if (file != null && await file.exists()) {
            files.add(file);
          }
        }
        print('相册选择成功: ${files.length}张图片');
        return files;
      }
      return [];
    } catch (e) {
      print('多图片选择失败: $e');
      if (e.toString().contains('permission')) {
        Loading.toast('请允许访问相册权限'.tr);
      } else {
        Loading.toast('图片选择失败'.tr);
      }
      return [];
    }
  }

  /// 压缩多张图片
  static Future<List<File>> _compressMultipleImages(
      List<File> originalFiles) async {
    final List<File> compressedFiles = [];

    for (int i = 0; i < originalFiles.length; i++) {
      final originalFile = originalFiles[i];
      print('压缩第${i + 1}/${originalFiles.length}张图片');

      final compressedFile = await _compressImage(originalFile);
      if (compressedFile != null) {
        compressedFiles.add(compressedFile);
      }
    }

    print('批量压缩完成: ${compressedFiles.length}/${originalFiles.length}张');
    return compressedFiles;
  }

  /// 压缩图片
  static Future<File?> _compressImage(File originalFile) async {
    try {
      print('开始压缩图片: ${originalFile.path}');

      final compressedFile = await DuCompress.image(originalFile.path);
      if (compressedFile == null) {
        print('图片压缩失败，返回原文件');
        return originalFile;
      }

      final File compressedImageFile = File(compressedFile.path);
      if (await compressedImageFile.exists()) {
        final originalSize = await originalFile.length();
        final compressedSize = await compressedImageFile.length();
        print('图片压缩成功: ${originalSize}KB -> ${compressedSize}KB');
        return compressedImageFile;
      } else {
        print('压缩后的文件不存在，返回原文件');
        return originalFile;
      }
    } catch (e) {
      print('图片压缩异常: $e，返回原文件');
      return originalFile;
    }
  }
}
