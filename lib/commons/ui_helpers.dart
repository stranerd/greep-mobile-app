import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

const kDefaultSpacing = 16.18;

// horizontal spacing
const Widget kHorizontalSpaceTiny = SizedBox(width: kDefaultSpacing * 0.333);
const Widget kHorizontalSpaceSmall = SizedBox(width: kDefaultSpacing * 0.5);
const Widget kHorizontalSpaceRegular = SizedBox(width: kDefaultSpacing);
const Widget kHorizontalSpaceMedium = SizedBox(width: kDefaultSpacing * 1.5);
const Widget kHorizontalSpaceLarge = SizedBox(width: kDefaultSpacing * 2.0);

// vertical spacing
 Widget kVerticalSpaceTiny = SizedBox(height: (kDefaultSpacing * 0.333).h);
 Widget kVerticalSpaceSmall = SizedBox(height: (kDefaultSpacing * 0.5).h);
 Widget kVerticalSpaceRegular = SizedBox(height: kDefaultSpacing.h);
 Widget kVerticalSpaceMedium = SizedBox(height: (kDefaultSpacing * 1.5).h);
 Widget kVerticalSpaceLarge = SizedBox(height: (kDefaultSpacing * 2.0).h);

var kDefaultTextStyle = GoogleFonts.poppins(
  fontSize: 15.18,
  color: kBlackColor,
);

var kBoldTextStyle = kDefaultTextStyle.copyWith(
  fontWeight: FontWeight.bold,
);

var kBoldTextStyle2 = const TextStyle(
  fontFamily: "Poppins-Bold",
  fontSize: 15.18,
  color: kBlackColor,
);

var kErrorColorTextStyle = kDefaultTextStyle.copyWith(color: kErrorColor);

var kTitleTextStyle = kDefaultTextStyle.copyWith(
  fontWeight: FontWeight.bold,
  color: kBlackColor,
  fontSize: 16,
);

var kHeadingTextStyle = kDefaultTextStyle.copyWith(
  fontWeight: FontWeight.bold,
  color: kBlackColor,
  fontSize: 19,
);

var kWhiteTextStyle = kDefaultTextStyle.copyWith(color: kWhiteColor);

var kBoldWhiteTextStyle = kWhiteTextStyle.copyWith(
  fontWeight: FontWeight.bold
);

var kSubtitleTextStyle = kDefaultTextStyle.copyWith(
  color: kBlackLightColor,
);

var kPrimaryTextStyle = kDefaultTextStyle.copyWith(
  color: kPrimaryColor,
);

var kSubtitleTextStyle2 =
    kDefaultTextStyle.copyWith(color: kBlackColor3, fontSize: 15);
