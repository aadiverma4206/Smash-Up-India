import 'package:flutter/material.dart';

class AppShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;
  final bool enable3D;

  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.shape = BoxShape.rectangle,
    this.enable3D = true,
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor =
        isDark ? const Color(0xFF1E1B2E) : const Color(0xFFE2E4EC);
    final highlightColor =
        isDark ? const Color(0xFF383352) : const Color(0xFFF8F9FE);
    final borderHighlight = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.8);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            border: widget.enable3D
                ? Border.all(
                    color: borderHighlight,
                    width: 1.2,
                  )
                : null,
            boxShadow: widget.enable3D
                ? [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.45)
                          : Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF2E2A42).withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.7),
                      blurRadius: 4,
                      offset: const Offset(-2, -2),
                    ),
                  ]
                : null,
            gradient: LinearGradient(
              begin: Alignment(-1.5 + value * 3, -0.3),
              end: Alignment(-0.5 + value * 3, 0.3),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
