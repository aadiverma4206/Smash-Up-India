import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auto_fit_text.dart';

class ForgotPasswordView extends GetView<AuthController> {
  ForgotPasswordView({super.key});

  final TextEditingController identifierController = TextEditingController();
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
            // Top Sports Banner Header extending to top of screen
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
                          child: Icon(Icons.lock_reset_rounded,
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

            // Form Body
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
                              'Forgot ',
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
                        'Enter your registered email or phone number to receive a verification OTP.',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppTextField(
                        hint: 'Email',
                        controller: identifierController,
                        prefixIcon: Icon(Icons.mail_outline_rounded,
                            color: secondaryTextColor, size: 22),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter Email'
                            : null,
                      ),
                      const SizedBox(height: 28),
                      Obx(
                        () => AppButton(
                          text: 'Send Reset OTP',
                          showArrow: true,
                          height: 52,
                          isLoading: controller.isLoading.value,
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              controller.forgotPasswordSendOtp(
                                identifierController.text.trim(),
                              );
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
