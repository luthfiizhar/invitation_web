import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';

class InteractiveMyInviteMenu extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveMyInviteMenu({@required this.text, this.selected});

  @override
  InteractiveMyInviteMenuState createState() => InteractiveMyInviteMenuState();
}

class InteractiveMyInviteMenuState extends State<InteractiveMyInviteMenu> {
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
                    ? eerieBlack
                    : (widget.selected!)
                        ? eerieBlack
                        : Colors.transparent),
            child: Text(widget.text!,
                style: _hovering
                    ? kPageTitleStyle.copyWith(color: Colors.white)
                    : (widget.selected!)
                        ? kPageTitleStyle.copyWith(color: Colors.white)
                        : kPageTitleStyle),
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

class InteractiveMyInviteMenuMobile extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveMyInviteMenuMobile({@required this.text, this.selected});

  @override
  InteractiveMyInviteMenuMobileState createState() =>
      InteractiveMyInviteMenuMobileState();
}

class InteractiveMyInviteMenuMobileState
    extends State<InteractiveMyInviteMenuMobile> {
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
                    ? eerieBlack
                    : (widget.selected!)
                        ? eerieBlack
                        : Colors.transparent),
            child: Text(
              widget.text!,
              style: _hovering
                  ? TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors
                          .white) //kPageTitleStyleMobile.copyWith(color: Colors.white)
                  : (widget.selected!)
                      ? TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors
                              .white) //kPageTitleStyleMobile.copyWith(color: Colors.white)
                      : TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ), //kPageTitleStyleMobile,
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
