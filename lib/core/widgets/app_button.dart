import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'auto_fit_text.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;
  final bool showArrow;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
    this.showArrow = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg =
        isOutline ? Colors.transparent : (backgroundColor ?? AppColors.primary);
    final defaultFg = textColor ??
        (isOutline
            ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
            : Colors.white);

    Widget buttonChild = isOutline
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: defaultFg,
              side: BorderSide(
                color: backgroundColor ??
                    (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: _buildChild(context, defaultFg),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: defaultBg,
              foregroundColor: defaultFg,
              elevation: 2,
              shadowColor: defaultBg.withAlpha(80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: _buildChild(context, defaultFg),
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: buttonChild,
    );
  }

  Widget _buildChild(BuildContext context, Color fgColor) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: fgColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: AutoFitText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              color: fgColor,
            ),
          ),
        ),
        if (showArrow) ...[
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 20, color: fgColor),
        ],
      ],
    );
  }
}
