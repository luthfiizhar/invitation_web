import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/notification_dialog.dart';
import 'package:navigation_example/widgets/drawer.dart';
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
                InkWell(
                  onHover: (value) {},
                  onTap: () {
                    Navigator.of(context).push(NotificationOverlay());
                  },
                  child: Container(
                    // color: Colors.amber,
                    padding: EdgeInsets.all(2),
                    width: 30,
                    height: 30,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: eerieBlack),
                            child: Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: scaffoldBg,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // FittedBox(
                        //   // child:
                        //   //     Text('1'),
                        //   child: Image.asset('assets/icon_notif.png'),
                        //   fit: BoxFit.fitHeight,
                        // ),
                        Image.asset('assets/icon_notif.png')
                      ],
                    ),
                  ),
                ),
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

class NavigationBarMobile extends StatelessWidget {
  NavigationBarMobile({this.index});
  int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: scaffoldBg,
      height: 75.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              width: 300,
              height: 40,
              child: Text(
                'Visitor Invitation Website',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, bottom: 20),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Icon(
                Icons.menu_sharp,
                color: eerieBlack,
              ),
            ),
          )
          // TextButton.icon(
          //   onPressed: () {
          //     // _scaffoldKey
          //     Scaffold.of(context).openEndDrawer();
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => CustomDrawer(index: index),
          //     //   ),
          //     // );
          //   },
          //   icon: Icon(
          //     Icons.menu,
          //     color: eerieBlack,
          //   ),
          //   label: Text(''),
          // )
        ],
      ),
    );
  }
}
