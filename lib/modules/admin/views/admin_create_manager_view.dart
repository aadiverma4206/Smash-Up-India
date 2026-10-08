import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../app/theme/app_colors.dart';

class AdminCreateManagerView extends GetView<AdminController> {
  AdminCreateManagerView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController =
      TextEditingController(text: 'Raipur');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provision Turf Manager')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Turf Manager Account',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Owner-level permission required on backend to provision manager accounts.',
                style: TextStyle(color: context.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Manager Full Name',
                hint: 'Manager Name',
                controller: nameController,
                prefixIcon:
                    const Icon(Icons.person_outline, color: AppColors.primary),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter Manager Name'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Manager Email',
                hint: 'manager@example.com',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline_rounded,
                    color: AppColors.primary),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Enter Valid Email'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Phone Number',
                hint: '+919876543210',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon:
                    const Icon(Icons.phone_outlined, color: AppColors.primary),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Enter Valid Phone'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'City',
                hint: 'Raipur',
                controller: cityController,
                prefixIcon: const Icon(Icons.location_city_outlined,
                    color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Temporary Password',
                hint: '••••••••',
                controller: passwordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary),
                validator: (v) =>
                    (v == null || v.length < 8) ? 'Minimum 8 characters' : null,
              ),
              const SizedBox(height: 28),
              Obx(
                () => AppButton(
                  text: 'Provision Manager Account',
                  showArrow: true,
                  isLoading: controller.isLoading.value,
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      controller.createManager(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phone: phoneController.text.trim(),
                        password: passwordController.text,
                        city: cityController.text.trim(),
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
