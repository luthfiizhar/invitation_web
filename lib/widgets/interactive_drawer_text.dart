import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';

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
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _hovering
                    ? Colors.white
                    : (widget.selected!)
                        ? Colors.white
                        : Colors.transparent),
            child: Text(
              widget.text!,
              style: _hovering
                  ? kPageTitleStyle.copyWith(color: eerieBlack)
                  : (widget.selected!)
                      ? kPageTitleStyle.copyWith(color: eerieBlack)
                      : kPageTitleStyle.copyWith(color: Colors.white),
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
