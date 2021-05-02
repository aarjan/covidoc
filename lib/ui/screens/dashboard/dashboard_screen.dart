import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/utils/const/const.dart';

class DashboardScreen extends StatelessWidget {
  static const ROUTE_NAME = '/dashboard';

  const DashboardScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UpperHalf(),
          const LowerHalf(),
        ],
      ),
    );
  }
}

class UpperHalf extends StatelessWidget {
  const UpperHalf({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.DEFAULT,
      height: screenHeight(context) / 2,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey! \nRamakrishna',
                  style: AppFonts.MEDIUM_WHITE_24,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  child: Text(
                    'Take a deep breath we are here to help',
                    style: AppFonts.REGULAR_WHITE_14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 50, right: 0, child: Image.asset('assets/doctor_greet.png')),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  context.toast('Ask');
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ask your query', style: AppFonts.REGULAR_BLACK3_16),
                      SvgPicture.asset('assets/arrow_forward_rounded.svg'),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LowerHalf extends StatelessWidget {
  const LowerHalf();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
        children: [
          CardsView(
            onTap: () {
              context.toast('Ask a doctor');
            },
            title: 'Ask a Doctor',
            color: AppColors.PINK,
            image: 'assets/doctor_ask.svg',
          ),
          const SizedBox(width: 18),
          CardsView(
            onTap: () {
              context.toast('Covid guidelines');
            },
            title: 'Covid Guidelines',
            color: AppColors.PURUPLE,
            image: 'assets/covid_guidelines.svg',
          )
        ],
      ),
    );
  }
}

class CardsView extends StatelessWidget {
  final Color color;
  final String title;
  final String image;
  final Function() onTap;

  const CardsView({Key key, this.color, this.title, this.onTap, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        height: 225,
        width: 165,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: 16,
              child: Text(title, style: AppFonts.MEDIUM_WHITE_16),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: SvgPicture.asset('assets/arrow_forward_rounded.svg',
                  color: Colors.white),
            ),
            Positioned(
              bottom: 0,
              right: 13,
              child: SvgPicture.asset(image),
            ),
          ],
        ),
      ),
    );
  }
}
