import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/app_view.dart';
import 'package:navigation_example/main.dart';
import 'package:navigation_example/routes/router_generator.dart';
import 'package:navigation_example/routes/routes.dart';

class MyApp extends StatelessWidget {
  // bool isLoggedin = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Bar Web',
      theme: ThemeData(
        fontFamily: 'Helvetica',
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(),
      builder: (_, child) => AppView(
        child: child,
      ),
      initialRoute: jwtToken == null ? routeLogin : routeInvite,
      navigatorKey: navKey,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
