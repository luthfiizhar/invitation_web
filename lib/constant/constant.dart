import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';

final TextStyle kPageTitleStyle = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 24 : 18,
    fontWeight: FontWeight.w700);

final TextStyle kPageTitleStyleMobile =
    TextStyle(fontSize: 12, fontWeight: FontWeight.w700);

final TextStyle pageTitle =
    TextStyle(fontSize: 48, fontWeight: FontWeight.w700);

final TextStyle pageSubtitle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.w300);

final TextStyle tableBody = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 24 : 18,
    fontWeight: FontWeight.w300);

final TextStyle tableHeader = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 24 : 18,
    fontWeight: FontWeight.w700);

final TextStyle textButton = TextStyle(
    fontSize: Responsive.isDesktop(navKey.currentState!.context) ? 24 : 18,
    fontWeight: FontWeight.w300,
    color: eerieBlack,
    fontFamily: 'Helvetica',
    decoration: TextDecoration.underline);

final TextStyle dialogTitle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

final TextStyle textButtonRegular = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: eerieBlack,
);

String apiUrl = '169.254.224.177:8500';
