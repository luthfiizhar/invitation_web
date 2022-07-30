import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';

class FooterInviteWeb extends StatelessWidget {
  const FooterInviteWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: Responsive.isDesktop(context) ? 65 : 50,
      decoration: BoxDecoration(
          // border: Border()
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: eerieBlack),
      // color: eerieBlack,
      child: Stack(
        children: [
          Positioned(
            left: Responsive.isDesktop(context) ? 0 : 0,
            top: Responsive.isDesktop(context) ? 0 : 0,
            child: Container(
              // color: Colors.red,
              width: Responsive.isDesktop(context) ? 200 : 150,
              height: Responsive.isDesktop(context) ? 70 : 45,
              child: SvgPicture.asset(
                'assets/KLG_logo_white.svg',
                // color: Colors.white,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: Responsive.isDesktop(context) ? 30 : 15,
            top: Responsive.isDesktop(context) ? 25 : 12,
            child: Container(
              // color: Colors.red,
              height: Responsive.isDesktop(context) ? 23 : 15,
              width: Responsive.isDesktop(context) ? 186 : 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Facility Management',
                    style: TextStyle(
                      fontSize: Responsive.isDesktop(context) ? 18 : 12,
                      color: Color(0xFFF5F5F5),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //     height: Responsive.isDesktop(context) ? 50 : 30,
            //     width: Responsive.isDesktop(context) ? 90 : 60,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: [
            //         Text(
            //           'Facility Management',
            //           style: TextStyle(
            //             fontSize: Responsive.isDesktop(context) ? 20 : 12,
            //             color: Color(0xFFF5F5F5),
            //           ),
            //         ),
            //         Text(
            //           'NIP',
            //           style: TextStyle(
            //             fontSize: Responsive.isDesktop(context) ? 20 : 12,
            //             color: Color(0xFFF5F5F5),
            //           ),
            //         ),
            //       ],
            //     )),
          ),
        ],
      ),
      // Row(
      //   children: [
      //     Expanded(
      //       flex: 10,
      //       child: Container(
      //         // color: Colors.blue,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Expanded(
      //               flex: 2,
      //               child: Container(
      //                 padding: EdgeInsets.zero,
      //                 // margin: EdgeInsets.only(left: 30, top: 10),
      //                 // color: Colors.amber,
      // child: SvgPicture.asset(
      //   'assets/KLG_logo_white.svg',
      //   // color: Colors.white,
      // ),
      //               ),
      //             ),
      //             Expanded(flex: 10, child: SizedBox())
      //           ],
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       flex: 2,
      //       child: Text(
      //         'CopyRight',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
