import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/constant/text_style.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

Future<bool> confirmDialog(
    BuildContext context, String message, bool isDark) async {
  bool isLoading = false;
  bool shouldPop = true;
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            return Responsive.isDesktop(context)
                ? ConfirmDialog(
                    message: message,
                    isDark: isDark,
                  )
                : ConfirmDialog(
                    message: message,
                    isDark: isDark,
                  );
            // return AlertDialog(
            //   // contentPadding: Responsive.isDesktop(context)
            //   //     ? EdgeInsets.only(left: 7, right: 7)
            //   //     : EdgeInsets.zero,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(15)),
            //   // title:
            //   title: Padding(
            //     padding: Responsive.isDesktop(context)
            //         ? EdgeInsets.only(top: 25, left: 15, right: 15)
            //         : EdgeInsets.zero,
            //     child: Text(
            //       'Confirmation',
            //       style: TextStyle(
            //         fontSize: Responsive.isDesktop(context) ? 40 : 24,
            //         fontWeight: FontWeight.w700,
            //         color: isDark ? scaffoldBg : eerieBlack,
            //       ),
            //     ),
            //   ),
            //   backgroundColor: eerieBlack, //scaffoldBg,
            //   content: Container(
            //     padding: Responsive.isDesktop(context)
            //         ? EdgeInsets.symmetric(horizontal: 15)
            //         : EdgeInsets.symmetric(horizontal: 7),
            //     height: Responsive.isDesktop(context) ? 200 : 200,
            //     width: 400,
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [],
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(top: 0),
            //           child: Wrap(
            //             children: [
            //               // Row(
            //               //   mainAxisAlignment: MainAxisAlignment.start,
            //               //   children: [],
            //               // ),
            //               Text(
            //                 '$message',
            //                 style: TextStyle(
            //                   fontSize: Responsive.isDesktop(context) ? 24 : 18,
            //                   fontWeight: FontWeight.w300,
            //                   color: isDark ? scaffoldBg : eerieBlack,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(top: 30),
            //           child: SizedBox(
            //             height: Responsive.isDesktop(context) ? 50 : 40,
            //             // width: 250,
            //             child: RegularButton(
            //               isDark: isDark,
            //               sizeFont: Responsive.isDesktop(context) ? 20 : 16,
            //               title: 'Confirm',
            //               onTap: () {
            //                 Navigator.of(context).pop(true);
            //               },
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(top: 20),
            //           child: SizedBox(
            //             height: Responsive.isDesktop(context) ? 50 : 20,
            //             // width: 250,
            //             child: CustTextButon(
            //               isDark: isDark,
            //               fontSize: Responsive.isDesktop(context) ? 20 : 16,
            //               label: 'Cancel',
            //               onTap: () {
            //                 Navigator.of(context).pop(false);
            //               },
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          }));
}

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({
    super.key,
    this.message = "",
    this.isDark = true,
  });

  String message;
  bool isDark;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: isDark ? eerieBlack : white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Responsive.isDesktop(context)
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 580,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? eerieBlack : white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmation',
                      style: helveticaText.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: isDark ? white : eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      message,
                      style: helveticaText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: isDark ? white : eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 50 : 20,
                          width: 230,
                          child: CustTextButon(
                            isDark: isDark,
                            fontSize: Responsive.isDesktop(context) ? 20 : 16,
                            label: 'Cancel',
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: Responsive.isDesktop(context) ? 50 : 40,
                          width: 230,
                          child: RegularButton(
                            isDark: isDark,
                            sizeFont: Responsive.isDesktop(context) ? 20 : 16,
                            title: 'Confirm',
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirmation',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark ? white : eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    message,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: isDark ? white : eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 50 : 40,
                    width: double.infinity,
                    child: RegularButton(
                      isDark: isDark,
                      sizeFont: Responsive.isDesktop(context) ? 20 : 16,
                      title: 'Confirm',
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: Responsive.isDesktop(context) ? 50 : 40,
                    width: double.infinity,
                    child: CustTextButon(
                      isDark: isDark,
                      fontSize: Responsive.isDesktop(context) ? 20 : 16,
                      label: 'Cancel',
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
