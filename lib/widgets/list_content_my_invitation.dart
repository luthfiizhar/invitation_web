import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/detail_visitor_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_example/widgets/text_button.dart';

class ListItemMyInvititationDesktop extends StatefulWidget {
  ListItemMyInvititationDesktop({
    this.eventId,
    this.index,
    this.inviteId,
    this.totalVisitor,
    this.visitTime,
    this.visitor,
  });

  String? eventId;
  String? inviteId;
  String? visitTime;
  String? totalVisitor;
  List? visitor;
  int? index;
  Future? getActiveInvite;

  @override
  State<ListItemMyInvititationDesktop> createState() =>
      _ListItemMyInvititationDesktopState();
}

class _ListItemMyInvititationDesktopState
    extends State<ListItemMyInvititationDesktop> {
  bool detailIsLoading = false;
  Future getInvitationDetail(String inviteCode) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/invitation/get-invitation-detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """
      {
          "EventID" : "$inviteCode"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    // print('data->' + data['Data'].toString());

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      setState(() {
        widget.visitor = [data['Data']];
        // contohData = data['Data']['Invitations'];
      });
      return data['Data'];
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.index! % 2 == 0 ? scaffoldBg : silver,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.inviteId!,
                style: tableBodyCode,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                widget.visitTime!,
                style: tableBody,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '${widget.totalVisitor} Person',
                style: tableBody,
              ),
            ),
          ),
          detailIsLoading
              ? Flexible(
                  flex: 2,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: eerieBlack,
                    ),
                  ),
                )
              : Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CustTextButon(
                      label: 'Detail',
                      // fontSize: 20,
                      onTap: () {
                        setState(() {
                          detailIsLoading = true;
                        });
                        getInvitationDetail(widget.eventId!).then((value) {
                          // print('visitor -> ' + visitor.toString());
                          setState(() {
                            detailIsLoading = false;
                          });
                          dynamic listVisitor = value['Visitors'];
                          print('listVisitor - >' + listVisitor.toString());
                          Navigator.of(navKey.currentState!.overlay!.context)
                              .push(DetailVisitorOverlay(
                            visitorList: listVisitor,
                            eventID: widget.eventId,
                            inviteCode: widget.inviteId,
                            totalPerson: widget.totalVisitor,
                            visitDate: widget.visitTime,
                            employeeName: value['EmployeeName'],
                          ))
                              .then((value) {
                            setState(() {});
                          });
                        }).onError((error, stackTrace) {
                          setState(() {
                            detailIsLoading = false;
                          });
                        });
                      },
                      textStyle: textButton,
                    ),
                  ),
                ),
        ],
      ),
    );
    // return GestureDetector(
    //   onTap: () {
    //     getInvitationDetail(widget.eventId!).then((value) {
    //       setState(() {});
    //       detailIsLoading = false;
    //       dynamic listVisitor = value['Visitors'];
    //       Navigator.of(navKey.currentState!.overlay!.context)
    //           .push(DetailVisitorOverlay(
    //         visitorList: listVisitor,
    //         inviteCode: widget.inviteId,
    //         totalPerson: widget.totalVisitor,
    //         visitDate: widget.visitTime,
    //         employeeName: value['EmployeeName'],
    //       ));
    //     });
    //   },
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 10),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Expanded(
    //           flex: 10,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 widget.inviteId!,
    //                 style: tableBodyCode,
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8),
    //                 child: Text(
    //                   widget.visitTime!,
    //                   style: tableBody,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8),
    //                 child: Text(
    //                   '${widget.totalVisitor} Person',
    //                   style: tableBody,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           flex: 2,
    //           child: detailIsLoading
    //               ? CircularProgressIndicator(
    //                   color: eerieBlack,
    //                 )
    //               : ImageIcon(
    //                   AssetImage('assets/Forward.png'),
    //                 ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

class ListItemMyInviteMobile extends StatefulWidget {
  ListItemMyInviteMobile({
    this.eventId,
    this.index,
    this.inviteId,
    this.totalVisitor,
    this.visitTime,
    this.visitor,
    this.getActiveInvite,
  });

  String? eventId;
  String? inviteId;
  String? visitTime;
  String? totalVisitor;
  List? visitor;
  int? index;
  Future? getActiveInvite;

  @override
  State<ListItemMyInviteMobile> createState() => _ListItemMyInviteMobileState();
}

class _ListItemMyInviteMobileState extends State<ListItemMyInviteMobile> {
  bool detailIsLoading = false;
  Future getInvitationDetail(String inviteCode) async {
    print('hahaha');
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/invitation/get-invitation-detail');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """
      {
          "EventID" : "$inviteCode"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    // print('data->' + data['Data'].toString());

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      setState(() {
        widget.visitor = [data['Data']];
        // contohData = data['Data']['Invitations'];
      });
      return data['Data'];
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {});
        detailIsLoading = true;
        getInvitationDetail(widget.eventId!).then((value) {
          setState(() {});
          detailIsLoading = false;
          dynamic listVisitor = value['Visitors'];
          Navigator.of(navKey.currentState!.overlay!.context)
              .push(DetailVisitorOverlay(
            visitorList: listVisitor,
            inviteCode: widget.inviteId,
            totalPerson: widget.totalVisitor,
            visitDate: widget.visitTime,
            employeeName: value['EmployeeName'],
          ));
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 20,
              child: detailIsLoading
                  ? CircularProgressIndicator(
                      color: eerieBlack,
                    )
                  : ImageIcon(
                      AssetImage('assets/Forward.png'),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.inviteId!,
                        style: tableBodyCode,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.visitTime!,
                          style: tableBody,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${widget.totalVisitor} Person',
                          style: tableBody,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: detailIsLoading
                //       ? CircularProgressIndicator(
                //           color: eerieBlack,
                //         )
                //       : ImageIcon(
                //           AssetImage('assets/Forward.png'),
                //         ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
