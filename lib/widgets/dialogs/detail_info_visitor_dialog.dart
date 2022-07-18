import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

class VisitorConfirmationOverlay extends ModalRoute<void> {
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
      child: StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Container(
              width: 550,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: scaffoldBg,
              ),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 30),
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
                                'Visitor Confirmation',
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
                                height: 200,
                                width: 200,
                                child: Image.asset('assets/avatar_male.png'),
                              ),
                            ],
                          ),
                        ),
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
                              width: 400,
                              height: 40,
                              child: RegularButton(
                                sizeFont: 24,
                                title: 'Confirm',
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
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

  Widget detailInfo(String label, String content) {
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
              '$content',
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
