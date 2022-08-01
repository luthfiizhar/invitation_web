import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

class VisitorDataOverlay extends ModalRoute<void> {
  VisitorDataOverlay({this.listDetail});
  String? listDetail;
  List? visitorInfo = [
    {
      "FirstName": "Ayana",
      "LastName": "Dunne",
      "Gender": "Female",
      "Email": "ayanna@gmail.com",
      "PhoneNumber": "88888888",
      "PhoneCode": "62",
      "Origin": "PT ZXC",
      "VisitReason": "Business",
      "Employee": "Edward",
      "VisitDate": "4th July 2022",
    }
  ];

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => false;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.all(15.0)
          : EdgeInsets.only(top: 15, bottom: 50),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var detailList = json.decode(listDetail!);
          return Center(
            child: Container(
              width: Responsive.isDesktop(context) ? 600 : null,
              decoration: BoxDecoration(
                borderRadius: Responsive.isDesktop(context)
                    ? BorderRadius.circular(15)
                    : BorderRadius.circular(10),
                color: scaffoldBg,
              ),
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: Responsive.isDesktop(context)
                            ? EdgeInsets.only(
                                left: paddingSampingDialog,
                                right: paddingSampingDialog,
                                top: paddingAtasDialog)
                            : EdgeInsets.only(left: 25, right: 25, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: Responsive.isDesktop(context)
                                  ? EdgeInsets.only(bottom: 25)
                                  : EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Visitor Data',
                                    style: dialogTitle,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  detailList["VisitorPhoto"] == ""
                                      ? Container(
                                          height: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 125
                                              : 75,
                                          width: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 125
                                              : 75,
                                          child: Image.asset(
                                              'assets/avatar_male.png'),
                                        )
                                      : CircleAvatar(
                                          radius: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 100
                                              : 60,
                                          backgroundImage: MemoryImage(
                                            Base64Decoder().convert(
                                                detailList['VisitorPhoto']!
                                                    .toString()
                                                    .split(',')
                                                    .last),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            //Content
                            Responsive.isDesktop(context)
                                ? desktopLayout(context, listDetail!)
                                : mobileLayout(context, listDetail!),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget desktopLayout(BuildContext context, String detail) {
    var detailList = json.decode(detail);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: detailInfo(
                  'First Name',
                  detailList!["FirstName"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: detailInfo(
                  'Last Name',
                  detailList!["LastName"] == null
                      ? "-"
                      : detailList!["LastName"],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Gender',
            detailList!["Gender"].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Email',
            detailList!["Email"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Phone Number',
            detailList!["PhoneNumber"].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(
            thickness: 2,
            color: spanishGray,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: detailInfo(
                  'Origin Company',
                  detailList!["CompanyName"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: detailInfo(
                  'Visit Reason',
                  detailList!["VisitReason"],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: detailInfo(
                  'Visit Date',
                  detailList!["VisitTime"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: detailInfo(
                  'Meeting With',
                  detailList!["MeetingWith"],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 35),
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: RegularButton(
                    sizeFont: textSizeButton,
                    title: 'OK',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  mobileLayout(BuildContext context, String detail) {
    var detailList = json.decode(detail);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: detailInfo(
            'First Name',
            detailList["FirstName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Last Name',
            detailList["LastName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Gender',
            detailList["Gender"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Email',
            detailList["Email"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Phone Number',
            detailList["PhoneNumber"].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            color: spanishGray,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: detailInfo(
            'Origin Company',
            detailList["CompanyName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Visit Reason',
            detailList["VisitReason"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Visit Date',
            detailList["VisitTime"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: detailInfo(
            'Meeting With',
            detailList["MeetingWith"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: SizedBox(
              // width: 400,
              height: 40,
              child: RegularButton(
                sizeFont: 16,
                title: 'OK',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget detailInfo(String label, String content) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: TextStyle(
              fontSize: textSizeTitleContent,
              fontWeight: FontWeight.w300,
              color: onyxBlack,
            ),
          ),
          Padding(
            padding: Responsive.isDesktop(navKey.currentState!.context)
                ? EdgeInsets.only(top: 10)
                : EdgeInsets.only(top: 7),
            child: Text(
              '$content',
              style: TextStyle(
                fontSize: textSizeContent,
                fontWeight: FontWeight.w700,
                color: onyxBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneInfo(String label, String code, String number) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: TextStyle(
              fontSize:
                  Responsive.isDesktop(navKey.currentState!.context) ? 24 : 14,
              fontWeight: FontWeight.w300,
              color: onyxBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: Responsive.isDesktop(navKey.currentState!.context)
                    ? 30
                    : 16,
                fontWeight: FontWeight.w700,
                color: onyxBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
