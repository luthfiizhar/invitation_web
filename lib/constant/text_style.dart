import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';

const TextStyle helveticaText = TextStyle(
  fontFamily: 'Helvetica',
  height: 1.15,
);

const TextStyle navBarText = TextStyle(
  fontFamily: 'Helvetica',
  height: 1.15,
);

TextStyle filterSearchBarText = TextStyle(
  fontFamily: 'Helvetica',
  fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 18 : 16,
);

TextStyle infoTextLight = helveticaText.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: eerieBlack,
);

TextStyle infoTextBold = helveticaText.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

TextStyle headerTableTextStyle = helveticaText.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: davysGray,
);

TextStyle bodyTableNormalText = helveticaText.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: davysGray,
);

TextStyle bodyTableLightText = helveticaText.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w300,
  color: davysGray,
);

TextStyle dialogTitleText = helveticaText.copyWith(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

TextStyle dialogFormNumberText = helveticaText.copyWith(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: orangeAccent,
);

TextStyle dialogSummaryTitleText = helveticaText.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: orangeAccent,
);

TextStyle dialogSummaryContentText = helveticaText.copyWith(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

TextStyle dialogSummaryContentLightText = helveticaText.copyWith(
  fontSize: 20,
  fontWeight: FontWeight.w300,
  color: eerieBlack,
);

const TextStyle titlePageAlertDialog = TextStyle(
  fontFamily: 'Helvetica',
  fontSize: 24,
  fontWeight: FontWeight.w700,
  height: 1.15,
);

const TextStyle bodyTextAlertDialog = TextStyle(
  fontFamily: 'Helvetica',
  fontSize: 18,
  fontWeight: FontWeight.w300,
  height: 1.15,
);
