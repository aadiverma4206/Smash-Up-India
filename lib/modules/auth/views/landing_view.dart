import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/auto_fit_text.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  static const String stadiumImageUrl =
      'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&q=80&w=1200';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeService = Get.find<ThemeService>();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Stadium Image
          CachedNetworkImage(
            imageUrl: stadiumImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color:
                  isDark ? AppColors.darkBackground : const Color(0xFF0F172A),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Gradient Overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black.withValues(alpha: 0.65),
                        Colors.black.withValues(alpha: 0.85),
                        AppColors.darkBackground.withValues(alpha: 0.98),
                      ]
                    : [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.black.withValues(alpha: 0.70),
                        AppColors.darkBackground.withValues(alpha: 0.92),
                      ],
              ),
            ),
          ),

          // Main Responsive Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWide ? 600 : double.infinity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top Bar: Theme Toggle Switch
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    isDark
                                        ? Icons.light_mode_rounded
                                        : Icons.dark_mode_rounded,
                                    color: isDark ? Colors.amber : Colors.white,
                                    size: 22,
                                  ),
                                  onPressed: () {
                                    themeService.switchThemeMode(
                                      isDark ? ThemeMode.light : ThemeMode.dark,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Brand Section: Logo + Title + Tagline
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppLogoWidget(
                                height: 75,
                                fit: BoxFit.contain,
                                isHero: true,
                              ),
                              const SizedBox(height: 12),
                              const AutoFitText(
                                'SMASH UP INDIA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const AutoFitText(
                                'LIVE. PLAY. CONNECT.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.5,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Feature Pills Row (Live Matches, Join Communities, Player Stats)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildFeatureItem(
                                    icon: Icons.play_circle_outline_rounded,
                                    label: 'Live\nMatches',
                                  ),
                                  _buildFeatureItem(
                                    icon: Icons.groups_outlined,
                                    label: 'Join\nCommunities',
                                  ),
                                  _buildFeatureItem(
                                    icon: Icons.bar_chart_rounded,
                                    label: 'Player\nStats',
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Flexible Spacer/Artwork Area
                          if (screenHeight > 650)
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.5,
                                      height: screenWidth * 0.5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.sports_soccer,
                                      size: 110,
                                      color: Colors.white24,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Bottom Action Buttons
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Primary Green Button: Log In ->
                              AppButton(
                                text: 'Log In',
                                showArrow: true,
                                height: 54,
                                onPressed: () => Get.toNamed(Routes.login),
                              ),
                              const SizedBox(height: 14),

                              // Outlined Button: Create Account
                              AppButton(
                                text: 'Create Account',
                                isOutline: true,
                                height: 54,
                                textColor: Colors.white,
                                backgroundColor: Colors.white,
                                onPressed: () => Get.toNamed(Routes.register),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Feature Pill Item Widget
  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        AutoFitText(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
