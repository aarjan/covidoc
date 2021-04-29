import 'package:flutter/material.dart';

class AppConfig {
  static AppConfig _config;
  static const double _defaultWidth = 375;
  static const double _defaultHeight = 812;

  double width;
  double height;

  factory AppConfig([BuildContext context]) => _config ??= AppConfig._(
        context != null ? MediaQuery.of(context).size.width : _defaultWidth,
        context != null ? MediaQuery.of(context).size.height : _defaultHeight,
      );

  AppConfig._(this.width, this.height);

  double blockWidth(double v) => width / (_defaultWidth / v);
  double blockHeight(double v) => height / (_defaultHeight / v);

  final ButtonStyle mStyle = TextButton.styleFrom(
    
  );
}
