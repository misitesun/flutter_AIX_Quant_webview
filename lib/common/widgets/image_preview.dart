import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';

/*

  图片预览组件
  使用方式：单张预览

  onTap(() {
    Get.to(() => ImagePreview(singleImage: '图片url'));
  })

  使用方式：多张预览

  List<String> img = ['图片url','图片url','图片url'];
  for(var i = 0; i < (img.length ?? 0); i++)
  ImgWidget(
    path: item.img?[i] ?? '',
    width: 170.w,
    height: 170.w,
    radius: 20.w,
  ).onTap(() {
    Get.to(() => ImagePreview(
      imageList: item.img,
      initialIndex: i,
    ));
  }),

 */

class ImagePreview extends StatelessWidget {
  final String? singleImage;
  final List<String>? imageList;
  final int initialIndex;

  const ImagePreview({
    super.key,
    this.singleImage,
    this.imageList,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    // 如果提供了单张图片，转换为列表
    final List<String> images =
        singleImage != null ? [singleImage!] : imageList ?? [];

    if (images.isEmpty) return const SizedBox();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
