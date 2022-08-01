import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/constant/functions.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/add_visitor_dialog.dart';
import 'package:navigation_example/widgets/dialogs/change_visit_time_dialog.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/dialogs/detail_info_visitor_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/dialogs/visitor_data.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';
import 'package:http/http.dart' as http;

class DetailVisitorOverlay extends ModalRoute<void> {
  DetailVisitorOverlay(
      {this.visitorList,
      this.eventID,
      this.visitDate,
      this.employeeName,
      this.inviteCode,
      this.totalPerson});
  List? visitorList;
  String? eventID;
  String? visitDate;
  String? inviteCode;
  String? totalPerson;
  String? employeeName;
  bool? isHover = false;
  String? isVerified = 'AAA';
  bool? cancelButtonLoading = false;

  bool isLoading = false;
  Widget listVisitorDetailDialog(
    bool isHover,
    String name,
    String email,
    String verified,
    String visitorId,
    int index,
    int length,
  ) {
    return Container(
      child: Column(
        children: [
          StatefulBuilder(builder: (context, StateSetter setState) {
            bool removeVisible = false;
            return InkWell(
              onHover: (value) {
                setState(() {
                  isHover = value;
                });
              },
              onTap: () {
                if (verified == "APPROVED") {
                  getVisitorData(visitorId).then((value) {
                    // print(value["Status"]);
                    dynamic listDetail = json.encode(value);
                    // print("list Detail Approved -> " + listDetail.toString());
                    Navigator.of(context)
                        .push(VisitorDataOverlay(listDetail: listDetail));
                    // }).onError((error, stackTrace) {
                    //   Navigator.of(context)
                    //       .push(VisitorDataOverlay(listDetail: ""));
                  }).onError((error, stackTrace) {
                    print(error);
                  });
                } else {
                  getVisitorData(visitorId).then((value) {
                    dynamic listDetail = json.encode(value);
                    print(
                        "list Detail not approved -> " + listDetail.toString());
                    Navigator.of(context).push(
                      VisitorConfirmationOverlay(listDetail: listDetail),
                    );
                  });
                }

                // Navigator.of(context).push(VisitorDataOverlay());
                // getVisitorData(visitorId);
                // verified == "APPROVED"
                //     ? Navigator.of(context).push(VisitorDataOverlay())
                //     : Navigator.of(context).push(VisitorConfirmationOverlay());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: Responsive.isDesktop(context) ? 10 : 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(
                            fontSize: Responsive.isDesktop(context) ? 20 : 16,
                            fontWeight: FontWeight.w700,
                            color: onyxBlack,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            '$email',
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context) ? 20 : 16,
                              fontWeight: FontWeight.w300,
                              color: onyxBlack,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            verified == "APPROVED"
                                ? 'Visitor Verified'
                                : 'Visitor not yet Verified',
                            style: TextStyle(
                              fontSize: Responsive.isDesktop(context) ? 16 : 14,
                              fontWeight: FontWeight.w300,
                              color: verified == "APPROVED"
                                  ? Color(0xFF0DB14B)
                                  : Color(0xFFF26529),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: Responsive.isDesktop(context) ? 2 : 3,
                    child: Row(
                      children: [
                        // Icon(Icons.check),
                        verified == "APPROVED"
                            ? SizedBox(
                                width: Responsive.isDesktop(context) ? 30 : 20,
                                child: ImageIcon(
                                  AssetImage('assets/icon_verified.png'),
                                ),
                              )
                            : SizedBox(
                                width: Responsive.isDesktop(context) ? 30 : 20,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Visibility(
                            visible: Responsive.isMobile(context)
                                ? true
                                : isHover
                                    ? true
                                    : false,
                            child: GestureDetector(
                              onTap: () {
                                removeVisitorConfirmDialog(context, visitorId)
                                    .then((value) {
                                  getInvitationDetail(eventID!).then(
                                    (value) {
                                      setState(
                                        () {
                                          visitorList = value['Visitors'];
                                          totalPerson =
                                              visitorList!.length.toString();
                                        },
                                      );
                                    },
                                  );
                                });
                                setState(
                                  () {},
                                );
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: index == length - 1
                ? SizedBox()
                : Divider(
                    thickness: 1,
                    color: spanishGray,
                  ),
          ),
        ],
      ),
    );
  }

  Future getInvitationDetail(String eventId) async {
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
          "EventID" : "$eventId"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    // print('data->' + data['Data'].toString());

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      setState(() {
        visitorList = [data['Data']];
        // contohData = data['Data']['Invitations'];
      });
      return data['Data'];
    } else {}
  }

  Future removeVisitorConfirmDialog(BuildContext context, String visitorId) {
    return confirmDialog(
            context, 'Are you sure want to remove this guest?', true)
        .then((value) {
      if (value) {
        removeVisitor(visitorId).then((value) {
          print(value);
          if (value['Status'] == "200") {
            Navigator.of(context)
                .push(NotifProcessDialog(
                    message: '${value['Message']}', isSuccess: true))
                .then((value) {});
          } else {
            Navigator.of(context)
                .push(NotifProcessDialog(
                    message: '${value['Message']}', isSuccess: false))
                .then((value) {
              setState(
                () {},
              );
            });
          }
        });
      } else {
        // Navigator.of(context).pop();
      }
    });
  }

  showConfirmDialog(BuildContext context) {
    return confirmDialog(
            context, 'Are you sure want cancel the invitation?', true)
        .then((value) {
      if (value) {
        cancelInvitation(eventID!).then((value) {
          print(value);
          setState(() {});
          cancelButtonLoading = false;
          if (value['Status'] == '200') {
            Navigator.push(
                    context,
                    NotifProcessDialog(
                        message: 'Cancel event success', isSuccess: true))
                .then((value) {
              Navigator.of(context).pop();
            });
          } else {
            Navigator.push(
                    context,
                    NotifProcessDialog(
                        message: 'Cancel event failed', isSuccess: false))
                .then((value) {
              Navigator.of(context).pop();
            });
          }
          // Navigator.of(context).pop();
        });
      } else {
        // Navigator.of(context).pop();
      }
    });
  }

  Future cancelInvitation(String eventId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/event/cancel-event');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
        "EventID" : "$eventId"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    // print('data->' + data['Data'].toString());

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      isLoading = false;
    } else {
      isLoading = false;
    }
    return data;
  }

  Future removeVisitor(String visitorId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/visitor/remove-visitor');
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
    // print('data->' + data['Data'].toString());

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      isLoading = false;
    } else {
      isLoading = false;
    }
    return data;
  }

  // Future getInvitationDetail(String inviteCode) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var box = await Hive.openBox('userLogin');
  //   var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
  //   // print(jwt);

  //   final url = Uri.https(apiUrl,
  //       '/VisitorManagementBackend/public/api/invitation/get-invitation-detail');
  //   Map<String, String> requestHeader = {
  //     'Authorization': 'Bearer $jwt',
  //     'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
  //     'Content-Type': 'application/json'
  //   };
  //   var bodySend = """
  //     {
  //         "EventID" : "$inviteCode"
  //     }
  //   """;

  //   var response = await http.post(url, headers: requestHeader, body: bodySend);
  //   var data = json.decode(response.body);
  //   // print('data->' + data['Data'].toString());

  //   // final response = await http.get(requestUri);
  //   if (data['Status'] == '200') {
  //     isLoading = false;
  //   } else {
  //     isLoading = false;
  //   }
  //   setState(() {});
  //   return data['Data'];
  // }

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return StatefulBuilder(
      builder: (context, setState) {
        // getInvitationDetail(eventID!).then((value) => setState(
        //       () {},
        //     ));
        return Padding(
          padding: Responsive.isDesktop(context)
              ? EdgeInsets.all(15.0)
              : EdgeInsets.only(top: 15, bottom: 15),
          child: Center(
            child: Container(
              width: 500,
              // color: scaffoldBg,
              decoration: BoxDecoration(
                borderRadius: Responsive.isDesktop(context)
                    ? BorderRadius.circular(15)
                    : BorderRadius.circular(10),
                color: scaffoldBg,
              ),
              child: Stack(
                // alignment: Alignment.topCenter,
                children: [
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            Responsive.isDesktop(navKey.currentState!.context)
                                ? EdgeInsets.only(left: 50, right: 50, top: 30)
                                : EdgeInsets.only(left: 25, right: 25, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     Icon(
                            //       Icons.close,
                            //       size: 30,
                            //     )
                            //     // TextButton.icon(
                            //     //   onPressed: () {
                            //     //     Navigator.of(context).pop(false);
                            //     //   },
                            //     //   icon: Icon(
                            //     //     Icons.close,
                            //     //     color: eerieBlack,
                            //     //     size: 30,
                            //     //   ),
                            //     //   label: Text(''),
                            //     // ),
                            //   ],
                            // ),

                            Padding(
                              padding: Responsive.isDesktop(context)
                                  ? EdgeInsets.only(top: 10, bottom: 30)
                                  : EdgeInsets.only(top: 0, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Invitation Detail',
                                    style: dialogTitle,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 550,
                              child: Text(
                                'Invite Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 18 : 14,
                                  color: onyxBlack,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 7),
                              child: Text(
                                '$inviteCode',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Responsive.isBigDesktop(context)
                                        ? 32
                                        : 20,
                                    color: onyxBlack),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Responsive.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // padding: EdgeInsets.only(top: 30),
                                                child: Text(
                                                  'Visit Time',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        Responsive.isDesktop(
                                                                context)
                                                            ? 18
                                                            : 18,
                                                    color: onyxBlack,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 7),
                                                child: Text(
                                                  '$visitDate',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize:
                                                        Responsive.isDesktop(
                                                                context)
                                                            ? 20
                                                            : 20,
                                                    color: onyxBlack,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // padding: EdgeInsets.only(top: 30),
                                                child: Text(
                                                  'Total Visitor',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        Responsive.isDesktop(
                                                                context)
                                                            ? 18
                                                            : 18,
                                                    color: onyxBlack,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 7),
                                                child: Text(
                                                  '$totalPerson Person',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize:
                                                        Responsive.isDesktop(
                                                                context)
                                                            ? 20
                                                            : 20,
                                                    color: onyxBlack,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // padding: EdgeInsets.only(top: 30),
                                          child: Text(
                                            'Visit Time',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Responsive.isDesktop(context)
                                                      ? 18
                                                      : 14,
                                              color: eerieBlack,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 7),
                                          child: Text(
                                            '$visitDate',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize:
                                                  Responsive.isDesktop(context)
                                                      ? 20
                                                      : 16,
                                              color: onyxBlack,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            // padding: EdgeInsets.only(top: 30),
                                            child: Text(
                                              'Total Visitor',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 18
                                                    : 14,
                                                color: eerieBlack,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 7),
                                          child: Text(
                                            '$totalPerson Person',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize:
                                                  Responsive.isDesktop(context)
                                                      ? 20
                                                      : 16,
                                              color: onyxBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Invitation Created By',
                                style: TextStyle(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 18 : 14,
                                  fontWeight: FontWeight.w700,
                                  color: eerieBlack,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                '$employeeName',
                                style: TextStyle(
                                  fontSize:
                                      Responsive.isDesktop(context) ? 20 : 16,
                                  fontWeight: FontWeight.w300,
                                  color: onyxBlack,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Visitor List',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: Responsive.isDesktop(context)
                                          ? 18
                                          : 14,
                                      color: eerieBlack,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(AddVisitorOverlay(
                                        inviteCode: eventID,
                                        visitDate: visitDate,
                                      ))
                                          .then((_) {
                                        getInvitationDetail(eventID!)
                                            .then((value) {
                                          setState(
                                            () {
                                              isLoading = false;
                                              // print('value ->' +
                                              //     value['Visitors']
                                              //         .toString());
                                              visitorList = value['Visitors'];
                                              totalPerson = visitorList!.length
                                                  .toString();
                                            },
                                          );
                                        });
                                      });
                                    },
                                    child: Text(
                                      'Add Visitor',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 18
                                                  : 14,
                                          color: eerieBlack),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  // Navigator.of(context)
                                  //     .push(AddVisitorOverlay());
                                  //   },
                                  //   child: Text(
                                  //     'Add Visitor',
                                  // style: TextStyle(
                                  //   fontWeight: FontWeight.w300,
                                  //   fontSize: 20,
                                  // ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Responsive.isDesktop(context) ? 15 : 10,
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: visitorList!.length,
                              itemBuilder: (context, index) {
                                return listVisitorDetailDialog(
                                  isHover!,
                                  visitorList![index]['VisitorName'],
                                  visitorList![index]['Email'],
                                  visitorList![index]['Status'],
                                  visitorList![index]['VisitorID'],
                                  index,
                                  visitorList!.length,
                                );
                              },
                            ),
                            Padding(
                              padding: Responsive.isDesktop(context)
                                  ? EdgeInsets.only(top: 50)
                                  : EdgeInsets.only(top: 20),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Responsive.isDesktop(context)
                                          ? 50
                                          : 40,
                                      width: Responsive.isDesktop(context)
                                          ? 250
                                          : null,
                                      child: CustTextButon(
                                        fontSize: Responsive.isDesktop(context)
                                            ? 20
                                            : 16,
                                        label: 'Change Visit Time',
                                        onTap: () {
                                          // changeVisitDialog(context)
                                          //     .then((value) {});
                                          Navigator.of(context)
                                              .push(ChangeVisitDialog(
                                                  eventID: eventID))
                                              .then(
                                            (value) {
                                              getInvitationDetail(eventID!)
                                                  .then((value) {
                                                // print(value);
                                                setState(() {
                                                  visitDate =
                                                      value['VisitTime'];
                                                  isLoading = false;
                                                });
                                              });
                                            },
                                          );
                                          // Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: cancelButtonLoading!
                                          ? CircularProgressIndicator(
                                              color: eerieBlack,
                                            )
                                          : SizedBox(
                                              height:
                                                  Responsive.isDesktop(context)
                                                      ? 50
                                                      : 40,
                                              width:
                                                  Responsive.isDesktop(context)
                                                      ? 250
                                                      : null,
                                              child: CustTextButon(
                                                fontSize: Responsive.isDesktop(
                                                        context)
                                                    ? 20
                                                    : 16,
                                                label: 'Cancel Invitation',
                                                onTap: () {
                                                  setState(
                                                    () {},
                                                  );
                                                  cancelButtonLoading = true;
                                                  showConfirmDialog(context);
                                                },
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 30,
                                      ),
                                      child: SizedBox(
                                        height: Responsive.isDesktop(context)
                                            ? 50
                                            : 40,
                                        width: Responsive.isDesktop(context)
                                            ? null
                                            : null,
                                        child: RegularButton(
                                          sizeFont:
                                              Responsive.isDesktop(context)
                                                  ? 20
                                                  : 16,
                                          title: 'Confirm',
                                          onTap: () {
                                            Navigator.of(context).pop(false);
                                            // Navigator.pushReplacementNamed(
                                            //     context, routeInvite);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Container(
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
