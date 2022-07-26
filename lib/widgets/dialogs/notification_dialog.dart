import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';

class NotificationOverlay extends ModalRoute<void> {
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
          : EdgeInsets.only(top: 15, bottom: 15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Center(
                child: Container(
                  width: Responsive.isDesktop(context) ? 1000 : 550,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: scaffoldBg,
                  ),
                  child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
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
                                    'Notification',
                                    style: dialogTitle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
