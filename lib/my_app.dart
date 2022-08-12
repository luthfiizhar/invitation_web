import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:navigation_example/app_view.dart';
import 'package:navigation_example/main.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/routes/router_generator.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // bool isLoggedin = true;
  RouteGenerator routerGenerator = RouteGenerator(
      jwt: jwtToken, isExpired: isExpired, isLoggedin: isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (context) => MainModel(),
      child: Listener(
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
          initialRoute:
              jwtToken == null || isExpired! ? routeLogin : routeInvite,
          navigatorKey: navKey,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
