import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/text_style.dart';
import 'package:navigation_example/main.dart';
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
    print("Drawer Index $index");
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
    jwtToken = "";
    isExpired = true;
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
      shadowColor: Colors.transparent,
      elevation: 0,
      backgroundColor: white,
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
                        'Visitor Management System',
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                        textAlign: TextAlign.right,
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 15),
                    //   child: Divider(
                    //     color: scaffoldBg,
                    //     thickness: 1,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustDrawerItem(
                              title: 'New Invite',
                              onHighlight: onHighlight,
                              routeName: routeInvite,
                              selected: index == 0,
                              indexSelected: 0),
                        ],
                      ),
                    ),
                    menuDivider(),
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
                    menuDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CustDrawerItem(
                              title: 'My Profile',
                              onHighlight: onHighlight,
                              routeName: routeEmployee,
                              selected: index == 2,
                              indexSelected: 2),
                        ),
                      ],
                    ),
                    menuDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LogoutButtonMobile(
                          title: 'Logout',
                          selected: index == 3,
                          onHighlight: onHighlight,
                          onTap: () {
                            logout().then((value) {
                              Scaffold.of(context).closeEndDrawer();
                              context.goNamed('login');
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 30,
          //   right: 25,
          //   child: ,
          // )
        ],
      ),
    );
  }

  Widget menuDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Divider(
        color: spanishGray,
        thickness: 0.5,
      ),
    );
  }
}
