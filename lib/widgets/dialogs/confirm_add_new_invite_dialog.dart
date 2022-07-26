import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_example/widgets/text_button.dart';
import 'package:provider/provider.dart';

class AddNewInviteConfirmDialog extends ModalRoute<void> {
  AddNewInviteConfirmDialog({this.eventID});
  String? eventID;
  String? visitorList;
  String? startDate;
  String? endDate;
  List? list = [];

  Future getDataVisitor() async {
    var box = await Hive.openBox('inputvisitorBox');
    setState(() {
      visitorList = box.get('listInvite');
    });
  }

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => false;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

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

  Future saveAddVisitor(String eventId, String newList) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    final url = Uri.http(apiUrl, '/api/visitor/add-new-visitor');

    newList = json.encode(list);
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
        "EventID" : "$eventId",
        "Attendants" : $newList
    }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data);
    // if (data['Status'] == '200') {
    // } else {}
    return data['Status'];
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Consumer<MainModel>(builder: (context, model, child) {
      // print("main model ->" + model.listInvite);
      visitorList = model.listInvite;
      list = json.decode(visitorList.toString());
      return Padding(
        padding: const EdgeInsets.all(15),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: eerieBlack,
              ),
              width: 700,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Confirm Invitation',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: scaffoldBg),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Please confirm visitor data before send invitation.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: scaffoldBg),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Text(
                              'Visit Date: ',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: scaffoldBg),
                            ),
                            Text(
                              '$startDate - $endDate',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: scaffoldBg),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.blue,
                        // height: 450,
                        padding: EdgeInsets.only(top: 30),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: list!.length,
                          itemBuilder: (context, index) {
                            var no = index + 1;
                            return Column(
                              children: [
                                confirmList(
                                    no,
                                    list![index]['FirstName'],
                                    list![index]['LastName'],
                                    list![index]['Email']),
                                index != list!.length - 1
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 20),
                                        child: Divider(
                                          thickness: 2,
                                          color: spanishGray,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 50, bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 60,
                              child: CustTextButon(
                                fontSize: 16,
                                isDark: true,
                                label: 'Cancel',
                                onTap: () {
                                  // setState(() {
                                  // list!.clear();
                                  // model.listInvite = "";
                                  // clearVisitorData();
                                  // });

                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ),
                            SizedBox(width: 20, height: 60),
                            SizedBox(
                              width: 100,
                              height: 60,
                              child: RegularButton(
                                title: 'Confirm',
                                sizeFont: 16,
                                onTap: () {
                                  showConfirmDialog(context);
                                  // print('aaa');
                                  // confirmDialog(context,
                                  //         'Are you sure the data is correct?', true)
                                  //     .then((value) {
                                  //   if (value) {
                                  //     saveInvitation().then((value) {
                                  //       // Navigator.pushReplacementNamed(
                                  //       //   context, routeInvite);
                                  //     });
                                  //   } else {
                                  //     print('cancel');
                                  //   }
                                  // });
                                },
                                isDark: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          },
        ),
      );
    });
  }

  Widget confirmList(int no, String firstName, String lastName, String email) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: Text(
        '$no',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: scaffoldBg,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          '$firstName $lastName',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: scaffoldBg,
          ),
        ),
      ),
      subtitle: Text(
        '$email',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: scaffoldBg,
        ),
      ),
    );
  }

  Future clearVisitorData() async {
    var box = await Hive.openBox('inputvisitorBox');
    box.delete('listInvite');
    print('deleted');
  }

  Future saveInvitation() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print("List: " + list.toString());

    var newList = json.encode(list);
    print(newList);

    final url = Uri.http(apiUrl, '/api/event/save-event');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "StartDate" : "15 July 2022",
          "EndDate" : "15 July 2022",
          "Attendants" : $newList
      }
    """;

    print(bodySend);

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data);

    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      setState(() {
        // contohData = data['Data']['Invitations'];
      });
    } else {}
  }

  showConfirmDialog(BuildContext context) {
    return confirmDialog(context, 'Are you sure the data is correct?', true)
        .then((value) {
      if (value) {
        saveAddVisitor(eventID!, "").then((value) {
          print(value);
          Navigator.of(context).pop();
          // Navigator.pushReplacementNamed(
          //   context, routeInvite);
        });
      } else {
        clearVisitorData();
        print('cancel');
      }
    });
  }
}
