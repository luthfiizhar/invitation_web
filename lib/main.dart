import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:navigation_example/app_view.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/model/main_model.dart';
// import 'package:navigation_example/login.dart';
import 'package:navigation_example/my_app.dart';
// import 'package:navigation_example/routes/router_generator.dart';
// import 'package:navigation_example/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_example/routes/routes.dart';
import 'package:provider/provider.dart';

String? nip;
String? name;
String? jwtToken = "";
bool? isExpired = true;
bool? isLoggedIn = false;
loginCheck() async {
  var box = await Hive.openBox('userLogin');

  name = box.get('name') != "" ? box.get('name') : "";
  nip = box.get('nip') != "" ? box.get('nip') : "";
  jwtToken = box.get('jwTtoken') != "" || box.get('jwTtoken') != null
      ? box.get('jwtToken')
      : "";

  print("jwt: " + jwtToken.toString());
}

jwtCheck() async {
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
    // Provider.of<MainModel>(navKey.currentState!.context, listen: false)
    //     .setJwt(jwtToken!);
    isExpired = false;
    jwtToken = jwt;
  } else {
    // Provider.of<MainModel>(navKey.currentState!.context, listen: false)
    //     .setJwt(jwtToken!);
    isExpired = true;
    jwtToken = "";
    // Navigator.of(navKey.currentState!.context).pushReplacementNamed(routeLogin);
  }
}

void main() async {
  await Hive.initFlutter();
  loginCheck().then((_) {
    jwtCheck().then((_) {
      runApp(ChangeNotifierProvider<MainModel>(
          create: (context) => MainModel(), child: MyApp()));
    });
  });
}
