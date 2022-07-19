import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/interactive_drawer_item.dart';

class CustDrawerItem extends StatelessWidget {
  // const CustDrawerItem({Key? key}) : super(key: key);
  final String? title;
  final String? routeName;
  final bool? selected;
  final Function? onHighlight;

  const CustDrawerItem(
      {@required this.title, this.routeName, this.selected, this.onHighlight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '$routeName');
        navKey.currentState!.pushReplacementNamed(routeName!);
        onHighlight!(routeName);
        // Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: InteractiveDrawerItem(
          text: title,
          selected: selected,
          routeName: routeName,
        ),
      ),
    );
  }
}
