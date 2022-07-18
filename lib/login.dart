import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/routes/router_generator.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/login_page.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Bar Web',
      theme: ThemeData(
        fontFamily: 'Helvetica',
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
      // builder: (_, child) => AppView(
      //   child: child,
      // ),
      // initialRoute: routeLogin,
      // navigatorKey: navKey,
      // onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
