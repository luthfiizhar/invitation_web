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
      height: Responsive.isDesktop(context) ? 90 : 50,
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
            left: Responsive.isDesktop(context) ? -15 : 5,
            top: Responsive.isDesktop(context) ? 10 : 5,
            child: Container(
              width: Responsive.isDesktop(context) ? 270 : 100,
              height: Responsive.isDesktop(context) ? 75 : 35,
              child: SvgPicture.asset(
                'assets/KLG_logo_white.svg',
                // color: Colors.white,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: Responsive.isDesktop(context) ? 30 : 10,
            top: Responsive.isDesktop(context) ? 30 : 10,
            child: Container(
                height: Responsive.isDesktop(context) ? 50 : 30,
                width: Responsive.isDesktop(context) ? 90 : 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Copyright',
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context) ? 20 : 12,
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                    Text(
                      'NIP',
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context) ? 20 : 12,
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                  ],
                )),
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
