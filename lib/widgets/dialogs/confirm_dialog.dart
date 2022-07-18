import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

Future<bool> confirmDialog(BuildContext context, String message) async {
  bool shouldPop = true;
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            // title:
            backgroundColor: scaffoldBg,
            content: Container(
              height: 270,
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
                          color: eerieBlack,
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
                        style: dialogTitle,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('$message'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: 50,
                      width: 250,
                      child: RegularButton(
                        sizeFont: 20,
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
                      height: 50,
                      width: 250,
                      child: CustTextButon(
                        // sizeFont: 20,
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
