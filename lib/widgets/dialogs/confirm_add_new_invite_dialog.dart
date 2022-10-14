import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_example/widgets/text_button.dart';
import 'package:provider/provider.dart';

class AddNewInviteConfirmDialog extends ModalRoute<void> {
  AddNewInviteConfirmDialog({this.eventID, this.visitDate});
  String? eventID;
  String? visitorList;
  String? visitDate;
  List? list = [];
  bool isLoading = false;

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

  Future saveAddVisitor(String eventId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/visitor/add-new-visitor');

    var newList = json.encode(list);
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
    return data;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Consumer<MainModel>(builder: (context, model, child) {
      // print("main model ->" + model.listInvite);
      visitorList = model.listInvite;
      list = json.decode(visitorList.toString());

      return Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.all(15.0)
            : EdgeInsets.only(top: 15, bottom: 15),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Center(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: Responsive.isDesktop(context)
                    ? BorderRadius.circular(15)
                    : BorderRadius.circular(10),
                color: eerieBlack,
              ),
              width: 600,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Confirm Invitation',
                          style: TextStyle(
                              fontSize: Responsive.isDesktop(context) ? 36 : 24,
                              fontWeight: FontWeight.w700,
                              color: scaffoldBg),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Please confirm visitor data before send invitation.',
                          style: TextStyle(
                              fontSize: 20,
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
                                  fontWeight: FontWeight.w700,
                                  color: scaffoldBg),
                            ),
                            Text(
                              '$visitDate',
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
                                            top: 10, bottom: 10),
                                        child: Divider(
                                          thickness: 1,
                                          color: scaffoldBg,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 50, bottom: 30),
                        child: Responsive.isDesktop(context)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Responsive.isDesktop(
                                            navKey.currentState!.context)
                                        ? 220
                                        : null,
                                    height: Responsive.isDesktop(
                                            navKey.currentState!.context)
                                        ? 50
                                        : 40,
                                    child: CustTextButon(
                                      fontSize: Responsive.isDesktop(
                                              navKey.currentState!.context)
                                          ? 16
                                          : 14,
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
                                  isLoading
                                      ? CircularProgressIndicator(
                                          color: scaffoldBg,
                                        )
                                      : SizedBox(
                                          width: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 220
                                              : null,
                                          height: Responsive.isDesktop(
                                                  navKey.currentState!.context)
                                              ? 50
                                              : 40,
                                          child: RegularButton(
                                            title: 'Confirm',
                                            sizeFont: Responsive.isDesktop(
                                                    navKey
                                                        .currentState!.context)
                                                ? 16
                                                : 14,
                                            onTap: () {
                                              setState(
                                                () {
                                                  isLoading = true;
                                                },
                                              );
                                              showConfirmDialog(context)
                                                  .then((value) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
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
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: Responsive.isDesktop(
                                            navKey.currentState!.context)
                                        ? 100
                                        : null,
                                    height: Responsive.isDesktop(
                                            navKey.currentState!.context)
                                        ? 50
                                        : 40,
                                    child: RegularButton(
                                      title: 'Confirm',
                                      sizeFont: Responsive.isDesktop(
                                              navKey.currentState!.context)
                                          ? 16
                                          : 14,
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
                                  ),
                                  SizedBox(width: 20, height: 20),
                                  SizedBox(
                                    width: Responsive.isDesktop(
                                            navKey.currentState!.context)
                                        ? 100
                                        : null,
                                    height: Responsive.isDesktop(
                                            navKey.currentState!.context)
                                        ? 50
                                        : 40,
                                    child: CustTextButon(
                                      fontSize: Responsive.isDesktop(
                                              navKey.currentState!.context)
                                          ? 16
                                          : 14,
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
        no < 10 ? '0$no' : '$no',
        style: TextStyle(
          fontSize:
              Responsive.isDesktop(navKey.currentState!.context) ? 48 : 28,
          fontWeight: FontWeight.w700,
          color: scaffoldBg,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          '$firstName $lastName',
          style: TextStyle(
            fontSize:
                Responsive.isDesktop(navKey.currentState!.context) ? 24 : 16,
            fontWeight: FontWeight.w700,
            color: scaffoldBg,
          ),
        ),
      ),
      subtitle: Text(
        '$email',
        style: TextStyle(
          fontSize:
              Responsive.isDesktop(navKey.currentState!.context) ? 20 : 14,
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

  Future showConfirmDialog(BuildContext context) {
    return confirmDialog(context, 'Are you sure the data is correct?', true)
        .then((value) {
      if (value) {
        saveAddVisitor(eventID!).then((value) {
          print(value);
          setState(() {
            isLoading = false;
          });
          if (value['Status'] == '200') {
            Navigator.of(context)
                .push(NotifProcessDialog(
                    isSuccess: true, message: "Visitor has been invited!"))
                .then((value) => Navigator.of(context).pop());
          } else {
            Navigator.of(context)
                .push(NotifProcessDialog(
                    isSuccess: false, message: "Something wrong!"))
                .then((value) => Navigator.of(context).pop());
          }
          // Navigator.of(context).pop();
          // Navigator.pushReplacementNamed(
          //   context, routeInvite);
        });
      } else {
        clearVisitorData();
        print('cancel');
        isLoading = false;
        setState(() {});
      }
    });
  }
}
