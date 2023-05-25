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
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = GoRouter(
    navigatorKey: navKey,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: WelcomePage(),
        ),
      ),
      GoRoute(
          path: '/invite',
          name: 'invite',
          pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: InvitePage(),
              ),
          routes: [
            GoRoute(
              path: 'confirmation',
              name: 'confirmation',
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ConfirmInvitePage(),
              ),
            )
          ]),
      GoRoute(
        path: '/my_invite',
        name: 'my_invite',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: MyInvitationPage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: EmployeePage(),
        ),
      ),
    ],
    initialLocation: '/invite',
    redirect: (context, state) {
      final login = state.subloc == '/login';
      // print(jwtToken);
      // print(isExpired);
      if ((jwtToken == null || jwtToken == "") || isExpired!) {
        return login ? null : '/login';
      }

      return null;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        title: 'Visitor Management System',
        theme: ThemeData(
          fontFamily: 'Helvetica',
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        routeInformationProvider: _router.routeInformationProvider,
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          minWidth: MediaQuery.of(context).size.width < 1100 ? 400 : 1366,
          defaultScale: MediaQuery.of(context).size.width < 1100 ? true : false,
          breakpoints: [],
        ),
      ),
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   title: 'Visitor Invitation Web',
      //   theme: ThemeData(
      //     fontFamily: 'Helvetica',
      //     primarySwatch: Colors.blue,
      //   ),
      //   // home: HomePage(),
      //   builder: (_, child) => AppView(
      //     child: child,
      //   ),
      //   // initialRoute: model.jwt == "" ? routeLogin : routeInvite,
      //   navigatorKey: navKey,
      //   // onGenerateRoute: RouteGenerator.generateRoute,
      //   onGenerateRoute: (settings) {
      //     // checkLoginStatus();
      //     if (jwtToken == "") {
      //       print('notLoggedIn');
      //       return PageRouteBuilder(
      //         settings: settings,
      //         pageBuilder: (context, animation, secondaryAnimation) =>
      //             WelcomePage(),
      //         transitionDuration: Duration.zero,
      //         reverseTransitionDuration: Duration.zero,
      //       );
      //     } else {
      //       print('LoggedIn');
      //       switch (settings.name) {
      //         case routeInvite:
      //           return PageRouteBuilder(
      //             settings: settings,
      //             pageBuilder: (context, animation, secondaryAnimation) =>
      //                 InvitePage(),
      //             transitionDuration: Duration.zero,
      //             reverseTransitionDuration: Duration.zero,
      //           );
      //         case routeMyInvite:
      //           return PageRouteBuilder(
      //             settings: settings,
      //             pageBuilder: (context, animation, secondaryAnimation) =>
      //                 MyInvitationPage(),
      //             transitionDuration: Duration.zero,
      //             reverseTransitionDuration: Duration.zero,
      //           );
      //         case routeConfiemInvite:
      //           return PageRouteBuilder(
      //             settings: settings,
      //             pageBuilder: (context, animation, secondaryAnimation) =>
      //                 ConfirmInvitePage(),
      //             transitionDuration: Duration.zero,
      //             reverseTransitionDuration: Duration.zero,
      //           );
      //         case routeEmployee:
      //           return PageRouteBuilder(
      //             settings: settings,
      //             pageBuilder: (context, animation, secondaryAnimation) =>
      //                 EmployeePage(),
      //             transitionDuration: Duration.zero,
      //             reverseTransitionDuration: Duration.zero,
      //           );
      //         // case routeLogin:
      //         //   return PageRouteBuilder(
      //         //     settings: settings,
      //         //     pageBuilder: (context, animation, secondaryAnimation) =>
      //         //         WelcomePage(),
      //         //     transitionDuration: Duration.zero,
      //         //     reverseTransitionDuration: Duration.zero,
      //         //   );
      //         default:
      //           return PageRouteBuilder(
      //             settings: settings,
      //             pageBuilder: (context, animation, secondaryAnimation) =>
      //                 InvitePage(),
      //             transitionDuration: Duration.zero,
      //             reverseTransitionDuration: Duration.zero,
      //           );
      //       }
      //     }
      //     // }
      //     // return null;
      //     // if (model.jwt == "") {
      //     //   return PageRouteBuilder(
      //     //     settings: settings,
      //     //     pageBuilder: (context, animation, secondaryAnimation) =>
      //     //         WelcomePage(),
      //     //     transitionDuration: Duration.zero,
      //     //     reverseTransitionDuration: Duration.zero,
      //     //   );
      //     // }
      //     // if (settings.name != routeLogin && model.jwt != "") {
      //     //   switch (settings.name) {
      //     //     case routeInvite:
      //     //       // return MaterialPageRoute(builder: (_) => InvitePage());
      //     //       return PageRouteBuilder(
      //     //         settings: settings,
      //     //         pageBuilder: (context, animation, secondaryAnimation) =>
      //     //             InvitePage(),
      //     //         transitionDuration: Duration.zero,
      //     //         reverseTransitionDuration: Duration.zero,
      //     //       );
      //     //     case routeMyInvite:
      //     //       // return MaterialPageRoute(builder: (_) => MyInvitationPage());
      //     //       return PageRouteBuilder(
      //     //         settings: settings,
      //     //         pageBuilder: (context, animation, secondaryAnimation) =>
      //     //             MyInvitationPage(),
      //     //         transitionDuration: Duration.zero,
      //     //         reverseTransitionDuration: Duration.zero,
      //     //       );
      //     //     case routeConfiemInvite:
      //     //       // return MaterialPageRoute(builder: (_) => ConfirmInvitePage());
      //     //       return PageRouteBuilder(
      //     //         settings: settings,
      //     //         pageBuilder: (context, animation, secondaryAnimation) =>
      //     //             ConfirmInvitePage(),
      //     //         transitionDuration: Duration.zero,
      //     //         reverseTransitionDuration: Duration.zero,
      //     //       );
      //     //     case routeEmployee:
      //     //       // return MaterialPageRoute(builder: (_) => EmployeePage());
      //     //       return PageRouteBuilder(
      //     //         settings: settings,
      //     //         pageBuilder: (context, animation, secondaryAnimation) =>
      //     //             EmployeePage(),
      //     //         transitionDuration: Duration.zero,
      //     //         reverseTransitionDuration: Duration.zero,
      //     //       );
      //     //     case routeLogin:
      //     //       // return MaterialPageRoute(builder: (_) => WelcomePage());
      //     //       return PageRouteBuilder(
      //     //         settings: settings,
      //     //         pageBuilder: (context, animation, secondaryAnimation) =>
      //     //             WelcomePage(),
      //     //         transitionDuration: Duration.zero,
      //     //         reverseTransitionDuration: Duration.zero,
      //     //       );
      //     //   }
      //     //   // }

      //     //   // return PageRouteBuilder(
      //     //   //   settings: settings,
      //     //   //   pageBuilder: (context, animation, secondaryAnimation) =>
      //     //   //       WelcomePage(),
      //     //   //   transitionDuration: Duration.zero,
      //     //   //   reverseTransitionDuration: Duration.zero,
      //     //   // );
      //     // } else {
      //     //   return PageRouteBuilder(
      //     //     settings: settings,
      //     //     pageBuilder: (context, animation, secondaryAnimation) =>
      //     //         WelcomePage(),
      //     //     transitionDuration: Duration.zero,
      //     //     reverseTransitionDuration: Duration.zero,
      //     //   );
      //     // }
      //   },
      // ),
    );
  }
}
