import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';

class CustTextButon extends StatelessWidget {
  CustTextButon({
    Key? key,
    this.label,
    this.onTap,
    this.isDark,
    this.fontSize,
    this.textStyle,
  }) : super(key: key);

  final String? label;
  final VoidCallback? onTap;
  bool? isDark;
  double? fontSize;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (isDark == null) {
      isDark = false;
    }
    if (fontSize == null) {
      fontSize = 20;
    }
    if (textStyle == null) {
      textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: isDark! ? scaffoldBg : eerieBlack,
      );
    }
    return TextButton(
      onPressed: onTap,
      child: Text(
        '$label',
      ),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => isDark! ? scaffoldBg : eerieBlack),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) => textStyle!),
      ),
    );
  }
}
