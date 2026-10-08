import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cctv_controller.dart';

class CctvDetailsView extends GetView<CctvController> {
  const CctvDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CCTV Camera Details')),
      body: const Center(
        child: Text('CCTV Camera Configuration & Health Diagnostics'),
      ),
    );
  }
}
