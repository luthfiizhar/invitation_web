import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';

final double paddingAtasDialog = 25;
final double paddingSampingDialog = 50;

final double textSizeTitleContent =
    Responsive.isDesktop(navKey.currentState!.context) ? 18 : 14;

final double textSizeContent =
    Responsive.isDesktop(navKey.currentState!.context) ? 20 : 16;

final double textSizeButton =
    Responsive.isDesktop(navKey.currentState!.context) ? 20 : 16;

final TextStyle kPageTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

final TextStyle myInviteMenu = TextStyle(
  fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 24 : 14,
  fontWeight: FontWeight.w700,
);

final TextStyle myInviteMenuMobile = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
);

final TextStyle kPageTitleStyleMobile =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

final TextStyle pageTitle =
    TextStyle(fontSize: 36, fontWeight: FontWeight.w700);

final TextStyle pageSubtitle = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 20 : 14,
    fontWeight: FontWeight.w300);

final TextStyle tableBody = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 20 : 14,
    fontWeight: FontWeight.w300);

final TextStyle tableBodyCode = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 22 : 18,
    fontWeight: FontWeight.w700);

final TextStyle tableHeader =
    TextStyle(fontSize: 22, fontWeight: FontWeight.w700);

final TextStyle textButton = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 20 : 18,
    fontWeight: FontWeight.w300,
    color: eerieBlack,
    fontFamily: 'Helvetica',
    decoration: TextDecoration.underline);

final TextStyle dialogTitle = TextStyle(
  fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 40 : 24,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

final TextStyle textButtonRegular = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

// String apiUrl = "10.100.206.7:8500";//'172.17.155.37:8500';
String apiUrl = "fmklg.klgsys.com";
