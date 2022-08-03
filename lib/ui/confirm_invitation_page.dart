import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';
import 'package:http/http.dart' as http;

class ConfirmInvitePage extends StatefulWidget {
  const ConfirmInvitePage({Key? key}) : super(key: key);

  @override
  State<ConfirmInvitePage> createState() => _ConfirmInvitePageState();
}

class _ConfirmInvitePageState extends State<ConfirmInvitePage> {
  bool isLoading = false;
  String? visitorList;
  String? startDate;
  String? endDate;
  List? list = [];

  bool isDark = true;
  Future getDataVisitor() async {
    var box = await Hive.openBox('inputvisitorBox');
    setState(() {
      visitorList = box.get('listInvite');
      startDate = box.get('startDate');
      endDate = box.get('endDate');
    });
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

    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/event/save-event');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "StartDate" : "$startDate",
          "EndDate" : "$endDate",
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
    return data['Status'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataVisitor().then((value) {
      // print(visitorList);
      setState(() {
        list = json.decode(visitorList.toString());
        print(list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Responsive.isDesktop(context) ? null : eerieBlack,
      child: CustomScrollView(slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Responsive.isDesktop(context)
                ? NavigationBarWeb(
                    index: 0,
                  )
                : NavigationBarMobile(
                    index: 0,
                  ),
            Responsive.isDesktop(context)
                ? desktopLayoutConfirmPage(context)
                : mobileLayoutConfirmPage(context),
          ]),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
              alignment: Alignment.bottomCenter, child: FooterInviteWeb()),
        )
      ]),
    );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       NavigationBarWeb(
    //         index: 0,
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(top: 20, left: 500, right: 500),
    //         child: Container(
    //           child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   child: Text(
    //                     'Confirm Invitation',
    //                     style: pageTitle,
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: 20),
    //                   child: Text(
    //                     'Please confirm visitor data before send invitation.',
    //                     style: pageSubtitle,
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: 30),
    //                   child: Row(
    //                     children: [
    //                       Text(
    //                         'Visit Date: ',
    //                         style: pageSubtitle,
    //                       ),
    //                       Text(
    //                         '$startDate - $endDate',
    //                         style: pageSubtitle,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 Container(
    //                   // color: Colors.blue,
    //                   // height: 450,
    //                   padding: EdgeInsets.only(top: 30),
    //                   child: ListView.builder(
    //                     shrinkWrap: true,
    //                     scrollDirection: Axis.vertical,
    //                     itemCount: list!.length,
    //                     itemBuilder: (context, index) {
    //                       var no = index + 1;
    //                       return Column(
    //                         children: [
    //                           confirmList(
    //                               no,
    //                               list![index]['FirstName'],
    //                               list![index]['LastName'],
    //                               list![index]['Email']),
    //                           index != list!.length - 1
    //                               ? Padding(
    //                                   padding: const EdgeInsets.only(
    //                                       top: 20, bottom: 20),
    //                                   child: Divider(
    //                                     thickness: 2,
    //                                     color: spanishGray,
    //                                   ),
    //                                 )
    //                               : SizedBox(),
    //                         ],
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: 50, bottom: 50),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       SizedBox(
    //                         width: 200,
    //                         height: 60,
    //                         child: CustTextButon(
    //                           label: 'Cancel',
    //                           onTap: () {
    //                             setState(() {
    //                               list!.clear();
    //                             });

    //                             Navigator.pop(context);
    //                           },
    //                         ),
    //                       ),
    //                       SizedBox(width: 20, height: 60),
    //                       SizedBox(
    //                         width: 200,
    //                         height: 60,
    //                         child: RegularButton(
    //                           title: 'Confirm',
    //                           sizeFont: 20,
    //                           onTap: () {
    //                             // print('aaa');
    //                             confirmDialog(context,
    //                                     'Are you sure the data is correct?')
    //                                 .then((value) {
    //                               if (value) {
    //                                 saveInvitation().then((value) {
    //                                   // Navigator.pushReplacementNamed(
    //                                   //   context, routeInvite);
    //                                 });
    //                               } else {
    //                                 print('cancel');
    //                               }
    //                             });
    //                           },
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ]),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  showConfirmDialog() {
    setState(() {
      isLoading = true;
    });
    return confirmDialog(context, 'Are you sure the data is correct?', true)
        .then((value) {
      if (value) {
        saveInvitation().then((value) {
          if (value == "200") {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context)
                .push(NotifProcessDialog(
                    isSuccess: true, message: "Visitors has been invited!"))
                .then((value) {
              Navigator.pushReplacementNamed(context, routeInvite);
            });
          } else {
            Navigator.of(context)
                .push(NotifProcessDialog(
                    isSuccess: false, message: "Something wrong!"))
                .then((value) {
              // Navigator.of(context).pop
            });
          }

          // Navigator.pushReplacementNamed(context, routeInvite);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // clearVisitorData();
        // print('cancel');
      }
    });
  }

  Widget desktopLayoutConfirmPage(BuildContext context) {
    return Padding(
      padding: Responsive.isBigDesktop(context)
          ? EdgeInsets.only(top: 5, left: 500, right: 500, bottom: 20)
          : EdgeInsets.only(top: 5, left: 350, right: 350, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: eerieBlack),
        child: Padding(
          padding: EdgeInsets.only(top: 40, bottom: 40, left: 70, right: 70),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: scaffoldBg),
                  ),
                  Text(
                    '$startDate - $endDate',
                    style: TextStyle(
                        fontSize: 22,
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
                      confirmList(no, list![index]['FirstName'],
                          list![index]['LastName'], list![index]['Email']),
                      index != list!.length - 1
                          ? Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
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
              padding: EdgeInsets.only(top: 50, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 225,
                    height: 60,
                    child: CustTextButon(
                      isDark: true,
                      label: 'Cancel',
                      onTap: () {
                        setState(() {
                          list!.clear();
                          clearVisitorData();
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  isLoading
                      ? CircularProgressIndicator(
                          color: scaffoldBg,
                        )
                      : SizedBox(
                          width: 225,
                          height: 60,
                          child: RegularButton(
                            title: 'Confirm',
                            sizeFont: 20,
                            onTap: () {
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
                              showConfirmDialog();
                            },
                            isDark: true,
                          ),
                        ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget mobileLayoutConfirmPage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: eerieBlack),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Confirm Invitation',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: scaffoldBg),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  'Please confirm visitor data before send invitation.',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: scaffoldBg),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Text(
                      'Visit Date: ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scaffoldBg),
                    ),
                    Text(
                      '$startDate - $endDate',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: scaffoldBg),
                    ),
                  ],
                ),
              ),
              Container(
                // color: Colors.blue,
                // height: 450,
                padding: EdgeInsets.only(top: 15),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: list!.length,
                  itemBuilder: (context, index) {
                    var no = index + 1;
                    return Column(
                      children: [
                        confirmList(no, list![index]['FirstName'],
                            list![index]['LastName'], list![index]['Email']),
                        index != list!.length - 1
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 7, bottom: 7),
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
                padding: EdgeInsets.only(top: 25, bottom: 0),
                child: Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isLoading
                          ? CircularProgressIndicator(
                              color: scaffoldBg,
                            )
                          : SizedBox(
                              // width: 250,
                              height: 35,
                              child: RegularButton(
                                title: 'Confirm',
                                sizeFont: 16,
                                onTap: () {
                                  showConfirmDialog();
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
                      SizedBox(width: 20, height: 10),
                      SizedBox(
                        // width: 250,
                        height: 35,
                        child: CustTextButon(
                          fontSize: 16,
                          isDark: true,
                          label: 'Cancel',
                          onTap: () {
                            setState(() {
                              list!.clear();
                              clearVisitorData();
                            });

                            Navigator.pop(context);
                          },
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
    );
  }

  Widget confirmList(int no, String firstName, String lastName, String email) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      horizontalTitleGap: Responsive.isDesktop(context) ? 25 : 5,
      leading: Container(
        padding: Responsive.isDesktop(context) ? null : EdgeInsets.only(top: 7),
        // color: Colors.blue,
        child: Text(
          no < 10 ? '0$no' : '$no',
          style: TextStyle(
            fontSize: Responsive.isDesktop(context) ? 48 : 28,
            fontWeight: FontWeight.w700,
            color: scaffoldBg,
          ),
        ),
      ),
      title: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.only(bottom: 10)
            : EdgeInsets.only(bottom: 5),
        child: Text(
          '$firstName $lastName',
          style: TextStyle(
            fontSize: Responsive.isDesktop(context) ? 28 : 16,
            fontWeight: FontWeight.w700,
            color: scaffoldBg,
          ),
        ),
      ),
      subtitle: Text(
        '$email',
        style: TextStyle(
          fontSize: Responsive.isDesktop(context) ? 20 : 14,
          fontWeight: FontWeight.w300,
          color: scaffoldBg,
        ),
      ),
    );
  }
}
