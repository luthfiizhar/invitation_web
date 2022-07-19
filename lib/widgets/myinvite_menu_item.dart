import 'package:flutter/material.dart';
import 'package:navigation_example/widgets/interactive_myinvite_menu_item.dart';

class MyInviteMenu extends StatelessWidget {
  const MyInviteMenu({
    Key? key,
    this.menuName,
    this.selected,
    this.onHighlight,
    this.index,
  }) : super(key: key);

  final String? menuName;
  final bool? selected;
  final Function? onHighlight;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(index);
      },
      child: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(10),
        child: InteractiveMyInviteMenuItem(text: menuName, selected: selected),
      ),
    );
  }
}

class MyInviteMenuMobile extends StatelessWidget {
  const MyInviteMenuMobile({
    Key? key,
    this.menuName,
    this.selected,
    this.onHighlight,
    this.index,
  }) : super(key: key);

  final String? menuName;
  final bool? selected;
  final Function? onHighlight;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(index);
      },
      child: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(10),
        child: InteractiveMyInviteMenuItemMobile(
            text: menuName, selected: selected),
      ),
    );
  }
}
