import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
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

  Future saveInvitation() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print("List: " + list.toString());

    var newList = json.encode(list);
    print(newList);

    final url = Uri.http('192.168.186.4:8500', '/api/event/save-event');
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
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate([
          NavigationBarWeb(
            index: 0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 500, right: 500),
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Confirm Invitation',
                        style: pageTitle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Please confirm visitor data before send invitation.',
                        style: pageSubtitle,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Text(
                            'Visit Date: ',
                            style: pageSubtitle,
                          ),
                          Text(
                            '$startDate - $endDate',
                            style: pageSubtitle,
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
                            width: 200,
                            height: 60,
                            child: CustTextButon(
                              label: 'Cancel',
                              onTap: () {
                                setState(() {
                                  list!.clear();
                                });

                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 20, height: 60),
                          SizedBox(
                            width: 200,
                            height: 60,
                            child: RegularButton(
                              title: 'Confirm',
                              sizeFont: 20,
                              onTap: () {
                                // print('aaa');
                                confirmDialog(context,
                                        'Are you sure the data is correct?')
                                    .then((value) {
                                  if (value) {
                                    saveInvitation().then((value) {
                                      // Navigator.pushReplacementNamed(
                                      //   context, routeInvite);
                                    });
                                  } else {
                                    print('cancel');
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ]),
      ),
      SliverFillRemaining(
        hasScrollBody: false,
        child:
            Align(alignment: Alignment.bottomCenter, child: FooterInviteWeb()),
      )
    ]);
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

  Widget confirmList(int no, String firstName, String lastName, String email) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: Text(
        '$no',
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          '$firstName $lastName',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      subtitle: Text(
        '$email',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
      ),
    );
  }
}
