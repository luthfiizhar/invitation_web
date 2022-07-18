import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';

class AppView extends StatelessWidget {
  final Widget? child;

  const AppView({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size(MediaQuery.of(context).size.width, 120),
      //   child: NavigationBarWeb(),
      // ),
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
