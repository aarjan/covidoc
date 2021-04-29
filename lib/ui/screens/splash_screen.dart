import 'package:flutter/material.dart';
import 'package:covidoc/config.dart';
import 'package:covidoc/utils/const/const.dart';

class SplashScreen extends StatelessWidget {
  static const ROUTE_NAME = '/splash';

  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    // init appConfig for standard width/height
    AppConfig(context);

    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.DEFAULT,
          ),
          child: Column(
            children: <Widget>[
              const Spacer(),
              const Icon(
                Icons.healing,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppConst.APP_NAME,
                style: AppFonts.SEMIBOLD_WHITE_24,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: Text(
                  'Doctors at service',
                  style: AppFonts.LIGHT_WHITE_14,
                ),
              ),
              Text(
                AppConst.APP_VERSION,
                style: AppFonts.SEMIBOLD_WHITE_11,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
