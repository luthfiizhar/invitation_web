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
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: Responsive.isDesktop(context)
                      ? BorderRadius.circular(15)
                      : BorderRadius.circular(10),
                  color: scaffoldBg,
                ),
                height: Responsive.isDesktop(context) ? 500 : 500,
                width: Responsive.isDesktop(context)
                    ? 400
                    : MediaQuery.of(context).size.width * 0.95,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 30,
                                  ),
                                  height: 175,
                                  width: 195,
                                  child: isSuccess!
                                      ? SvgPicture.asset(
                                          'assets/Email confirmed.svg')
                                      : SvgPicture.asset(
                                          'assets/email failed.svg'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    isSuccess! ? 'Success' : 'Failed',
                                    style: TextStyle(
                                      fontSize: Responsive.isDesktop(context)
                                          ? 36
                                          : 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 17),
                                  child: Container(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Wrap(
                                        children: [
                                          Text(
                                            isSuccess!
                                                ? '$message'
                                                : '$message',
                                            style: TextStyle(
                                              fontSize:
                                                  Responsive.isDesktop(context)
                                                      ? 24
                                                      : 14,
                                              fontWeight: FontWeight.w300,
                                              color: onyxBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 50, bottom: 0),
                                  child: SizedBox(
                                    height: 45,
                                    width: 200,
                                    child: RegularButton(
                                      radiusBorder: 7,
                                      sizeFont: Responsive.isDesktop(context)
                                          ? 24
                                          : 16,
                                      title: 'OK',
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
