import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:navigation_example/app_view.dart';
import 'package:navigation_example/login.dart';
import 'package:navigation_example/my_app.dart';
import 'package:navigation_example/routes/router_generator.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/home.dart';

String? nip;
String? name;
String? jwtToken;
loginCheck() async {
  var box = await Hive.openBox('userLogin');

  name = box.get('name') != "" ? box.get('name') : "";
  nip = box.get('nip') != "" ? box.get('nip') : "";
  jwtToken = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  print("jwt: " + jwtToken.toString());
}

void main() async {
  await Hive.initFlutter();
  loginCheck().then((_) {
    runApp(MyApp());
  });
}
