import 'package:flutter/material.dart';

class AppConfig extends StatelessWidget {
  static AppConfig? _config;
  static const double _defaultWidth = 375;
  static const double _defaultHeight = 812;

  final double width;
  final double height;

  factory AppConfig({Widget? child, BuildContext? context}) =>
      _config ??= AppConfig._(
        context != null ? MediaQuery.of(context).size.width : _defaultWidth,
        context != null ? MediaQuery.of(context).size.height : _defaultHeight,
        child!,
      );

  AppConfig._(this.width, this.height, this.child);

  double blockWidth(double v) => width / (_defaultWidth / v);
  double blockHeight(double v) => height / (_defaultHeight / v);

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
