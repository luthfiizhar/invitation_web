import 'dart:convert';
import 'dart:math';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/advance_my_invite_source.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/constant/functions.dart';
import 'package:navigation_example/myinvite_source.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/change_visit_time_dialog.dart';
import 'package:navigation_example/widgets/dialogs/detail_visitor_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notification_dialog.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/interactive_myinvite_menu_item.dart';
import 'package:navigation_example/widgets/list_content_my_invitation.dart';
import 'package:navigation_example/widgets/myinvite_menu_item.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';
import 'package:http/http.dart' as http;

class MyInvitationPage extends StatefulWidget {
  const MyInvitationPage({Key? key}) : super(key: key);

  @override
  State<MyInvitationPage> createState() => _MyInvitationPageState();
}

class _MyInvitationPageState extends State<MyInvitationPage> {
  var _sortIndex = 0;
  var _sortAsc = true;

  List myInviteMenu = [
    {"id": 1, "menu": "Active Invitation"},
    {"id": 2, "menu": "Past Invitation"},
    {"id": 3, "menu": "Canceled"},
  ];
  List myInviteMenuMobile = [
    {"id": 1, "menu": "Active"},
    {"id": 2, "menu": "Past"},
    {"id": 3, "menu": "Canceled"},
  ];
  int selectedMenu = 1;

  bool nextButtonDisabled = true;
  bool prevButttonDisabled = true;
  bool sortById = false;
  bool sortByTime = false;
  bool sortByTotal = false;
  bool sortAscId = true;
  bool sortAscTime = true;
  bool sortAscTotal = true;
  bool sortAscTemp = true;
  String sortBy = "VisitTime";
  int myActiveInvitePage = 1;
  int rowPerPage = 10;

  bool isLoading = false;
  bool detailIsLoading = false;

  var _rowPerPages = 5;

  List visitors = [];
  List<dynamic> contohData = [];

  dynamic data;

  Future getActiveInvitations(
    String page,
    String maxPage,
    String sortBy,
    bool sortType,
    int sortMenu,
  ) async {
    var type = '';
    setState(() {
      isLoading = true;
      if (sortType) {
        type = "ASC";
      } else {
        type = "DESC";
      }
    });

    // print('hahahaha');
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(jwt);

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/invitation/invitation-list');
    final url_past = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/invitation/invitation-list-past');
    final url_cancel = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/invitation/invitation-list-cancel');

    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "Page" : "$page",
          "MaxPage" : "$maxPage",
          "SortBy" : "$sortBy",
          "SortDir" : "$type"
      }
    """;

    var response;
    if (sortMenu == 1) {
      response = await http.post(url, headers: requestHeader, body: bodySend);
    }
    if (sortMenu == 2) {
      response =
          await http.post(url_past, headers: requestHeader, body: bodySend);
    }
    if (sortMenu == 3) {
      response =
          await http.post(url_cancel, headers: requestHeader, body: bodySend);
    }
    var data = json.decode(response.body);
    print('data active : ' + data['Data'].toString());
    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      setState(() {
        contohData = data['Data']['Invitations'];
        if (data['Data']['LastPage'] == false) {
          nextButtonDisabled = false;
        } else {
          nextButtonDisabled = true;
        }
        if (int.parse(page) > 1) {
          prevButttonDisabled = false;
        } else {
          prevButttonDisabled = true;
        }
        if (sortBy == "InvitationID") {
          sortById = true;
          sortByTime = false;
          sortByTotal = false;
        }
        if (sortBy == "VisitTime") {
          sortByTime = true;
          sortById = false;
          sortByTotal = false;
        }
        if (sortBy == "TotalVisitor") {
          sortByTotal = true;
          sortById = false;
          sortByTime = false;
        }
        isLoading = false;
      });
    } else if (data['Status'] == '401') {
      Navigator.of(context)
          .push(
              NotifProcessDialog(isSuccess: false, message: "Something wrong!"))
          .then((value) {
        logout().then((value) {
          Navigator.pushReplacementNamed(
              navKey.currentState!.context, routeLogin);
        });
      });
    }
  }

  Future getInvitationDetail(String inviteCode) async {
    // print('hahaha');
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
        visitors = [data['Data']];
        // contohData = data['Data']['Invitations'];
      });
      return data['Data'];
    } else {}
  }

  void onHighlight(int menu) {
    switch (menu) {
      case 1:
        changeHighlight(1);
        break;
      case 2:
        changeHighlight(2);
        break;
      case 3:
        changeHighlight(3);
        break;
    }
  }

  void changeHighlight(int newIndex) {
    setState(() {
      selectedMenu = newIndex;
    });
    getActiveInvitations(
      myActiveInvitePage.toString(),
      rowPerPage.toString(),
      sortBy,
      _sortAsc,
      selectedMenu,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActiveInvitations(myActiveInvitePage.toString(), rowPerPage.toString(),
            sortBy, true, selectedMenu)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    // _rowPerPages = contohData.length;
    // _rowPerPageList.add(_rowPerPages);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? desktopLayoutMyInvitePage(context)
        : mobileLayoutMyInvitePage(context);
    // return SingleChildScrollView(
    //   scrollDirection: Axis.vertical,
    //   child: Column(
    //     children: [
    //       NavigationBarWeb(
    //         index: 1,
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(top: 30, left: 300, right: 300),
    //         child: Container(
    //           // color: Colors.blue,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 // color: Colors.blue,
    //                 padding: EdgeInsets.only(left: 350),
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           'My Invitation',
    //                           style: TextStyle(
    //                               fontSize: 48, fontWeight: FontWeight.w700),
    //                         ),
    //                       ],
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Padding(
    //                           padding: EdgeInsets.only(top: 20),
    //                           child: Text(
    //                             'All of your booking listing can be found here.',
    //                             style: pageSubtitle,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Padding(
    //                     padding: EdgeInsets.only(top: 40),
    //                     child: Container(
    //                       width: 600,
    //                       height: 60,
    //                       // color: Colors.blue,
    //                       child: ListView.builder(
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: myInviteMenu.length,
    //                         itemBuilder: (context, index) {
    //                           var menuName = myInviteMenu[index]['menu'];
    //                           var selected = myInviteMenu[index]['id'];
    //                           return MyInviteMenu(
    //                             menuName: menuName,
    //                             selected: selectedMenu == selected,
    //                             onHighlight: onHighlight,
    //                             index: index + 1,
    //                           );
    //                         },
    //                       ),
    //                       // child: Row(
    //                       //   children: [
    //                       //     MyInviteMenu(
    //                       //       menuName: 'Active Invitation',
    //                       //       onHighlight: onHighlight,
    //                       //       selected: selectedMenu == 1,
    //                       //       index: 1,
    //                       //     ),
    //                       //     MyInviteMenu(
    //                       //       menuName: 'Past Invitation',
    //                       //       onHighlight: onHighlight,
    //                       //       selected: selectedMenu == 2,
    //                       //       index: 2,
    //                       //     ),
    //                       //     MyInviteMenu(
    //                       //       menuName: 'Canceled',
    //                       //       onHighlight: onHighlight,
    //                       //       selected: selectedMenu == 3,
    //                       //       index: 3,
    //                       //     ),
    //                       // ],
    //                       // ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Center(
    //                 child: Padding(
    //                   padding: EdgeInsets.only(top: 40),
    //                   child: Container(
    //                     // height: 600,
    //                     width: 1000,
    //                     // color: Colors.black,
    //                     child: Builder(
    //                       builder: (context) {
    //                         if (selectedMenu == 1) {
    //                           return activeInvitation(contohData);
    //                         }
    //                         if (selectedMenu == 2) {
    //                           return serverSideTable();
    //                         }
    //                         if (selectedMenu == 3) {
    //                           return Text('Canceled');
    //                         }
    //                         return SizedBox();
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       FooterInviteWeb(),
    //     ],
    //   ),
    // );
  }

  Widget desktopLayoutMyInvitePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarWeb(
                index: 1,
              ),
              Padding(
                padding: Responsive.isBigDesktop(context)
                    ? EdgeInsets.only(top: 5, left: 300, right: 300)
                    : EdgeInsets.only(top: 5, left: 100, right: 100),
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.blue,
                        // padding: EdgeInsets.only(left: 350),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'My Invitation',
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'All of your invitation listing can be found here.',
                                        style: pageSubtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Container(
                              width: 600,
                              // height: 60,
                              // color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      MyInviteMenu(
                                        menuName: myInviteMenu[0]['menu'],
                                        selected: selectedMenu == 1,
                                        onHighlight: onHighlight,
                                        index: 1,
                                      ),
                                      MyInviteMenu(
                                        menuName: myInviteMenu[1]['menu'],
                                        selected: selectedMenu == 2,
                                        onHighlight: onHighlight,
                                        index: 2,
                                      ),
                                      MyInviteMenu(
                                        menuName: myInviteMenu[2]['menu'],
                                        selected: selectedMenu == 3,
                                        onHighlight: onHighlight,
                                        index: 3,
                                      ),
                                    ],
                                  ),
                                  // ListView.builder(
                                  //   scrollDirection: Axis.horizontal,
                                  //   itemCount: myInviteMenu.length,
                                  //   shrinkWrap: true,
                                  //   itemBuilder: (context, index) {
                                  //     var menuName =
                                  //         myInviteMenu[index]['menu'];
                                  //     var selected = myInviteMenu[index]['id'];
                                  //     return MyInviteMenu(
                                  //       menuName: menuName,
                                  //       selected: selectedMenu == selected,
                                  //       onHighlight: onHighlight,
                                  //       index: index + 1,
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                              // child: Row(
                              //   children: [
                              //     MyInviteMenu(
                              //       menuName: 'Active Invitation',
                              //       onHighlight: onHighlight,
                              //       selected: selectedMenu == 1,
                              //       index: 1,
                              //     ),
                              //     MyInviteMenu(
                              //       menuName: 'Past Invitation',
                              //       onHighlight: onHighlight,
                              //       selected: selectedMenu == 2,
                              //       index: 2,
                              //     ),
                              //     MyInviteMenu(
                              //       menuName: 'Canceled',
                              //       onHighlight: onHighlight,
                              //       selected: selectedMenu == 3,
                              //       index: 3,
                              //     ),
                              // ],
                              // ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Container(
                            // height: 600,
                            width: 1000,
                            // color: Colors.black,
                            child: activeInvitationListViewDesktop(
                                contohData, visitors, selectedMenu),
                            // child: Builder(
                            //   builder: (context) {
                            //     if (selectedMenu == 1) {
                            //       return activeInvitationListViewDesktop(
                            //           contohData, visitors);
                            //     }
                            //     if (selectedMenu == 2) {
                            //       return Text('past');
                            //     }
                            //     if (selectedMenu == 3) {
                            //       return Text('Canceled');
                            //     }
                            //     return SizedBox();
                            //   },
                            // ),
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
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
              alignment: Alignment.bottomCenter, child: FooterInviteWeb()),
        )
      ],
    );
  }

  Widget mobileLayoutMyInvitePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarMobile(),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.blue,
                        // padding: EdgeInsets.only(left: 350),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'My Invitation',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Wrap(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              alignment: WrapAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'All of your booking listing can be found here.',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.8,
                          // height: 60,
                          // color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyInviteMenuMobile(
                                menuName: myInviteMenuMobile[0]['menu'],
                                selected: selectedMenu == 1,
                                onHighlight: onHighlight,
                                index: 1,
                              ),
                              MyInviteMenuMobile(
                                menuName: myInviteMenuMobile[1]['menu'],
                                selected: selectedMenu == 2,
                                onHighlight: onHighlight,
                                index: 2,
                              ),
                              MyInviteMenuMobile(
                                menuName: myInviteMenuMobile[2]['menu'],
                                selected: selectedMenu == 3,
                                onHighlight: onHighlight,
                                index: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            // height: 600,
                            width: 1000,
                            child: activeInvitationListViewMobile(
                                contohData, visitors, selectedMenu),
                            // color: Colors.black,
                            // child: Builder(
                            //   builder: (context) {
                            //     if (selectedMenu == 1) {
                            //       return activeInvitationListViewMobile(
                            //           contohData, visitors);
                            //     }
                            //     if (selectedMenu == 2) {
                            //       return Text('past');
                            //     }
                            //     if (selectedMenu == 3) {
                            //       return Text('Canceled');
                            //     }
                            //     return SizedBox();
                            //   },
                            // ),
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
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
              alignment: Alignment.bottomCenter, child: FooterInviteWeb()),
        )
      ],
    );
  }

  Widget activeInvitationListViewDesktop(List data, List visitor, int menu) {
    return Container(
      padding: EdgeInsets.only(bottom: 50),
      width: 900,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    sortAscId ? sortAscId = false : sortAscId = true;
                    sortAscTemp = sortAscId;
                    sortBy = "InvitationID";
                    getActiveInvitations(
                      myActiveInvitePage.toString(),
                      rowPerPage.toString(),
                      sortBy,
                      sortAscTemp,
                      selectedMenu,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          'Invitation ID',
                          style: tableHeader,
                        ),
                        sortById
                            ? sortAscId
                                ? Icon(Icons.arrow_downward_sharp)
                                : Icon(Icons.arrow_upward_sharp)
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: InkWell(
                  onTap: () {
                    sortAscTime ? sortAscTime = false : sortAscTime = true;
                    sortBy = "VisitTime";
                    sortAscTemp = sortAscTime;
                    getActiveInvitations(
                      myActiveInvitePage.toString(),
                      rowPerPage.toString(),
                      sortBy,
                      sortAscTemp,
                      selectedMenu,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          'Visit Time',
                          style: tableHeader,
                        ),
                        sortByTime
                            ? sortAscTime
                                ? Icon(Icons.arrow_downward_sharp)
                                : Icon(Icons.arrow_upward_sharp)
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    // if (sortAscTotal = true) {
                    //   sortAscTotal = false;
                    // } else {
                    //   sortAscTotal == true;
                    // }
                    sortAscTotal ? sortAscTotal = false : sortAscTotal = true;
                    sortAscTemp = sortAscTotal;
                    // print(sortAscTotal);

                    sortBy = "TotalVisitor";
                    getActiveInvitations(
                      myActiveInvitePage.toString(),
                      rowPerPage.toString(),
                      sortBy,
                      sortAscTemp,
                      selectedMenu,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          'Total Visitor',
                          style: tableHeader,
                        ),
                        sortByTotal
                            ? sortAscTotal
                                ? Icon(Icons.arrow_downward_sharp)
                                : Icon(Icons.arrow_upward_sharp)
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '',
                    style: tableHeader,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Divider(
              thickness: 2,
              color: onyxBlack,
            ),
          ),
          !isLoading
              ? ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      // child: listContentDesktop(
                      //     data[index]['EventID'],
                      //     data[index]['InvitationID'],
                      //     data[index]['VisitTime'],
                      //     data[index]['TotalVisitor'].toString(),
                      //     visitor,
                      //     index),
                      child: ListItemMyInvititationDesktop(
                        eventId: data[index]['EventID'],
                        index: index,
                        inviteId: data[index]['InvitationID'],
                        totalVisitor: data[index]['TotalVisitor'].toString(),
                        visitTime: data[index]['VisitTime'],
                        visitor: visitor,
                        // getActiveInvite: getActiveInvitations(
                        //   myActiveInvitePage.toString(),
                        //   rowPerPage.toString(),
                        //   sortBy,
                        //   sortAscTemp,
                        //   selectedMenu,
                        // ),
                      ),
                    );
                  },
                )
              : CircularProgressIndicator(color: eerieBlack),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            child: Divider(
              thickness: 2,
              color: onyxBlack,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      'Showing: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        style: tableBody,
                        value: rowPerPage,
                        items: [
                          // DropdownMenuItem(
                          //   child: Text('5'),
                          //   value: 5,
                          // ),
                          DropdownMenuItem(
                            child: Text('10'),
                            value: 10,
                          ),
                          DropdownMenuItem(
                            child: Text('25'),
                            value: 25,
                          ),
                          DropdownMenuItem(
                            child: Text('50'),
                            value: 50,
                          ),
                          DropdownMenuItem(
                            child: Text('100'),
                            value: 100,
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            rowPerPage = value!;
                          });

                          getActiveInvitations(
                            myActiveInvitePage.toString(),
                            rowPerPage.toString(),
                            sortBy,
                            sortAscTemp,
                            selectedMenu,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onHover: (value) {},
                      onTap: !prevButttonDisabled
                          ? () {
                              myActiveInvitePage = myActiveInvitePage - 1;
                              getActiveInvitations(
                                myActiveInvitePage.toString(),
                                rowPerPage.toString(),
                                sortBy,
                                sortAscTemp,
                                selectedMenu,
                              );
                            }
                          : null,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Icon(
                              Icons.chevron_left,
                              size: 24,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Previous',
                              style: tableBody,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    InkWell(
                      onHover: (value) {},
                      onTap: !nextButtonDisabled
                          ? () {
                              setState(() {
                                myActiveInvitePage = myActiveInvitePage + 1;
                              });
                              getActiveInvitations(
                                myActiveInvitePage.toString(),
                                rowPerPage.toString(),
                                sortBy,
                                sortAscTemp,
                                selectedMenu,
                              ).then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                          : null,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Next',
                            style: tableBody,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Icon(
                              Icons.chevron_right,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget activeInvitationListViewMobile(List data, List visitor, int menu) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // width: 900,
      width: MediaQuery.of(navKey.currentState!.context).size.width * 0.8,
      child: Column(
        children: [
          ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    listContentMobile(
                        data[index]['EventID'],
                        data[index]['InvitationID'],
                        data[index]['VisitTime'],
                        data[index]['TotalVisitor'].toString(),
                        visitor,
                        index),
                    index != data.length - 1
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: spanishGray,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Showing: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          value: rowPerPage,
                          items: [
                            // DropdownMenuItem(
                            //   child: Text('5'),
                            //   value: 5,
                            // ),
                            DropdownMenuItem(
                              child: Text('10'),
                              value: 10,
                            ),
                            DropdownMenuItem(
                              child: Text('25'),
                              value: 25,
                            ),
                            DropdownMenuItem(
                              child: Text('50'),
                              value: 50,
                            ),
                            DropdownMenuItem(
                              child: Text('100'),
                              value: 100,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              rowPerPage = value!;
                            });

                            getActiveInvitations(
                              myActiveInvitePage.toString(),
                              rowPerPage.toString(),
                              sortBy,
                              sortAscTemp,
                              selectedMenu,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onHover: (value) {},
                        onTap: !prevButttonDisabled
                            ? () {
                                // setState(() {
                                myActiveInvitePage = myActiveInvitePage - 1;
                                // });
                                getActiveInvitations(
                                  myActiveInvitePage.toString(),
                                  rowPerPage.toString(),
                                  sortBy,
                                  sortAscTemp,
                                  selectedMenu,
                                ).then((value) {
                                  // setState(() {
                                  //   isLoading = false;
                                  // });
                                });
                              }
                            : null,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Icon(
                                Icons.chevron_left,
                                size: 16,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Prev',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onHover: (value) {},
                        onTap: !nextButtonDisabled
                            ? () {
                                myActiveInvitePage = myActiveInvitePage + 1;
                                // });
                                getActiveInvitations(
                                  myActiveInvitePage.toString(),
                                  rowPerPage.toString(),
                                  sortBy,
                                  sortAscTemp,
                                  selectedMenu,
                                ).then((value) {
                                  // setState(() {
                                  //   isLoading = false;
                                  // });
                                });
                              }
                            : null,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Icon(
                                Icons.chevron_right,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listContentDesktop(
    String eventId,
    String inviteId,
    String visitTime,
    String totalVisitor,
    List visitor,
    int index,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: index % 2 == 0 ? scaffoldBg : silver,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                inviteId,
                style: tableBodyCode,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                visitTime,
                style: tableBody,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                '$totalVisitor Person',
                style: tableBody,
              ),
            ),
          ),
          detailIsLoading
              ? CircularProgressIndicator(
                  color: eerieBlack,
                )
              : Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: CustTextButon(
                      label: 'Detail',
                      onTap: () {
                        setState(() {
                          detailIsLoading = true;
                        });
                        print(inviteId);
                        getInvitationDetail(eventId).then((value) {
                          // print('visitor -> ' + visitor.toString());
                          setState(() {
                            detailIsLoading = false;
                          });
                          dynamic listVisitor = value['Visitors'];
                          print('listVisitor - >' + listVisitor.toString());
                          Navigator.of(navKey.currentState!.overlay!.context)
                              .push(DetailVisitorOverlay(
                            visitorList: listVisitor,
                            eventID: eventId,
                            inviteCode: inviteId,
                            totalPerson: totalVisitor,
                            visitDate: visitTime,
                            employeeName: value['EmployeeName'],
                          ))
                              .then((value) {
                            setState(() {
                              getActiveInvitations(
                                myActiveInvitePage.toString(),
                                rowPerPage.toString(),
                                sortBy,
                                sortAscTemp,
                                selectedMenu,
                              ).then((value) {
                                isLoading = false;
                              });
                            });
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
  }

  Widget listContentMobile(
    String eventId,
    String inviteId,
    String visitTime,
    String totalVisitor,
    List visitor,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          detailIsLoading = true;
        });
        getInvitationDetail(eventId).then((value) {
          setState(() {});
          detailIsLoading = false;
          dynamic listVisitor = value['Visitors'];
          Navigator.of(navKey.currentState!.overlay!.context)
              .push(DetailVisitorOverlay(
            visitorList: listVisitor,
            inviteCode: inviteId,
            totalPerson: totalVisitor,
            visitDate: visitTime,
            employeeName: value['EmployeeName'],
          ));
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
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
                        inviteId,
                        style: tableBodyCode,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          visitTime,
                          style: tableBody,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '$totalVisitor Person',
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
          ],
        ),
      ),
    );
  }
}
