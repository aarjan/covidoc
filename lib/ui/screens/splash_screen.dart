import 'package:flutter/material.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  static const ROUTE_NAME = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              SvgPicture.asset('assets/logo.svg'),
              const Spacer(),
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
