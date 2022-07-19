import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/drawer_item.dart';

class CustomDrawer extends StatefulWidget {
  // const CustomDrawer({Key? key}) : super(key: key);
  CustomDrawer({this.index});
  int? index;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: eerieBlack,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 235,
              child: Text(
                'Visitor Invitation',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Divider(
                thickness: 2,
                color: spanishGray,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustDrawerItem(
                      title: 'New Visitor Invite',
                      onHighlight: onHighlight,
                      routeName: routeInvite,
                      selected: index == 0),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: CustDrawerItem(
                      title: 'My Invitation',
                      onHighlight: onHighlight,
                      routeName: routeMyInvite,
                      selected: index == 1),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: CustDrawerItem(
                      title: 'Employee data',
                      onHighlight: onHighlight,
                      routeName: routeEmployee,
                      selected: index == 2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
