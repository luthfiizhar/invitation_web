import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navigation_example/constant/color.dart';

class FooterInviteWeb extends StatelessWidget {
  const FooterInviteWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 90,
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
            left: 20,
            top: 10,
            child: Container(
              width: 270,
              height: 75,
              child: SvgPicture.asset(
                'assets/KLG_logo_white.svg',
                // color: Colors.white,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 30,
            child: Container(
                height: 50,
                width: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Copyright',
                      style: TextStyle(
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                    Text(
                      'NIP',
                      style: TextStyle(
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
