import 'package:flutter/material.dart';
import 'package:navigation_example/login.dart';
import 'package:navigation_example/my_app.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/about.dart';
import 'package:navigation_example/ui/confirm_invitation_page.dart';
import 'package:navigation_example/ui/contact.dart';
import 'package:navigation_example/ui/employee_page.dart';
import 'package:navigation_example/ui/home.dart';
import 'package:navigation_example/ui/invite_page.dart';
import 'package:navigation_example/ui/login_page.dart';
import 'package:navigation_example/ui/my_invite_page.dart';

class RouteGenerator {
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
        return MaterialPageRoute(builder: (_) => InvitePage());
        break;
      case routeMyInvite:
        return MaterialPageRoute(builder: (_) => MyInvitationPage());
        break;
      case routeConfiemInvite:
        return MaterialPageRoute(builder: (_) => ConfirmInvitePage());
        break;
      case routeEmployee:
        return MaterialPageRoute(builder: (_) => EmployeePage());
        break;
      case routeLogin:
        return MaterialPageRoute(builder: (_) => WelcomePage());
        break;
      case routeMyApp:
        return MaterialPageRoute(builder: (_) => MyApp());
        break;
    }
  }
}
