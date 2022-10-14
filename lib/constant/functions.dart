import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/main.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:provider/provider.dart';

Future logout() async {
  var box = await Hive.openBox('userLogin');
  box.delete('name');
  box.delete('nip');
  // box.delete('jwtToken');
  box.put('jwtToken', "");
  Provider.of<MainModel>(navKey.currentState!.context, listen: false)
      .setIsExpired(true);
  Provider.of<MainModel>(navKey.currentState!.context, listen: false)
      .setJwt("");
  jwtToken = "";
}

Future getVisitorData(String visitorId) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
  print(visitorId);

  final url = Uri.https(apiUrl,
      '/VisitorManagementBackend/public/api/visitor/get-visitor-detail-website');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json'
  };
  var bodySend = """ 
      {
          "VisitorID" : "$visitorId"
      }
    """;

  var response = await http.post(url, headers: requestHeader, body: bodySend);
  var data = json.decode(response.body);
  // print(data);
  return data['Data'];
}

Future getVisitorApprovedData(String visitorId) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
  print(visitorId);

  final url = Uri.https(apiUrl,
      '/VisitorManagementBackend/public/api/visitor/approve-visitor-data');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json'
  };
  var bodySend = """ 
      {
          "VisitorID" : "$visitorId"
      }
    """;

  print(bodySend);
  var response = await http.post(url, headers: requestHeader, body: bodySend);
  var data = json.decode(response.body);
  // print('first name' + data['Data']['FirstName']);
  // if (data['Status'] == '200') {
  //   isLoading = false;
  // } else {
  //   isLoading = false;
  // }
  // setState(() {});
  return data;
}
