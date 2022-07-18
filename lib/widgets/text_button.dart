import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';

class CustTextButon extends StatelessWidget {
  const CustTextButon({Key? key, this.label, this.onTap}) : super(key: key);

  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text('$label'),
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.resolveWith<Color>((states) => eerieBlack),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) => textButtonRegular),
      ),
    );
  }
}
