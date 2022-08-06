import 'package:flutter/widgets.dart';
import 'package:mighty_plug_manager/main.dart';

LayoutMode getLayoutMode(MediaQueryData mediaQuery) {
  final screenWidth = mediaQuery.size.width;
  debugPrint('Screen Width is: $screenWidth.');
  if (screenWidth >= 700) return LayoutMode.drawer;
  return LayoutMode.navBar;
}
