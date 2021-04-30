import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'const/app_const.dart';

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getstatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

String readTimestamp(String timestamp, BuildContext context) {
  final date = DateTime.parse(timestamp);
  final timeOfDay = TimeOfDay.fromDateTime(date);
  final res = timeOfDay.format(context);
  final month = DateFormat('MMMM dd').format(date);
  return '$month, $res';
}

extension StringExtensions on String {
  String toTitleCase() {
    final strs = split(' ');
    return strs
        .map(
            (s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '')
        .join(' ');
  }

  String toShortString() {
    final strs = split(' ');
    return strs
        .fold<String>('', (val, el) => '$val ${el[0]}')
        .trim()
        .toUpperCase();
  }

  String get readingDuration {
    const findTime = Duration(seconds: 2);
    final readingTime = Duration(milliseconds: length * 40);
    return '${(findTime + readingTime).inMinutes} mins';
  }
}

extension IntExtensions on int {
  String get padInt {
    return toString().padLeft(2, '0');
  }

  String get pkgDuration {
    if (this <= 30) {
      return '$this Days';
    } else if (this < 365) {
      return '${this ~/ 30} Months';
    } else {
      return '${this ~/ 356} Year';
    }
  }
}

extension ShowToast on GlobalKey<ScaffoldState> {
  void toast(
    String msg, {
    SnackBarBehavior behavior,
    Duration duration = const Duration(seconds: 2),
  }) {
    currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          msg,
          textAlign: (behavior != null) ? TextAlign.center : TextAlign.start,
        ),
        behavior: behavior,
        duration: duration,
      ));
  }
}

extension ShowContextToast on BuildContext {
  void toast(
    String msg, {
    SnackBarBehavior behavior,
    Duration duration = const Duration(seconds: 2),
  }) {
    Scaffold.of(this).removeCurrentSnackBar();
    Scaffold.of(this).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: (behavior != null) ? TextAlign.center : TextAlign.start,
      ),
      behavior: behavior,
      duration: duration,
    ));
  }

  void toastWithAction(String msg,
      {String actionMsg, VoidCallback actionCallback}) {
    Scaffold.of(this).removeCurrentSnackBar();
    Scaffold.of(this).showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: actionMsg,
          textColor: Colors.white,
          onPressed: actionCallback,
        ),
      ),
    );
  }
}

Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

extension DateTimeExtension on DateTime {
  String get formattedTime => '${day.padInt} ${AppConst.MONTH[month]} $year '
      '${hour.padInt}:${minute.padInt}';

  String get formattedDate => '${day.padInt} ${AppConst.MONTH[month]} $year';

  String get formattedDay => '${day.padInt} ${AppConst.MONTH[month]}';
}
