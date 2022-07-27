import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/widgets/regular_button.dart';

class NotifProcessDialog extends ModalRoute<void> {
  NotifProcessDialog({this.isSuccess, required this.message});
  bool? isSuccess;
  String? message;
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
      padding: EdgeInsets.all(15),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: scaffoldBg,
              ),
              width: Responsive.isDesktop(context)
                  ? 700
                  : MediaQuery.of(context).size.width * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            icon: Icon(
                              Icons.close,
                              color: eerieBlack,
                            ),
                            label: Text(''),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 80,
                      ),
                      height: 320,
                      width: 300,
                      child: isSuccess!
                          ? SvgPicture.asset('assets/Email confirmed.svg')
                          : SvgPicture.asset('assets/email failed.svg'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        isSuccess! ? 'Success' : 'Failed',
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 48 : 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        child: Text(
                          isSuccess! ? '$message' : 'Something wrong!',
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context) ? 24 : 14,
                            fontWeight: FontWeight.w300,
                            color: onyxBlack,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60, bottom: 40),
                      child: SizedBox(
                        height: 50,
                        width: 250,
                        child: RegularButton(
                          sizeFont: Responsive.isDesktop(context) ? 24 : 16,
                          title: 'OK',
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
