import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/drawer_item.dart';
import 'package:navigation_example/widgets/navigation_item.dart';
import 'package:provider/provider.dart';

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
    // box.delete('jwtToken');
    box.put('jwtToken', "");
    Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        .setIsExpired(true);
    Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        .setJwt("");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: eerieBlack,
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    // Container(
                    //   height: 10,
                    //   decoration: BoxDecoration(
                    //     border: Border(
                    //       bottom: BorderSide(color: Colors.lightGreen, width: 3.0),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Divider(
                        color: scaffoldBg,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustDrawerItem(
                              title: 'New Visitor Invite',
                              onHighlight: onHighlight,
                              routeName: routeInvite,
                              selected: index == 0,
                              indexSelected: 0),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CustDrawerItem(
                              title: 'My Invitation',
                              onHighlight: onHighlight,
                              routeName: routeMyInvite,
                              selected: index == 1,
                              indexSelected: 1),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CustDrawerItem(
                              title: 'Employee data',
                              onHighlight: onHighlight,
                              routeName: routeEmployee,
                              selected: index == 2,
                              indexSelected: 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            right: 25,
            child: LogoutButtonMobile(
              title: 'Logout',
              selected: index == 3,
              onHighlight: onHighlight,
              onTap: () {
                logout().then((value) {
                  Scaffold.of(context).closeEndDrawer();
                  Navigator.pushReplacementNamed(
                      navKey.currentState!.context, routeLogin);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
