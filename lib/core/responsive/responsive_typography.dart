import 'package:flutter/material.dart';

/// Centralized responsive typography and accessibility scaling system.
class ResponsiveTypography {
  /// Returns a [TextScaler] clamped between [minScale] and [maxScale].
  /// This supports system accessibility scaling while preventing catastrophic layout breakage at 3.0x scale.
  static TextScaler getClampedTextScaler(
    BuildContext context, {
    double minScale = 0.85,
    double maxScale = 2.2,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final currentScale = mediaQuery.textScaler.scale(10) / 10;
    final clampedScale = currentScale.clamp(minScale, maxScale);
    return TextScaler.linear(clampedScale);
  }

  /// Calculates a responsive font size based on screen width bounds and system scale factor.
  static double responsiveFontSize(
    BuildContext context, {
    required double baseSize,
    double minSize = 10.0,
    double maxSize = 36.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    double widthFactor = 1.0;

    if (width < 360) {
      widthFactor = 0.90;
    } else if (width > 600) {
      widthFactor = 1.15;
    }

    final calculated = baseSize * widthFactor;
    return calculated.clamp(minSize, maxSize);
  }
}
