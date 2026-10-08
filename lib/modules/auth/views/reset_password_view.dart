import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auto_fit_text.dart';

class ResetPasswordView extends GetView<AuthController> {
  ResetPasswordView({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imagePath = isDark
        ? 'assets/images/Login/dark.png'
        : 'assets/images/Login/light.png';
    final primaryTextColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Banner Header extending to top of screen
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF0F172A),
                        child: const Center(
                          child: Icon(Icons.key_rounded,
                              size: 48, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Form Section
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: AutoFitText(
                              'Reset ',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                          const AutoFitText(
                            'Password',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Set a new secure password for your Smash Up India account.',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        hint: 'New Password',
                        controller: passwordController,
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock_outline_rounded,
                            color: secondaryTextColor, size: 22),
                        validator: (v) => (v == null || v.length < 8)
                            ? 'Enter valid password'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        hint: 'Confirm Password',
                        controller: confirmPasswordController,
                        obscureText: true,
                        prefixIcon: Icon(Icons.lock_outline_rounded,
                            color: secondaryTextColor, size: 22),
                        validator: (v) => (v != passwordController.text)
                            ? 'Passwords do not match'
                            : null,
                      ),
                      const SizedBox(height: 28),
                      Obx(
                        () => AppButton(
                          text: 'Reset Password',
                          showArrow: true,
                          height: 52,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              controller.resetPassword(passwordController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
