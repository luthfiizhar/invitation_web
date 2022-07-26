import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

Future<bool> confirmDialog(
    BuildContext context, String message, bool isDark) async {
  bool shouldPop = true;
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            // title:
            backgroundColor: eerieBlack, //scaffoldBg,
            content: Container(
              height: 300,
              width: 400,
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
                          color: scaffoldBg,
                        ),
                        label: Text(''),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Confirmation',
                        style: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 40 : 24,
                          fontWeight: FontWeight.w700,
                          color: isDark ? scaffoldBg : eerieBlack,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Wrap(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [],
                        // ),
                        Text(
                          '$message',
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context) ? 24 : 18,
                            fontWeight: FontWeight.w300,
                            color: isDark ? scaffoldBg : eerieBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: Responsive.isDesktop(context) ? 50 : 40,
                      // width: 250,
                      child: RegularButton(
                        isDark: isDark,
                        sizeFont: Responsive.isDesktop(context) ? 20 : 16,
                        title: 'Confirm',
                        onTap: () {
                          Navigator.of(context).pop(true);
                          // Navigator.pushReplacementNamed(
                          //     context, routeInvite);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      height: Responsive.isDesktop(context) ? 50 : 40,
                      // width: 250,
                      child: CustTextButon(
                        isDark: isDark,
                        fontSize: Responsive.isDesktop(context) ? 20 : 16,
                        label: 'Cancel',
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // height: 500,
              // child: Column(
              //   children: [
              //     Text(
              //       'Message here ....',
              //     ),
              //     // SizedBox(
              //     //   height: 50,
              //     //   width: 250,
              //     //   child: RegularButton(
              //     //     title: 'Confirm',
              //     //     onTap: () {
              //     //       Navigator.pop(context);
              //     //     },
              //     //   ),
              //     // )
              //   ],
              // ),
            ),
            // children: [
            //   Column(
            //     children: [
            //       Text(
            //         'Message here ....',
            //       ),
            //       SizedBox(
            //         height: 50,
            //         width: 250,
            //         child: RegularButton(
            //           title: 'Confirm',
            //           onTap: () {},
            //         ),
            //       )
            //     ],
            //   )
            // ],
          ));
}
