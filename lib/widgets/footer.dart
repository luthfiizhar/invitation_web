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
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/KLG_logo_white.svg',
                  // color: Colors.white,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'CopyRight',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
