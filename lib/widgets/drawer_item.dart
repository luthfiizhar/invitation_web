import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/interactive_drawer_item.dart';
import 'package:provider/provider.dart';

class CustDrawerItem extends StatelessWidget {
  // const CustDrawerItem({Key? key}) : super(key: key);
  final String? title;
  final String? routeName;
  final bool? selected;
  final Function? onHighlight;
  int? indexSelected;

  CustDrawerItem(
      {@required this.title,
      this.routeName,
      this.selected,
      this.onHighlight,
      this.indexSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, child) {
      return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(context, '$routeName');
          Scaffold.of(navKey.currentState!.context).closeEndDrawer();
          navKey.currentState!.pushReplacementNamed(routeName!);
          onHighlight!(routeName);
          model.setIndexDrawer(indexSelected!);
          print(model.indexDrawer);

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
    });
  }
}
