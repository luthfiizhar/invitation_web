import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';
import 'package:http/http.dart' as http;

class VisitorConfirmationOverlay extends ModalRoute<void> {
  VisitorConfirmationOverlay({this.listDetail});
  String? listDetail;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  Future apporoveVisitor(String visitorId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    print(visitorId);

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/visitor/approve-visitor-data');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "VisitorID" : "$visitorId"
      }
    """;

    // print(bodySend);
    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    return data;
  }

  showConfirmDialog(BuildContext context, String visitorId) {
    return confirmDialog(context, 'Are you sure to confirm this visitor?', true)
        .then((value) {
      if (value) {
        apporoveVisitor(visitorId).then((value) {
          if (value['Status'] == "200") {
            Navigator.of(context)
                .push(
              NotifProcessDialog(message: value['Message'], isSuccess: true),
            )
                .then((value) {
              Navigator.pop(context);
            });
          }
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // dynamic detail = listDetail;
    // print(detail);
    return Padding(
      padding: Responsive.isDesktop(context)
          ? const EdgeInsets.all(15.0)
          : const EdgeInsets.only(top: 15, bottom: 50),
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
                            : const EdgeInsets.only(
                                left: 25, right: 25, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: Responsive.isDesktop(context)
                                  ? const EdgeInsets.only(bottom: 25)
                                  : const EdgeInsets.only(bottom: 15),
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
                              padding: const EdgeInsets.only(top: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  detailList!["VisitorPhoto"] == null
                                      ? Container(
                                          height: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 125
                                              : 85,
                                          width: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 125
                                              : 85,
                                          child: Image.asset(
                                              'assets/avatar_male.png'),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: scaffoldBg,
                                          radius: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 100
                                              : 75,
                                          backgroundImage: MemoryImage(
                                            const Base64Decoder().convert(
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
                        child: const Icon(
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
    // print(detailList);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: detailInfo(
                  'First Name',
                  detailList!["FirstName"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: detailInfo(
                  'Last Name',
                  detailList!["LastName"] ?? "-",
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: detailInfo(
            'Gender',
            detailList["Gender"] == null
                ? "-"
                : detailList["Gender"].toString(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: detailInfo(
            'Email',
            detailList!["Email"] ?? "-",
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
          padding: const EdgeInsets.only(top: 30),
          child: phoneInfo(
            'Phone Number',
            detailList!['PhoneNumber'] == null
                ? "-"
                : detailList['PhoneNumber'].toString(),
          ),
        ),
        const Padding(
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
                padding: const EdgeInsets.only(top: 0),
                child: detailInfo(
                  'Origin Company',
                  detailList!["CompanyName"] == null
                      ? '-'
                      : detailList!["CompanyName"].toString(),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: detailInfo(
                  'Visit Reason',
                  detailList["VisitReason"] == null
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
                padding: const EdgeInsets.only(
                  top: 25,
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
                padding: const EdgeInsets.only(top: 25),
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
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: CustTextButon(
                    label: 'Cancel',
                    fontSize: textSizeButton,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Responsive.isDesktop(context) ? 30 : null,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: SizedBox(
                  width: Responsive.isDesktop(context) ? 200 : null,
                  height: Responsive.isDesktop(context) ? 50 : 40,
                  child: RegularButton(
                    sizeFont: textSizeButton,
                    title: 'Confirm',
                    onTap: () {
                      showConfirmDialog(context, detailList['VisitorID']);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
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
          padding: const EdgeInsets.only(top: 15),
          child: detailInfo(
            'Last Name',
            detailList["LastName"] == null ? "" : detailList!["LastName"],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: detailInfo(
            'Gender',
            detailList["Gender"] == null ? "" : detailList!["Gender"],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: detailInfo(
            'Email',
            detailList["Email"] == null ? "-" : detailList!["Email"],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: phoneInfo(
            'Phone Number',
            detailList['PhoneNumber'] == null
                ? "-"
                : detailList['PhoneNumber'].toString(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            color: spanishGray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: detailInfo(
            'Origin Company',
            detailList!["CompanyName"] == null
                ? "-"
                : detailList["CompanyName"].toString(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: detailInfo(
            'Visit Reason',
            detailList!["VisitReason"] == null
                ? "-"
                : detailList["VisitReason"].toString(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: detailInfo(
            'Visit Date',
            detailList!["VisitTIme"] == null
                ? "-"
                : detailList["VisitTime"].toString(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: detailInfo(
            'Meeting With',
            detailList!["MeetingWith"] == null
                ? "-"
                : detailList["MeetingWith"].toString(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: CustTextButon(
              fontSize: Responsive.isDesktop(context) ? 24 : 14,
              label: 'Cancel',
              onTap: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: SizedBox(
              // width: 400,
              height: 40,
              child: RegularButton(
                sizeFont: Responsive.isDesktop(context) ? 24 : 14,
                title: 'Confirm',
                onTap: () {
                  showConfirmDialog(context, detailList['VisitorID']);
                },
              ),
            ),
          ),
        ),
        const SizedBox(
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
                ? const EdgeInsets.only(top: 10)
                : const EdgeInsets.only(top: 7),
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

  Widget phoneInfo(String label, String number) {
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
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              number == null ? "" : number,
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
}
