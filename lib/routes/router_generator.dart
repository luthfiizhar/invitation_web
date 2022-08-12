import 'package:flutter/material.dart';
import 'package:navigation_example/login.dart';
import 'package:navigation_example/my_app.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/confirm_invitation_page.dart';
import 'package:navigation_example/ui/employee_page.dart';
import 'package:navigation_example/ui/invite_page.dart';
import 'package:navigation_example/ui/login_page.dart';
import 'package:navigation_example/ui/my_invite_page.dart';

class RouteGenerator {
  RouteGenerator({
    this.jwt,
    this.isLoggedin,
    this.isExpired,
  });
  String? jwt;
  bool? isLoggedin;
  bool? isExpired;
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case routeHome:
      //   return MaterialPageRoute(builder: (_) => HomePage());
      //   break;
      // case routeAbout:
      //   return MaterialPageRoute(builder: (_) => AboutPage());
      //   break;
      // case routeContacts:
      //   return MaterialPageRoute(builder: (_) => ContactPage());
      //   break;
      case routeInvite:
        // return MaterialPageRoute(builder: (_) => InvitePage());
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => InvitePage(),
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
      case routeMyApp:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}
