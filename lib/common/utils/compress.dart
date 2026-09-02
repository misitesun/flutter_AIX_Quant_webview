import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

/// 压缩工具类
/* 使用示例
DuCompress.image('图片路径');
DuCompress.video('视频路径');
final file = await ImagePicker().pickImage(source: ImageSource.gallery);
if (file == null) return;
// 创建文件对象
File originalFile = File(file.path);
// 压缩图片
var newFile = await DuCompress.image(originalFile.path);
if (newFile == null) return;
// 将 XFile 转换为 File
File compressedFile = File(newFile.path);
// 上传压缩后的图片
ChatApi.uploadFile(compressedFile);
*/

/// 压缩返回类型
class CompressMediaFile {
  final File? thumbnail;
  final MediaInfo? video;

  CompressMediaFile({
    this.thumbnail,
    this.video,
  });
}

/// 媒体压缩
class DuCompress {
  // 压缩图片
  static Future<XFile?> image(
    String path, {
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    return await FlutterImageCompress.compressAndGetFile(
      path,
      '${path}_temp.jpg',
      keepExif: true,
      quality: 80,
      format: CompressFormat.jpeg,
      minHeight: minHeight,
      minWidth: minWidth,
    );
  }

  /// 压缩视频
  static Future<CompressMediaFile> video(File file) async {
    var result = await Future.wait([
      // 1 视频压缩
      VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.Res640x480Quality,
        deleteOrigin: false, // 默认不要去删除原视频
        includeAudio: true,
        frameRate: 25,
      ),

      // 2 视频缩略图
      VideoCompress.getFileThumbnail(
        file.path,
        quality: 80,
        position: -1000,
      ),
    ]);
    return CompressMediaFile(
      video: result.first as MediaInfo,
      thumbnail: result.last as File,
    );
  }

  /// 清理缓存
  static Future<bool?> clean() async {
    return await VideoCompress.deleteAllCache();
  }

  /// 取消
  static Future<void> cancel() async {
    await VideoCompress.cancelCompression();
  }
}
