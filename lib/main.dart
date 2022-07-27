import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:navigation_example/app_view.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/login.dart';
import 'package:navigation_example/my_app.dart';
import 'package:navigation_example/routes/router_generator.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/home.dart';
import 'package:http/http.dart' as http;

String? nip;
String? name;
String? jwtToken;
bool? isExpired = true;
loginCheck() async {
  var box = await Hive.openBox('userLogin');

  name = box.get('name') != "" ? box.get('name') : "";
  nip = box.get('nip') != "" ? box.get('nip') : "";
  jwtToken = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  print("jwt: " + jwtToken.toString());
}

jwtCheck() async {
  var box = await Hive.openBox('userLogin');
  // var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
  var jwt = "$jwtToken";
  // print("List: " + list.toString());

  // var newList = json.encode(list);
  // print(newList);

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
    isExpired = false;
  } else {
    isExpired = true;
  }
}

void main() async {
  await Hive.initFlutter();
  loginCheck().then((_) {
    jwtCheck().then((_) {
      runApp(MyApp());
    });
  });
}
