import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/widgets/drawer.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';

class AppView extends StatelessWidget {
  final Widget? child;
  int? index = 0;
  AppView({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldK,
      // appBar: PreferredSize(
      //   preferredSize: Size(MediaQuery.of(context).size.width, 120),
      //   child: NavigationBarWeb(),
      // ),
      // drawer: Responsive.isDesktop(context) ? null : CustomDrawer(),
      endDrawer: Responsive.isDesktop(context)
          ? null
          : CustomDrawer(
              index: index,
            ),
      backgroundColor: scaffoldBg,
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
