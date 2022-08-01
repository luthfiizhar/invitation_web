import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_example/constant/constant.dart';

Future logout() async {
  var box = await Hive.openBox('userLogin');
  box.delete('name');
  box.delete('nip');
  box.delete('jwtToken');
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

  // if (data['Status'] == '200') {
  //   isLoading = false;
  // } else {
  //   isLoading = false;
  // }
  // setState(() {});
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
