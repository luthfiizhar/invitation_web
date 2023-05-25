import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/constant/text_style.dart';

class InteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveText({@required this.text, this.selected});

  @override
  InteractiveTextState createState() => InteractiveTextState();
}

class InteractiveTextState extends State<InteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Text(
        widget.text!,
        style: _hovering
            ? navBarText.copyWith(
                fontSize: 18, color: davysGray, fontWeight: FontWeight.w400)
            : (widget.selected!)
                ? navBarText.copyWith(
                    fontSize: 18, color: davysGray, fontWeight: FontWeight.w400)
                : navBarText.copyWith(
                    fontSize: 18,
                    color: sonicSilver,
                    fontWeight: FontWeight.w300,
                  ),
      ),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
