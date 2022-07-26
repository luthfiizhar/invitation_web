import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/detail_visitor_dialog.dart';
import 'package:http/http.dart' as http;

class MyInviteDataSource extends DataTableSource {
  MyInviteDataSource({this.dataSource});

  final List? dataSource;
  static dynamic detailData;
  static dynamic visitorList;

  Future getDetailInvitation(String id) async {
    print('hahahaha');
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.http(apiUrl, '/api/invitation/get-invitation-detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "EventID" : "$id"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    // print(data['Data']);
    detailData = data['Data'];
    visitorList = data['Data']['Visitors'];
    print(visitorList);
    // print('detailData: ' + detailData.toString());
  }

  // final List<Map<String, dynamic>> _data = List.generate(
  //     200,
  //     (index) => {
  //           "id": index,
  //           "title": "Item $index",
  //           "price": Random().nextInt(10000),
  //         });
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    // throw UnimplementedError();
    return DataRow(
        // onSelectChanged: (value) {
        //   // inviteDetailDialog(
        //   //   navKey.currentState!.overlay!.context,
        //   //   dataSource![index]['Visitors'],
        //   //   dataSource![index]['InvitationID'].toString(),
        //   //   dataSource![index]['TotalVisitor'].toString(),
        //   //   dataSource![index]['VisitTime'].toString(),
        //   //   dataSource![index]['EmployeeName'].toString(),
        //   // );
        // },
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (index % 2 == 0) {
            return scaffoldBg;
          } else {
            return silver;
          }
        }),
        cells: [
          DataCell(
            Text(
              dataSource![index]['InvitationID'].toString(),
              style: tableBody,
            ),
          ),
          DataCell(
            Text(
              dataSource![index]["VisitTime"],
              style: tableBody,
            ),
          ),
          DataCell(
            Text(
              dataSource![index]["TotalVisitor"].toString(),
              style: tableBody,
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                // inviteDetailDialog(context);
                // getDetailInvitation(
                //   dataSource![index]['EventID'],
                // ).then((value) {
                //   Navigator.of(navKey.currentState!.overlay!.context)
                //       .push(DetailVisitorOverlay(
                //     employeeName: detailData!['EmployeeName'],
                //     inviteCode: detailData!['InvitationID'],
                //     totalPerson: detailData!['TotalVisitor'].toString(),
                //     visitDate: detailData['VisitTime'],
                //     visitorList: visitorList,
                //   ));
                // });

                Navigator.of(navKey.currentState!.overlay!.context)
                    .push(DetailVisitorOverlay(
                  visitorList: dataSource![index]['Visitors'],
                  inviteCode: dataSource![index]['InvitationID'],
                  totalPerson: dataSource![index]['TotalVisitor'],
                  visitDate: dataSource![index]['VisitTime'],
                  employeeName: dataSource![index]['EmployeeName'],
                ));

                // inviteDetailDialog(
                //   navKey.currentState!.overlay!.context,
                //   dataSource![index]['Visitors'],
                //   dataSource![index]['InvitationID'],
                //   dataSource![index]['TotalVisitor'],
                //   dataSource![index]['VisitTime'],
                //   dataSource![index]['EmployeeName'],
                // );
              },
              child: Text(
                'Detail',
                style: textButton,
              ),
            ),
          ),
        ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false; //throw UnimplementedError();

  @override
  // TODO: implement rowCount
  int get rowCount => dataSource!.length; //throw UnimplementedError();

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0; //throw UnimplementedError();
}
