import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  static DeviceType getDeviceType(MediaQueryData mediaQuery) {
    double width = mediaQuery.size.width;
    if (width >= 1024) return DeviceType.desktop;
    if (width >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceType = getDeviceType(mediaQuery);
    return builder(context, deviceType);
  }
}
