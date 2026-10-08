import 'package:flutter/material.dart';

class AutoFitText extends StatelessWidget {
  const AutoFitText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.minFontSize = 12,
    this.maxScale = 3.0,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis, // last-resort only
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final double minFontSize; // minimum readable size
  final double maxScale; // upper cap on effective system scale
  final TextAlign? textAlign;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style.merge(style);
    final designSize = base.fontSize ?? 14.0;
    final systemScaler = MediaQuery.textScalerOf(context);

    // Respect system/accessibility scale, but cap it.
    double target = systemScaler.scale(designSize);
    target = target.clamp(designSize, designSize * maxScale);

    // Never let minFontSize exceed the design size (small texts stay small).
    final floor = minFontSize < designSize ? minFontSize : designSize;

    return LayoutBuilder(builder: (context, c) {
      double size = target;
      final maxW = c.maxWidth;

      if (maxW.isFinite) {
        final tp = TextPainter(
          text: TextSpan(text: text, style: base.copyWith(fontSize: size)),
          textDirection: Directionality.of(context),
          maxLines: maxLines,
          textScaler: TextScaler.noScaling, // scale already applied above
        )..layout(maxWidth: maxLines == 1 ? double.infinity : maxW);

        final overflowsWidth = maxLines == 1 && tp.width > maxW;
        final overflowsLines = maxLines > 1 && tp.didExceedMaxLines;

        if (overflowsWidth) {
          size = size * (maxW / tp.width);
        } else if (overflowsLines) {
          // shrink step by step until it fits the allowed lines
          while (size > floor) {
            size -= 0.5;
            final t2 = TextPainter(
              text: TextSpan(text: text, style: base.copyWith(fontSize: size)),
              textDirection: Directionality.of(context),
              maxLines: maxLines,
              textScaler: TextScaler.noScaling,
            )..layout(maxWidth: maxW);
            if (!t2.didExceedMaxLines) break;
          }
        }
        size = size.clamp(floor, target);
      }

      return Text(
        text,
        style: base.copyWith(fontSize: size),
        maxLines: maxLines,
        softWrap: maxLines != 1,
        overflow: overflow, // only triggers if min size still too big
        textAlign: textAlign,
        textScaler: TextScaler.noScaling, // applied manually, local only
      );
    });
  }
}
