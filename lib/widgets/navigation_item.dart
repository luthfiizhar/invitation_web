import 'package:flutter/material.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/interactive_drawer_item.dart';
import 'package:navigation_example/widgets/interactive_nav_item.dart';

class NavigationItem extends StatelessWidget {
  final String? title;
  final String? routeName;
  final bool? selected;
  final Function? onHighlight;

  const NavigationItem(
      {@required this.title, this.routeName, this.selected, this.onHighlight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '$routeName');
        navKey.currentState!.pushReplacementNamed(routeName!);
        onHighlight!(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: InteractiveNavItem(
          text: title,
          selected: selected,
          routeName: routeName,
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool? selected;
  final Function? onHighlight;
  const LogoutButton(
      {@required this.title, this.onTap, this.selected, this.onHighlight});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: InteractiveNavItem(
          text: title,
          selected: selected,
          // routeName: routeName,
        ),
      ),
    );
  }
}

class LogoutButtonMobile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool? selected;
  final Function? onHighlight;
  const LogoutButtonMobile(
      {@required this.title, this.onTap, this.selected, this.onHighlight});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: InteractiveDrawerItem(
          text: title,
          selected: selected,
          // routeName: routeName,
        ),
      ),
    );
  }
}
