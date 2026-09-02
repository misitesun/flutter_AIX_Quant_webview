import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'index.dart';

class StartPage extends GetView<StartController> {
  const StartPage({super.key});

  // 主视图
  Widget _buildView() {
    return Image.asset(
      "assets/icons/background.png",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StartController>(
      init: StartController(),
      id: "start",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
