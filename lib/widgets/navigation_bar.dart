// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/notification_dialog.dart';
import 'package:navigation_example/widgets/drawer.dart';
import 'package:navigation_example/widgets/navigation_item.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NavigationBarWeb extends StatefulWidget {
  NavigationBarWeb({this.index});
  int? index;
  @override
  State<NavigationBarWeb> createState() => _NavigationBarWebState();
}

class _NavigationBarWebState extends State<NavigationBarWeb> {
  int? index;
  int? notif = 0;

  Future getNotif() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/notification/web-notification');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: requestHeader);
    var data = json.decode(response.body);
    // print(data);

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotif().then((value) {
      setState(() {});
      notif = value['Data']['EventNotification'];
    });
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
    // box.delete('jwtToken');
    box.put('jwtToken', "");
    Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        .setIsExpired(true);
    Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        .setJwt("");
  }

  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(right: 30, bottom: 25),
      color: scaffoldBg,
      // height: 90.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30, bottom: 5, top: 13),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                // color: Colors.amber,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 0),
                      child: Container(
                        width: 400,
                        // height: 40,
                        // color: Colors.blue,
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 8, right: 8),
                        child: const Text(
                          'Visitor Invitation Web',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.green,
                        padding: EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.center,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          notif! > 0
              ? Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: eerieBlack,
                  child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                          text: 'You have $notif active invitation today, ',
                          style: TextStyle(
                              color: scaffoldBg,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                          children: [
                            TextSpan(
                                text: 'click here!',
                                style: TextStyle(
                                    color: scaffoldBg,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    navKey.currentState!
                                        .pushReplacementNamed(routeMyInvite);
                                    onHighlight(routeMyInvite);
                                  })
                          ]),
                    ),
                  ),
                )
              : SizedBox(),
          notif == 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.94,
                    height: 1,
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      border: Border(
                        bottom: BorderSide(color: eerieBlack, width: 1),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class NavigationBarMobile extends StatefulWidget {
  NavigationBarMobile({this.index});
  int? index;

  @override
  State<NavigationBarMobile> createState() => _NavigationBarMobileState();
}

class _NavigationBarMobileState extends State<NavigationBarMobile> {
  int? index = 0;
  int? notif = 0;

  Future getNotif() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/notification/web-notification');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };

    var response = await http.get(url, headers: requestHeader);
    var data = json.decode(response.body);
    // print(data);

    return data;
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotif().then((value) {
      setState(() {});
      notif = value['Data']['EventNotification'];
    });
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, child) {
      return Container(
        // color: scaffoldBg,
        decoration: BoxDecoration(
          color: scaffoldBg,
          // border: Border.fromBorderSide(BorderSide(color: eerieBlack, width: 1)),
        ),
        height: 90.0,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 0),
                    child: Container(
                      width: 300,
                      // height: 40,
                      child: const Text(
                        'Visitor Invitation Web',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.only(right: 15, bottom: 20, top: 15),
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: SizedBox(
                          // height: 75,
                          width: 75,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.menu_sharp,
                              color: eerieBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            notif == 0
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.94,
                      height: 1,
                      decoration: BoxDecoration(
                        // color: Colors.blue,
                        border: Border(
                          bottom: BorderSide(color: eerieBlack, width: 1),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            notif! > 0
                ? Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    color: eerieBlack,
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                            text: 'You have $notif active invitation today, ',
                            style: TextStyle(
                                color: scaffoldBg,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                            children: [
                              TextSpan(
                                  text: 'click here!',
                                  style: TextStyle(
                                      color: scaffoldBg,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      navKey.currentState!
                                          .pushReplacementNamed(routeMyInvite);
                                      model.setIndexDrawer(1);
                                      onHighlight(routeMyInvite);
                                    })
                            ]),
                      ),
                    ),
                  )
                : SizedBox(),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * 0.97,
            //     height: 1,
            //     decoration: BoxDecoration(
            //       // color: Colors.blue,
            //       border: Border(
            //         bottom: BorderSide(color: eerieBlack, width: 1),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
