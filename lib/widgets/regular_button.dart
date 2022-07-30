import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:visitor_app/colors.dart';

class RegularButton extends StatelessWidget {
  // const RegularButton({Key? key}) : super(key: key);
  RegularButton(
      {required this.title,
      this.routeName,
      this.onTap,
      this.sizeFont,
      this.height,
      this.width,
      this.elevation,
      this.isDark});

  final String title;
  final String? routeName;
  final VoidCallback? onTap;
  final double? sizeFont;
  final double? width;
  final double? height;
  final double? elevation;
  bool? isDark;

  @override
  Widget build(BuildContext context) {
    double el;
    if (elevation == null) {
      el = 10;
    } else {
      el = elevation!;
    }
    if (isDark == null) {
      isDark = false;
    } else {
      isDark = true;
    }
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed
      };
      if (states.any(interactiveStates.contains)) {
        return isDark! ? scaffoldBg : eerieBlack;
      }
      return isDark! ? eerieBlack : Color(0xFFF7F7F7);
    }

    return ElevatedButton(
      onPressed: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Ink(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: Responsive.isDesktop(context)
                ? BorderRadius.circular(10)
                : BorderRadius.circular(7),
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark!
                  ? <Color>[scaffoldBg, scaffoldBg]
                  : <Color>[onyxBlack, eerieBlack],
            ),
          ),
          child: Center(
            child: Text(
              '$title',
            ),
          ),
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return TextStyle(
                fontFamily: 'Helvetica',
                fontSize: sizeFont == null ? 30 : sizeFont,
                fontWeight: FontWeight.w600,
                color: isDark! ? eerieBlack : scaffoldBg);
          }
          return TextStyle(
              fontFamily: 'Helvetica',
              fontSize: sizeFont == null ? 30 : sizeFont,
              fontWeight: FontWeight.w600,
              color: isDark! ? eerieBlack : Colors.white);
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: isDark! ? scaffoldBg : eerieBlack, width: 5));
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10));
        }),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed))
              return isDark! ? eerieBlack : Colors.white; //<-- SEE HERE
            return null; // Defer to the widget's default.
          },
        ),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(el),
        shadowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return Colors.black;
        }),
      ),
    );
  }
}
