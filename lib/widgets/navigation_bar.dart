import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/navigation_item.dart';

class NavigationBarWeb extends StatefulWidget {
  NavigationBarWeb({this.index});
  int? index;
  @override
  State<NavigationBarWeb> createState() => _NavigationBarWebState();
}

class _NavigationBarWebState extends State<NavigationBarWeb> {
  int? index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
  }

  @override
  void onHighlight(String route) {
    switch (route) {
      // case routeHome:
      //   changeHighlight(0);
      //   break;
      // case routeAbout:
      //   changeHighlight(1);
      //   break;
      // case routeContacts:
      //   changeHighlight(2);
      //   break;
      case routeInvite:
        changeHighlight(0);
        break;
      case routeMyInvite:
        changeHighlight(1);
        break;
      case routeEmployee:
        changeHighlight(2);
        break;
    }
  }

  void changeHighlight(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  Future logout() async {
    var box = await Hive.openBox('userLogin');
    box.delete('name');
    box.delete('nip');
    box.delete('jwtToken');
  }

  Widget build(BuildContext context) {
    return Container(
      color: scaffoldBg,
      height: 100.0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Container(
              width: 400,
              height: 40,
              child: Text(
                'Visitor Invitation Website',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NavigationItem(
                  title: 'New Invite',
                  routeName: routeInvite,
                  selected: index == 0,
                  onHighlight: onHighlight,
                ),
                NavigationItem(
                  title: 'My Invitation',
                  routeName: routeMyInvite,
                  selected: index == 1,
                  onHighlight: onHighlight,
                ),
                NavigationItem(
                  title: 'Employee',
                  routeName: routeEmployee,
                  selected: index == 2,
                  onHighlight: onHighlight,
                ),
                LogoutButton(
                  title: 'Logout',
                  selected: index == 4,
                  onHighlight: onHighlight,
                  onTap: () {
                    logout().then((value) {
                      Navigator.pushReplacementNamed(
                          navKey.currentState!.context, routeLogin);
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
