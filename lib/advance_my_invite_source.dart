import 'dart:convert';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/my_invite.dart';
import 'package:http/http.dart' as http;

class ExampleSource extends AdvancedDataTableSource<MyInviteModel> {
  // ExampleSource({this.dataSource});
  // final List? dataSource;
  List<String> selectedIds = [];
  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) =>
      lastDetails!.rows[index].getRow(selectedRow, selectedIds);

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<MyInviteModel>> getNextPage(
    NextPageRequest pageRequest,
  ) async {
    print('hahahaha');
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.http(apiUrl, '/api/invitation/invitation-list-all');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "SortBy" : "VisitTime",
          "SortDir" : "ASC"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data['Data']);

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      print('HAHAHAHAHAHA');
      List<dynamic> listInvitations = data['Data']['Invitations'];
      print("list Invitations: " + listInvitations.toString());
      // final data = jsonDecode(response.body);
      return RemoteDataSourceDetails(
        int.parse(data['Data']['TotalData'].toString()),
        listInvitations
            .map(
              (json) => MyInviteModel.fromJson(json as Map<String, dynamic>),
            )
            .toList(),
        filteredRows: listInvitations.length,
        // filteredRows: lastSearchTerm.isNotEmpty
        //     ? (data['Data']['Invitations'] as List<dynamic>).length
        //     : null,
      );
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}
