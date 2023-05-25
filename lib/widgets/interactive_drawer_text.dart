import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/constant/text_style.dart';

class InteractiveDrawerText extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveDrawerText({@required this.text, this.selected});

  @override
  InteractiveDrawerTextState createState() => InteractiveDrawerTextState();
}

class InteractiveDrawerTextState extends State<InteractiveDrawerText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // width: 160,
        // height: 40,

        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            child: Text(
              widget.text!,
              style: _hovering
                  ? kPageTitleStyleMobile
                  : (widget.selected!)
                      ? kPageTitleStyleMobile
                      : helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: spanishGray,
                        ),
            ),
          ),
        ),
      ),

      // Text(widget.text!,
      // style: _hovering
      //     ? kPageTitleStyle.copyWith(color: Colors.indigo)
      //     : (widget.selected!)
      //         ? kPageTitleStyle.copyWith(color: Colors.red)
      //         : kPageTitleStyle),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
