import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

class VisitorDataOverlay extends ModalRoute<void> {
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
      padding: const EdgeInsets.all(15.0),
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
                        : EdgeInsets.only(left: 50, right: 50, top: 30),
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
                          padding: const EdgeInsets.only(bottom: 0),
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
                          padding: EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                child: Image.asset('assets/avatar_male.png'),
                              ),
                            ],
                          ),
                        ),
                        //Content
                        Responsive.isDesktop(context)
                            ? desktopLayout(context)
                            : mobileLayout(),
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

  Widget desktopLayout(BuildContext context) {
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
                  visitorInfo![0]["FirstName"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: detailInfo(
                  'Last Name',
                  visitorInfo![0]["LastName"],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Gender',
            visitorInfo![0]["Gender"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Email',
            visitorInfo![0]["Email"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Last Name',
            visitorInfo![0]["LastName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: phoneInfo(
            'Phone Number',
            visitorInfo![0]["PhoneCode"],
            visitorInfo![0]["PhoneNumber"],
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
                  visitorInfo![0]["Origin"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: detailInfo(
                  'Visit Reason',
                  visitorInfo![0]["VisitReason"],
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
                  visitorInfo![0]["VisitDate"],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: detailInfo(
                  'Meeting With',
                  visitorInfo![0]["Employee"],
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
                child: SizedBox(
                  width: 250,
                  height: 60,
                  child: RegularButton(
                    sizeFont: 24,
                    title: 'OK',
                    onTap: () {},
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

  mobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: detailInfo(
            'First Name',
            visitorInfo![0]["FirstName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Last Name',
            visitorInfo![0]["LastName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Gender',
            visitorInfo![0]["Gender"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Email',
            visitorInfo![0]["Email"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: detailInfo(
            'Last Name',
            visitorInfo![0]["LastName"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: phoneInfo(
            'Phone Number',
            visitorInfo![0]["PhoneCode"],
            visitorInfo![0]["PhoneNumber"],
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
            visitorInfo![0]["Origin"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Visit Reason',
            visitorInfo![0]["VisitReason"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Visit Date',
            visitorInfo![0]["VisitDate"],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: detailInfo(
            'Meeting With',
            visitorInfo![0]["Employee"],
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
                title: 'OK',
                onTap: () {},
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
                  Responsive.isDesktop(navKey.currentState!.context) ? 24 : 20,
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
                    : 24,
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
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: onyxBlack,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '+$code $number',
              style: TextStyle(
                fontSize: 30,
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
