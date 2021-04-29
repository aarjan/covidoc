// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppFonts {
  const AppFonts();

  static final LIGHT = GoogleFonts.poppins(
    color: AppColors.WHITE,
    fontWeight: FontWeight.w200,
  );

  static final REGULAR = GoogleFonts.poppins(
    color: AppColors.WHITE,
    fontWeight: FontWeight.w400,
  );

  static final MEDIUM = GoogleFonts.poppins(
    color: AppColors.WHITE,
    fontWeight: FontWeight.w500,
  );

  static final SEMIBOLD = GoogleFonts.poppins(
    color: AppColors.WHITE,
    fontWeight: FontWeight.w600,
  );

  static final BOLD = GoogleFonts.poppins(
    color: AppColors.WHITE,
    fontWeight: FontWeight.w700,
  );

  static final REGULAR_DEFAULT = REGULAR.copyWith(color: AppColors.DEFAULT);
  static final REGULAR_DEFAULT_9 = REGULAR_DEFAULT.copyWith(fontSize: 9);
  static final REGULAR_DEFAULT_10 = REGULAR_DEFAULT.copyWith(fontSize: 10);
  static final REGULAR_DEFAULT_12 = REGULAR_DEFAULT.copyWith(fontSize: 12);
  static final REGULAR_DEFAULT_14 = REGULAR_DEFAULT.copyWith(fontSize: 14);
  static final REGULAR_DEFAULT_16 = REGULAR_DEFAULT.copyWith(fontSize: 16);
  static final REGULAR_DEFAULT_26 = REGULAR_DEFAULT.copyWith(fontSize: 26);

  static final REGULAR_WHITE = REGULAR.copyWith(color: AppColors.WHITE);
  static final REGULAR_WHITE_8 = REGULAR_WHITE.copyWith(fontSize: 8);
  static final REGULAR_WHITE_9 = REGULAR_WHITE.copyWith(fontSize: 9);
  static final REGULAR_WHITE_10 = REGULAR_WHITE.copyWith(fontSize: 10);
  static final REGULAR_WHITE_12 = REGULAR_WHITE.copyWith(fontSize: 12);
  static final REGULAR_WHITE_14 = REGULAR_WHITE.copyWith(fontSize: 14);
  static final REGULAR_WHITE_15 = REGULAR_WHITE.copyWith(fontSize: 15);
  static final REGULAR_WHITE_16 = REGULAR_WHITE.copyWith(fontSize: 16);
  static final REGULAR_WHITE_26 = REGULAR_WHITE.copyWith(fontSize: 26);

  static final REGULAR_BLACK = REGULAR.copyWith(color: AppColors.BLACK);
  static final REGULAR_BLACK_9 = REGULAR_BLACK.copyWith(fontSize: 9);
  static final REGULAR_BLACK_13 = REGULAR_BLACK.copyWith(fontSize: 13);

  static final REGULAR_BLACK3 = REGULAR.copyWith(color: AppColors.BLACK3);
  static final REGULAR_BLACK3_8 = REGULAR_BLACK3.copyWith(fontSize: 8);
  static final REGULAR_BLACK3_9 = REGULAR_BLACK3.copyWith(fontSize: 9);
  static final REGULAR_BLACK3_12 = REGULAR_BLACK3.copyWith(fontSize: 12);
  static final REGULAR_BLACK3_14 = REGULAR_BLACK3.copyWith(fontSize: 14);
  static final REGULAR_BLACK3_16 = REGULAR_BLACK3.copyWith(fontSize: 16);
  static final REGULAR_BLACK3_18 = REGULAR_BLACK3.copyWith(fontSize: 18);
  static final REGULAR_BLACK3_24 = REGULAR_BLACK3.copyWith(fontSize: 24);

  static final MEDIUM_WHITE_8 = MEDIUM.copyWith(fontSize: 8);
  static final MEDIUM_WHITE_12 = MEDIUM.copyWith(fontSize: 12);
  static final MEDIUM_WHITE_14 = MEDIUM.copyWith(fontSize: 14);
  static final MEDIUM_WHITE_16 = MEDIUM.copyWith(fontSize: 16);
  static final MEDIUM_WHITE_18 = MEDIUM.copyWith(fontSize: 18);
  static final MEDIUM_WHITE_24 = MEDIUM.copyWith(fontSize: 24);

  static final MEDIUM_WHITE3 = MEDIUM.copyWith(color: AppColors.WHITE3);
  static final MEDIUM_WHITE3_12 = MEDIUM_WHITE3.copyWith(fontSize: 12);
  static final MEDIUM_WHITE3_16 = MEDIUM_WHITE3.copyWith(fontSize: 16);

  static final MEDIUM_BLACK = MEDIUM.copyWith(color: AppColors.BLACK);
  static final MEDIUM_BLACK_14 = MEDIUM_BLACK.copyWith(fontSize: 14);

  static final MEDIUM_DEFAULT = MEDIUM.copyWith(color: AppColors.DEFAULT);
  static final MEDIUM_DEFAULT_12 = MEDIUM_DEFAULT.copyWith(fontSize: 12);
  static final MEDIUM_DEFAULT_13 = MEDIUM_DEFAULT.copyWith(fontSize: 13);
  static final MEDIUM_DEFAULT_14 = MEDIUM_DEFAULT.copyWith(fontSize: 14);
  static final MEDIUM_DEFAULT_16 = MEDIUM_DEFAULT.copyWith(fontSize: 16);
  static final MEDIUM_DEFAULT_24 = MEDIUM_DEFAULT.copyWith(fontSize: 24);

  static final SEMIBOLD_WHITE = SEMIBOLD.copyWith(color: AppColors.WHITE);
  static final SEMIBOLD_WHITE_11 = SEMIBOLD_WHITE.copyWith(fontSize: 11);
  static final SEMIBOLD_WHITE_14 = SEMIBOLD_WHITE.copyWith(fontSize: 14);
  static final SEMIBOLD_WHITE_16 = SEMIBOLD_WHITE.copyWith(fontSize: 16);
  static final SEMIBOLD_WHITE_24 = SEMIBOLD_WHITE.copyWith(fontSize: 24);

  static final MEDIUM_BLACK3 = MEDIUM.copyWith(color: AppColors.BLACK3);
  static final MEDIUM_BLACK3_9 = MEDIUM_BLACK3.copyWith(fontSize: 9);
  static final MEDIUM_BLACK3_12 = MEDIUM_BLACK3.copyWith(fontSize: 12);
  static final MEDIUM_BLACK3_14 = MEDIUM_BLACK3.copyWith(fontSize: 14);
  static final MEDIUM_BLACK3_16 = MEDIUM_BLACK3.copyWith(fontSize: 16);
  static final MEDIUM_BLACK3_18 = MEDIUM_BLACK3.copyWith(fontSize: 18);
  static final MEDIUM_BLACK3_20 = MEDIUM_BLACK3.copyWith(fontSize: 20);
  static final MEDIUM_BLACK3_22 = MEDIUM_BLACK3.copyWith(fontSize: 22);
  static final MEDIUM_BLACK3_24 = MEDIUM_BLACK3.copyWith(fontSize: 24);

  static final SEMIBOLD_BLACK3 = SEMIBOLD.copyWith(color: AppColors.BLACK3);
  static final SEMIBOLD_BLACK3_12 = SEMIBOLD_BLACK3.copyWith(fontSize: 12);
  static final SEMIBOLD_BLACK3_16 = SEMIBOLD_BLACK3.copyWith(fontSize: 16);
  static final SEMIBOLD_BLACK3_18 = SEMIBOLD_BLACK3.copyWith(fontSize: 18);
  static final SEMIBOLD_BLACK3_30 = SEMIBOLD_BLACK3.copyWith(fontSize: 30);

  static final LIGHT_WHITE = LIGHT.copyWith(color: AppColors.WHITE);
  static final LIGHT_WHITE_12 = LIGHT_WHITE.copyWith(fontSize: 12);
  static final LIGHT_WHITE_14 = LIGHT_WHITE.copyWith(fontSize: 14);
  static final LIGHT_WHITE_26 = LIGHT_WHITE.copyWith(fontSize: 26);

  static final BOLD_WHITE_12 = BOLD.copyWith(fontSize: 12);
  static final BOLD_WHITE_18 = BOLD.copyWith(fontSize: 18);

  static final REGULAR_WHITE3 = REGULAR.copyWith(color: AppColors.WHITE3);
  static final REGULAR_WHITE3_9 = REGULAR_WHITE3.copyWith(fontSize: 9);
  static final REGULAR_WHITE3_10 = REGULAR_WHITE3.copyWith(fontSize: 10);
  static final REGULAR_WHITE3_11 = REGULAR_WHITE3.copyWith(fontSize: 11);
  static final REGULAR_WHITE3_12 = REGULAR_WHITE3.copyWith(fontSize: 12);
  static final REGULAR_WHITE3_14 = REGULAR_WHITE3.copyWith(fontSize: 14);

  static final BOLD_BLACK = BOLD.copyWith(color: AppColors.BLACK);
  static final BOLD_BLACK24 = BOLD_BLACK.copyWith(fontSize: 24);

  static final BOLD_BLACK3 = BOLD.copyWith(color: AppColors.BLACK3);
  static final BOLD_BLACK3_22 = BOLD_BLACK3.copyWith(fontSize: 22);
  static final BOLD_BLACK3_16 = BOLD_BLACK3.copyWith(fontSize: 16);
}
