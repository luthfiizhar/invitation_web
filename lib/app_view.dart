import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/widgets/drawer.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';
import 'package:provider/provider.dart';

class AppView extends StatelessWidget {
  final Widget? child;
  // int? index;
  AppView({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Responsive.isDesktop(context)
          ? null
          : Consumer<MainModel>(builder: (context, model, child) {
              int index = model.indexDrawer;
              return CustomDrawer(
                index: index,
              );
            }),
      backgroundColor: white,
      body: Column(
        children: [
          Expanded(child: child!),
          // FooterInviteWeb(),
        ],
      ),
      // bottomNavigationBar: FooterInviteWeb(),
    );
  }
}
