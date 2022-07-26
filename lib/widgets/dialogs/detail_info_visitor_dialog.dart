import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

class VisitorConfirmationOverlay extends ModalRoute<void> {
  VisitorConfirmationOverlay({this.listDetail});
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

  showConfirmDialog(BuildContext context) {
    return confirmDialog(context, 'Are you sure to confirm this visitor?', true)
        .then((value) {
      if (value) {
      } else {}
    });
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // dynamic detail = listDetail;
    // print(detail);
    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.all(15.0)
          : EdgeInsets.only(top: 15, bottom: 15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: Responsive.isDesktop(context) ? 1000 : 550,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: scaffoldBg,
              ),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: Responsive.isDesktop(context)
                        ? EdgeInsets.only(left: 150, right: 150, top: 30)
                        : EdgeInsets.only(left: 25, right: 25, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              icon: Icon(
                                Icons.close,
                                color: eerieBlack,
                              ),
                              label: Text(''),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Visitor Verification',
                                style: dialogTitle,
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Please confirm your visitor data before they comes into Head Office.',
                                    style: pageSubtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: Responsive.isDesktop(
                                        navKey.currentState!.context)
                                    ? 200
                                    : 100,
                                width: Responsive.isDesktop(
                                        navKey.currentState!.context)
                                    ? 200
                                    : 100,
                                child: Image.asset('assets/avatar_male.png'),
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
            ),
          );
        },
      ),
    );
  }

  Widget desktopLayout(BuildContext context, String detail) {
    var detailList = json.decode(detail);
    print(detailList);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: detailInfo(
                  'First Name',
                  detailList!["FirstName"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: detailInfo(
                  'Last Name',
                  detailList!["LastName"],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Gender',
            detailList["Gender"] == null ? "" : detailList["Gender"].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Email',
            detailList!["Email"],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 30),
        //   child: detailInfo(
        //     'Last Name',
        //     detailList!["LastName"],
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: phoneInfo(
            'Phone Number',
            detailList['PhoneNumber'] == "null"
                ? "-"
                : detailList['PhoneNumber'].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
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
                padding: EdgeInsets.only(top: 40),
                child: detailInfo(
                  'Origin Company',
                  detailList["CompanyName"] == "null"
                      ? "-"
                      : detailList!["CompanyName"].toString(),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: detailInfo(
                  'Visit Reason',
                  detailList["VisitReason"] == "null"
                      ? "-"
                      : detailList!["VisitReason"].toString(),
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
                  top: 40,
                ),
                child: detailInfo(
                  'Visit Date',
                  detailList["VisitTime"].toString(),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: detailInfo(
                  'Meeting With',
                  detailList["MeetingWith"],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: CustTextButon(
                  label: 'Cancel',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 60,
                  child: RegularButton(
                    sizeFont: 24,
                    title: 'Confirm',
                    onTap: () {
                      showConfirmDialog(context);
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
          padding: EdgeInsets.only(top: 50),
          child: detailInfo(
            'First Name',
            detailList["FirstName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Last Name',
            detailList["LastName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Gender',
            detailList["Gender"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Email',
            detailList["Email"],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 30),
        //   child: detailInfo(
        //     'Last Name',
        //     detailList["LastName"],
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: phoneInfo(
            'Phone Number',
            detailList['PhoneNumber'] == null
                ? "-"
                : detailList['PhoneNumber'].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Divider(
            thickness: 2,
            color: spanishGray,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Origin Company',
            detailList["CompanyName"].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Visit Reason',
            detailList["VisitReason"].toString(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Visit Date',
            detailList["VisitTime"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Meeting With',
            detailList["MeetingWith"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: CustTextButon(
              label: 'Cancel',
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: SizedBox(
              // width: 400,
              height: 60,
              child: RegularButton(
                sizeFont: 24,
                title: 'Confirm',
                onTap: () {
                  showConfirmDialog(context);
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
              fontSize:
                  Responsive.isDesktop(navKey.currentState!.context) ? 24 : 14,
              fontWeight: FontWeight.w300,
              color: onyxBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '$content',
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

  Widget phoneInfo(String label, String number) {
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
