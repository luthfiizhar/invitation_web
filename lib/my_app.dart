import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:hive/hive.dart';
import 'package:navigation_example/app_view.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/main.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/routes/router_generator.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/confirm_invitation_page.dart';
import 'package:navigation_example/ui/employee_page.dart';
import 'package:navigation_example/ui/invite_page.dart';
import 'package:navigation_example/ui/login_page.dart';
import 'package:navigation_example/ui/my_invite_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginCheck().then((value) {
      jwtCheck().then((value) {
        if (!mounted) return;
        // Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        //     .setJwt(jwtToken!);
      });
    });
  }

  // bool isLoggedin = true;
  RouteGenerator routerGenerator = RouteGenerator(
      jwt: jwtToken, isExpired: isExpired, isLoggedin: isLoggedIn);

  Future loginCheck() async {
    var box = await Hive.openBox('userLogin');

    name = box.get('name') != "" ? box.get('name') : "";
    nip = box.get('nip') != "" ? box.get('nip') : "";
    jwtToken = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    print("jwt: " + jwtToken.toString());
    Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        .setJwt(jwtToken!);
    // return jwtToken;
  }

  Future jwtCheck() async {
    var box = await Hive.openBox('userLogin');
    // var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    var jwt = "$jwtToken";
    // print("List: " + list.toString());

    // var newList = json.encode(list);
    // print(newList);
    // jwt = 'aaa';
    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/check-token-website');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
    """;

    print(bodySend);

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data);

    if (data['Status'] == "200") {
      // Provider.of<MainModel>(navKey.currentState!.context, listen: false)
      //     .setIsExpired(false);
      isExpired = false;
      jwtToken = jwt;
    } else {
      // Provider.of<MainModel>(navKey.currentState!.context, listen: false)
      //     .setIsExpired(true);
      isExpired = true;
      jwtToken = "";
      // Navigator.of(navKey.currentState!.context).pushReplacementNamed(routeLogin);
    }
    Provider.of<MainModel>(navKey.currentState!.context, listen: false)
        .setJwt(jwtToken!);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (context) => MainModel(),
      child: Consumer<MainModel>(builder: (context, model, child) {
        return Listener(
          onPointerDown: (_) {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Visitor Invitation Web',
            theme: ThemeData(
              fontFamily: 'Helvetica',
              primarySwatch: Colors.blue,
            ),
            // home: HomePage(),
            builder: (_, child) => AppView(
              child: child,
            ),
            // initialRoute:
            //     jwtToken == null || isExpired! ? routeLogin : routeInvite,
            navigatorKey: navKey,
            // onGenerateRoute: RouteGenerator.generateRoute,
            onGenerateRoute: (settings) {
              if (model.jwt == "") {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      WelcomePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              }
              if (settings.name != routeLogin && model.jwt != "") {
                switch (settings.name) {
                  case routeInvite:
                    // return MaterialPageRoute(builder: (_) => InvitePage());
                    return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          InvitePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    );
                  case routeMyInvite:
                    // return MaterialPageRoute(builder: (_) => MyInvitationPage());
                    return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          MyInvitationPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    );
                  case routeConfiemInvite:
                    // return MaterialPageRoute(builder: (_) => ConfirmInvitePage());
                    return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ConfirmInvitePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    );
                  case routeEmployee:
                    // return MaterialPageRoute(builder: (_) => EmployeePage());
                    return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          EmployeePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    );
                  case routeLogin:
                    // return MaterialPageRoute(builder: (_) => WelcomePage());
                    return PageRouteBuilder(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          WelcomePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    );
                }
                // }

                // return PageRouteBuilder(
                //   settings: settings,
                //   pageBuilder: (context, animation, secondaryAnimation) =>
                //       WelcomePage(),
                //   transitionDuration: Duration.zero,
                //   reverseTransitionDuration: Duration.zero,
                // );
              } else {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      WelcomePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              }
            },
          ),
        );
      }),
    );
  }
}
