import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cctv_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../app/theme/app_colors.dart';

class AddCctvView extends GetView<CctvController> {
  AddCctvView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController rtspUrlController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController =
      TextEditingController(text: '554');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add CCTV Camera')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add RTSP Dome Camera',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'RTSP credentials will be encrypted with AES-256-GCM by backend and never stored in plaintext.',
                style: TextStyle(color: context.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Camera Name',
                hint: 'Court 1 Dome Camera',
                controller: nameController,
                prefixIcon: const Icon(Icons.videocam_outlined,
                    color: AppColors.primary),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter camera name'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'RTSP Stream URL',
                hint: 'rtsp://admin:secret123@192.168.1.100:554/stream1',
                controller: rtspUrlController,
                obscureText: true,
                prefixIcon:
                    const Icon(Icons.link_rounded, color: AppColors.primary),
                validator: (v) => (v == null || !v.startsWith('rtsp://'))
                    ? 'Enter valid RTSP URL'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'IP Address',
                hint: '192.168.1.100',
                controller: ipController,
                prefixIcon:
                    const Icon(Icons.wifi_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Port',
                hint: '554',
                controller: portController,
                keyboardType: TextInputType.number,
                prefixIcon:
                    const Icon(Icons.numbers_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 28),
              Obx(
                () => AppButton(
                  text: 'Save Camera Credentials',
                  showArrow: true,
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      controller.addCamera(
                        clubId: 'clb_001',
                        name: nameController.text.trim(),
                        rtspUrl: rtspUrlController.text.trim(),
                        ipAddress: ipController.text.trim(),
                        port: int.tryParse(portController.text.trim()) ?? 554,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
