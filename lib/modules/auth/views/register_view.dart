import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auto_fit_text.dart';

class RegisterView extends GetView<AuthController> {
  RegisterView({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController =
      TextEditingController(text: 'Raipur');
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> step1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> step2Key = GlobalKey<FormState>();
  final GlobalKey<FormState> step3Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Sports Hero Image Banner extending to top of screen
            _buildHeroHeader(context),

            // Main Step Form Section
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Obx(() {
                  switch (controller.registrationStep.value) {
                    case 1:
                      return _buildStep1Info(context);
                    case 2:
                      return _buildStep2Otp(context);
                    case 3:
                      return _buildStep3Password(context);
                    default:
                      return _buildStep1Info(context);
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Sports Hero Header Banner
  Widget _buildHeroHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imagePath = isDark
        ? 'assets/images/Login/dark.png'
        : 'assets/images/Login/light.png';

    return Stack(
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
              errorBuilder: (context, err, stack) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0F172A),
                      Color(0xFF064E3B),
                      Color(0xFF1E293B)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/App_Logo/smash_up_india.png',
                        height: 65,
                        fit: BoxFit.contain,
                        errorBuilder: (context, err, stack) => const Icon(
                          Icons.sports_soccer,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const AutoFitText(
                        'SMASH UP INDIA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
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
    );
  }

  /// Header Title with Green Highlight
  Widget _buildFormHeader(BuildContext context,
      {required String titleNormal,
      required String titleGreen,
      required String subtitle}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: AutoFitText(
                '$titleNormal ',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: primaryTextColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            AutoFitText(
              titleGreen,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Step 1: Personal Information
  Widget _buildStep1Info(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Form(
      key: step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(
            context,
            titleNormal: 'Create',
            titleGreen: 'Account',
            subtitle: 'Join All Stars Arena & unlock sports features',
          ),

          // Step Progress Bar
          _buildProgressBar(currentStep: 1, totalSteps: 3),
          const SizedBox(height: 24),

          AppTextField(
            hint: 'Full Name',
            controller: nameController,
            prefixIcon: Icon(Icons.person_outline_rounded,
                color: secondaryTextColor, size: 22),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
          ),
          const SizedBox(height: 16),

          AppTextField(
            hint: 'Email Address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.mail_outline_rounded,
                color: secondaryTextColor, size: 22),
            validator: (v) => (v == null || !v.contains('@'))
                ? 'Enter a valid email address'
                : null,
          ),
          const SizedBox(height: 16),

          AppTextField(
            hint: 'Mobile Number',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon:
                Icon(Icons.phone_outlined, color: secondaryTextColor, size: 22),
            validator: (v) => (v == null || v.trim().length < 10)
                ? 'Enter valid phone number'
                : null,
          ),
          const SizedBox(height: 16),

          AppTextField(
            hint: 'City',
            controller: cityController,
            prefixIcon: Icon(Icons.location_city_outlined,
                color: secondaryTextColor, size: 22),
          ),
          const SizedBox(height: 28),

          Obx(
            () => AppButton(
              text: 'Send OTP',
              showArrow: true,
              height: 52,
              isLoading: controller.isLoading.value,
              onPressed: () {
                if (step1Key.currentState?.validate() == true) {
                  controller.sendRegisterOtp(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    phoneController.text.trim(),
                    cityController.text.trim(),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Footer Link back to Login
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.offNamed(Routes.login),
                  child: const AutoFitText(
                    'Log In',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2: OTP Verification
  Widget _buildStep2Otp(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Form(
      key: step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(
            context,
            titleNormal: 'Verify',
            titleGreen: 'OTP',
            subtitle:
                'Enter the 6-digit OTP sent to ${controller.regEmail.value}',
          ),
          _buildProgressBar(currentStep: 2, totalSteps: 3),
          const SizedBox(height: 24),
          AppTextField(
            hint: '6-Digit Email OTP',
            controller: otpController,
            keyboardType: TextInputType.number,
            prefixIcon: Icon(Icons.security_outlined,
                color: secondaryTextColor, size: 22),
            validator: (v) => (v == null || v.trim().length != 6)
                ? 'Enter 6-digit OTP'
                : null,
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AutoFitText(
                    'Resend in ${controller.otpTimerSeconds.value}s',
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: controller.canResendOtp.value
                      ? () => controller.sendRegisterOtp(
                            controller.regName.value,
                            controller.regEmail.value,
                            controller.regPhone.value,
                            controller.regCity.value,
                          )
                      : null,
                  child: const AutoFitText(
                    'Resend OTP',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => AppButton(
              text: 'Verify OTP',
              showArrow: true,
              height: 52,
              isLoading: controller.isLoading.value,
              onPressed: () {
                if (step2Key.currentState?.validate() == true) {
                  controller.verifyRegisterOtp(otpController.text.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Step 3: Password Creation
  Widget _buildStep3Password(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Form(
      key: step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(
            context,
            titleNormal: 'Create',
            titleGreen: 'Password',
            subtitle: 'Set a strong password for your Smash Up India account',
          ),
          _buildProgressBar(currentStep: 3, totalSteps: 3),
          const SizedBox(height: 24),
          AppTextField(
            hint: 'Password',
            controller: passwordController,
            obscureText: true,
            prefixIcon: Icon(Icons.lock_outline_rounded,
                color: secondaryTextColor, size: 22),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter Password';
              if (v.length < 8) return 'Password must be at least 8 characters';
              final hasUpper = v.contains(RegExp(r'[A-Z]'));
              final hasLower = v.contains(RegExp(r'[a-z]'));
              final hasDigit = v.contains(RegExp(r'\d'));
              final hasSpecial = v.contains(RegExp(r'[@$!%*?&#]'));
              if (!hasUpper || !hasLower || !hasDigit || !hasSpecial) {
                return 'Include uppercase, lowercase, number, and special character (@\$!%*?&#)';
              }
              return null;
            },
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
              text: 'Complete Registration',
              showArrow: true,
              height: 52,
              isLoading: controller.isLoading.value,
              onPressed: () {
                if (step3Key.currentState?.validate() == true) {
                  controller.registerPlayer(passwordController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Step Progress Bar
  Widget _buildProgressBar(
      {required int currentStep, required int totalSteps}) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNum = index + 1;
        final isActive = stepNum <= currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8 : 0),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
