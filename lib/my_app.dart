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
  Widget build(BuildContext context) {
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
        // initialRoute: model.jwt == "" ? routeLogin : routeInvite,
        navigatorKey: navKey,
        // onGenerateRoute: RouteGenerator.generateRoute,
        onGenerateRoute: (settings) {
          // checkLoginStatus();
          if (jwtToken == "") {
            print('notLoggedIn');
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  WelcomePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            );
          } else {
            print('LoggedIn');
            switch (settings.name) {
              case routeInvite:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      InvitePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case routeMyInvite:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MyInvitationPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case routeConfiemInvite:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ConfirmInvitePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              case routeEmployee:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      EmployeePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              // case routeLogin:
              //   return PageRouteBuilder(
              //     settings: settings,
              //     pageBuilder: (context, animation, secondaryAnimation) =>
              //         WelcomePage(),
              //     transitionDuration: Duration.zero,
              //     reverseTransitionDuration: Duration.zero,
              //   );
              default:
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      InvitePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
            }
          }
          // }
          // return null;
          // if (model.jwt == "") {
          //   return PageRouteBuilder(
          //     settings: settings,
          //     pageBuilder: (context, animation, secondaryAnimation) =>
          //         WelcomePage(),
          //     transitionDuration: Duration.zero,
          //     reverseTransitionDuration: Duration.zero,
          //   );
          // }
          // if (settings.name != routeLogin && model.jwt != "") {
          //   switch (settings.name) {
          //     case routeInvite:
          //       // return MaterialPageRoute(builder: (_) => InvitePage());
          //       return PageRouteBuilder(
          //         settings: settings,
          //         pageBuilder: (context, animation, secondaryAnimation) =>
          //             InvitePage(),
          //         transitionDuration: Duration.zero,
          //         reverseTransitionDuration: Duration.zero,
          //       );
          //     case routeMyInvite:
          //       // return MaterialPageRoute(builder: (_) => MyInvitationPage());
          //       return PageRouteBuilder(
          //         settings: settings,
          //         pageBuilder: (context, animation, secondaryAnimation) =>
          //             MyInvitationPage(),
          //         transitionDuration: Duration.zero,
          //         reverseTransitionDuration: Duration.zero,
          //       );
          //     case routeConfiemInvite:
          //       // return MaterialPageRoute(builder: (_) => ConfirmInvitePage());
          //       return PageRouteBuilder(
          //         settings: settings,
          //         pageBuilder: (context, animation, secondaryAnimation) =>
          //             ConfirmInvitePage(),
          //         transitionDuration: Duration.zero,
          //         reverseTransitionDuration: Duration.zero,
          //       );
          //     case routeEmployee:
          //       // return MaterialPageRoute(builder: (_) => EmployeePage());
          //       return PageRouteBuilder(
          //         settings: settings,
          //         pageBuilder: (context, animation, secondaryAnimation) =>
          //             EmployeePage(),
          //         transitionDuration: Duration.zero,
          //         reverseTransitionDuration: Duration.zero,
          //       );
          //     case routeLogin:
          //       // return MaterialPageRoute(builder: (_) => WelcomePage());
          //       return PageRouteBuilder(
          //         settings: settings,
          //         pageBuilder: (context, animation, secondaryAnimation) =>
          //             WelcomePage(),
          //         transitionDuration: Duration.zero,
          //         reverseTransitionDuration: Duration.zero,
          //       );
          //   }
          //   // }

          //   // return PageRouteBuilder(
          //   //   settings: settings,
          //   //   pageBuilder: (context, animation, secondaryAnimation) =>
          //   //       WelcomePage(),
          //   //   transitionDuration: Duration.zero,
          //   //   reverseTransitionDuration: Duration.zero,
          //   // );
          // } else {
          //   return PageRouteBuilder(
          //     settings: settings,
          //     pageBuilder: (context, animation, secondaryAnimation) =>
          //         WelcomePage(),
          //     transitionDuration: Duration.zero,
          //     reverseTransitionDuration: Duration.zero,
          //   );
          // }
        },
      ),
    );
  }
}
