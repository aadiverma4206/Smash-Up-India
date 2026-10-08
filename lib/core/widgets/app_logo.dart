import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'auto_fit_text.dart';

class AppLogoWidget extends StatelessWidget {
  final double height;
  final double? width;
  final BoxFit fit;
  final bool showTitle;
  final bool isHero;

  const AppLogoWidget({
    super.key,
    this.height = 60,
    this.width,
    this.fit = BoxFit.contain,
    this.showTitle = false,
    this.isHero = false,
  });

  static const String logoAssetPath =
      'assets/images/App_Logo/smash_up_india.png';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget logoImage = Image.asset(
      logoAssetPath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          padding: EdgeInsets.all(height * 0.2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.sports_soccer,
            size: height * 0.6,
            color: AppColors.primary,
          ),
        );
      },
    );

    if (isHero) {
      logoImage = Hero(
        tag: 'app_logo_hero',
        child: logoImage,
      );
    }

    if (!showTitle) {
      return logoImage;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoImage,
        const SizedBox(height: 8),
        AutoFitText(
          'SMASH UP INDIA',
          style: TextStyle(
            fontSize: height * 0.28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        AutoFitText(
          'LIVE. PLAY. CONNECT.',
          style: TextStyle(
            fontSize: height * 0.16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
