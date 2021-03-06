import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:covidoc/config.dart';
import 'package:covidoc/bloc/bloc.dart';
import 'package:covidoc/utils/utils.dart';
import 'package:covidoc/bloc/blog/blog.dart';
import 'package:covidoc/utils/const/const.dart';
import 'package:covidoc/model/entity/entity.dart';
import 'package:covidoc/ui/screens/screens.dart';

class DashboardScreen extends StatelessWidget {
  static const ROUTE_NAME = '/dashboard';
  final AppUser? user;

  const DashboardScreen({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UpperHalf(user: user),
              const LowerHalf(),
            ],
          );
        },
      ),
    );
  }
}

class UpperHalf extends StatelessWidget {
  const UpperHalf({
    Key? key,
    this.user,
  }) : super(key: key);

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final greetTxt = user == null ? 'Hey!' : 'Hey! \n${user!.fullname}';

    return Container(
      color: AppColors.DEFAULT,
      height: screenHeight(context) / 2,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greetTxt,
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
              top: AppConfig().blockHeight(50),
              right: 0,
              child: Image.asset(
                'assets/dashboard/doctor_greet.png',
                width: AppConfig().blockWidth(160),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  context.read<TabBloc>().add(const OnTabChanged(2));
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(AppConfig().blockHeight(22)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ask your query', style: AppFonts.REGULAR_BLACK3_16),
                      SvgPicture.asset(
                          'assets/dashboard/arrow_forward_rounded.svg'),
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
  const LowerHalf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: CardsView(
              onTap: () {
                context.read<TabBloc>().add(const OnTabChanged(1));
              },
              title: 'Ask a Doctor',
              color: AppColors.PINK,
              image: 'assets/dashboard/doctor_ask.svg',
            ),
          ),
          const SizedBox(width: 18),
          Flexible(
            child: CardsView(
              onTap: () {
                context.read<BlogBloc>().add(const LoadFeaturedBlog());
                Navigator.pushNamed(context, BlogScreen.ROUTE_NAME);
              },
              title: 'Covid Guidelines',
              color: AppColors.PURUPLE,
              image: 'assets/dashboard/covid_guidelines.svg',
            ),
          )
        ],
      ),
    );
  }
}

class CardsView extends StatelessWidget {
  final Color? color;
  final String? title;
  final String? image;
  final Function()? onTap;

  const CardsView({Key? key, this.color, this.title, this.onTap, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        height: 225,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: 16,
              child: Text(title!, style: AppFonts.MEDIUM_WHITE_16),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: SvgPicture.asset(
                  'assets/dashboard/arrow_forward_rounded.svg',
                  color: Colors.white),
            ),
            Positioned(
              bottom: 0,
              right: 13,
              child: SvgPicture.asset(image!),
            ),
          ],
        ),
      ),
    );
  }
}
