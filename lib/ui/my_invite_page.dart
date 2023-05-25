import 'dart:convert';
import 'dart:math';

// import 'package:advanced_datatable/advanced_datatable_source.dart';
// import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/advance_my_invite_source.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/constant/functions.dart';
import 'package:navigation_example/constant/text_style.dart';
import 'package:navigation_example/model/search_term.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/change_visit_time_dialog.dart';
import 'package:navigation_example/widgets/dialogs/detail_visitor_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notification_dialog.dart';
import 'package:navigation_example/widgets/dropdown.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/interactive_myinvite_menu_item.dart';
import 'package:navigation_example/widgets/layout_page.dart';
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
  FocusNode showPerRowsNode = FocusNode();
  var _sortIndex = 0;
  var _sortAsc = true;

  SearchTerm searchTerm = SearchTerm(
    orderBy: "VisitTime",
    orderDir: "ASC",
  );
  List myInviteMenu = [
    {"id": 1, "menu": "Active Invite", "value": "Active"},
    {"id": 2, "menu": "Past Invite", "value": "Past"},
    {"id": 3, "menu": "Canceled", "value": "Canceled"},
  ];
  List myInviteMenuMobile = [
    {"id": 1, "menu": "Active Invite", "value": "Active"},
    {"id": 2, "menu": "Past Invite", "value": "Past"},
    {"id": 3, "menu": "Canceled", "value": "Canceled"},
  ];
  int selectedMenu = 1;
  String selectedMenuString = "Active";

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
  // int rowPerPage = 10;

  bool isLoading = false;
  bool detailIsLoading = false;

  // var _rowPerPages = 5;

  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  List visitors = [];
  List<dynamic> contohData = [];

  dynamic data;

  onTapHeader(String orderBy) {
    searchTerm.orderBy = orderBy;
    if (searchTerm.orderDir == "ASC") {
      searchTerm.orderDir = "DESC";
    } else {
      searchTerm.orderDir = "ASC";
    }
  }

  changeTab(int menu, String type) {
    currentPaginatedPage = 1;
    searchTerm.formType = type;
    searchTerm.pageNumber = currentPaginatedPage.toString();
    selectedMenu = menu;
    selectedMenuString = type;
    getActiveInvitations(searchTerm.pageNumber, searchTerm.max,
            searchTerm.orderBy, true, menu)
        .then((value) {
      setState(() {});
    });
  }

  countPagination(int totalRow) {
    setState(() {
      availablePage.clear();
      if (totalRow == 0) {
        currentPaginatedPage = 1;
        showedPage = [1];
        availablePage = [1];
      }
      var totalPage = totalRow / int.parse(searchTerm.max);
      for (var i = 0; i < totalPage.ceil(); i++) {
        availablePage.add(i + 1);
      }
      showedPage = availablePage.take(5).toList();
    });
  }

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
          "Page" : "${searchTerm.pageNumber}",
          "MaxPage" : "${searchTerm.max}",
          "SortBy" : "${searchTerm.orderBy}",
          "SortDir" : "${searchTerm.orderDir}"
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
        resultRows = data['Data']['TotalData'];
        // if (data['Data']['LastPage'] == false) {
        //   nextButtonDisabled = false;
        // } else {
        //   nextButtonDisabled = true;
        // }
        // if (int.parse(page) > 1) {
        //   prevButttonDisabled = false;
        // } else {
        //   prevButttonDisabled = true;
        // }
        // if (sortBy == "InvitationID") {
        //   sortById = true;
        //   sortByTime = false;
        //   sortByTotal = false;
        // }
        // if (sortBy == "VisitTime") {
        //   sortByTime = true;
        //   sortById = false;
        //   sortByTotal = false;
        // }
        // if (sortBy == "TotalVisitor") {
        //   sortByTotal = true;
        //   sortById = false;
        //   sortByTime = false;
        // }
        isLoading = false;
      });
    } else if (data['Status'] == '401') {
      // Navigator.of(context)
      //     .push(NotifProcessDialog(isSuccess: false, message: data['Message']))
      //     .then((value) {
      //   logout().then((value) {
      //     // Navigator.pushReplacementNamed(
      //     //     navKey.currentState!.context, routeLogin);
      //   });
      // });
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
    print(data);
    // final response = await http.get(requestUri);
    if (data['Status'] == '200') {
      setState(() {
        visitors = [data['Data']];
        // contohData = data['Data']['Invitations'];
      });
      return data;
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

  void changeHighlight(
    int newIndex,
  ) {
    setState(() {
      selectedMenu = newIndex;
      selectedMenuString = myInviteMenu
          .where((element) => element['id'] == newIndex)
          .toList()
          .first['value']
          .toString();
      myActiveInvitePage = 1;
      currentPaginatedPage = 1;
      searchTerm.pageNumber = currentPaginatedPage.toString();
    });
    getActiveInvitations(
      myActiveInvitePage.toString(),
      rowPerPage.toString(),
      sortBy,
      _sortAsc,
      selectedMenu,
    ).then((value) {
      countPagination(resultRows);
    });
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
    return LayoutPageWeb(
      index: 1,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 850,
            maxWidth: 850,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'My Invitation',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'All of your invitation listing can be found here.',
                style: helveticaText.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: onyxBlack,
                ),
              ),
              FilterSearchBarMyInvite(
                typeList: myInviteMenu,
                updateList: changeTab,
                type: selectedMenuString,
                selectedMenu: selectedMenu,
              ),
              const SizedBox(
                height: 30,
              ),
              activeInvitationListViewDesktop(
                contohData,
                visitors,
                selectedMenu,
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mobileLayoutMyInvitePage(BuildContext context) {
    return LayoutPageMobile(
      index: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
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
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      alignment: WrapAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'All of your booking listing can be found here.',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: onyxBlack),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FilterSearchBarMyInvite(
                typeList: myInviteMenuMobile,
                updateList: changeTab,
                type: selectedMenuString,
                selectedMenu: selectedMenu,
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 15),
              //   child: Container(
              //     // width: MediaQuery.of(context).size.width * 0.8,
              //     // height: 60,
              //     // color: Colors.blue,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         MyInviteMenuMobile(
              //           menuName: myInviteMenuMobile[0]['menu'],
              //           selected: selectedMenu == 1,
              //           onHighlight: onHighlight,
              //           index: 1,
              //         ),
              //         MyInviteMenuMobile(
              //           menuName: myInviteMenuMobile[1]['menu'],
              //           selected: selectedMenu == 2,
              //           onHighlight: onHighlight,
              //           index: 2,
              //         ),
              //         MyInviteMenuMobile(
              //           menuName: myInviteMenuMobile[2]['menu'],
              //           selected: selectedMenu == 3,
              //           onHighlight: onHighlight,
              //           index: 3,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    // height: 600,
                    width: double.infinity,
                    child: activeInvitationListViewMobile(
                        contohData, visitors, selectedMenu, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget activeInvitationListViewDesktop(
      List data, List visitor, int menu, BuildContext context) {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
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
                    onTapHeader("InvitationID");
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Invitation ID',
                          style: tableHeader,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 1,
                          children: [
                            !sortById
                                ? const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 16,
                                  )
                                : sortAscId
                                    ? const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                            !sortById
                                ? const Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    size: 16,
                                  )
                                : !sortAscId
                                    ? const Icon(
                                        Icons.keyboard_arrow_up_sharp,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                          ],
                        ),
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
                    onTapHeader("VisitTime");
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Visit Time',
                          style: tableHeader,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 1,
                          children: [
                            searchTerm.orderBy != "VisitTime"
                                ? const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 16,
                                  )
                                : searchTerm.orderDir == "ASC"
                                    ? const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                            searchTerm.orderBy != "VisitTime"
                                ? const Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    size: 16,
                                  )
                                : searchTerm.orderDir != "ASC"
                                    ? const Icon(
                                        Icons.keyboard_arrow_up_sharp,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                          ],
                        ),
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
                    onTapHeader("TotalVisitor");
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Visitor',
                          style: tableHeader,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 1,
                          children: [
                            !sortByTotal
                                ? const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 16,
                                  )
                                : sortAscTotal
                                    ? const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                            !sortByTotal
                                ? const Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    size: 16,
                                  )
                                : !sortAscTotal
                                    ? const Icon(
                                        Icons.keyboard_arrow_up_sharp,
                                        size: 16,
                                      )
                                    : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: InkWell(
                    child: Text(''),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 0,
              bottom: 20,
            ),
            child: Divider(
              thickness: 1,
              color: davysGray,
            ),
          ),
          !isLoading
              ? data.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Invitation data not found',
                        style: tableBody,
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: listContentDesktop(
                              data[index]['EventID'],
                              data[index]['InvitationID'],
                              data[index]['VisitTime'],
                              data[index]['TotalVisitor'].toString(),
                              visitor,
                              index),
                        );
                      },
                    )
              : const CircularProgressIndicator(color: eerieBlack),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 0),
            child: Divider(
              thickness: 1,
              color: davysGray,
            ),
          ),
          //PAGINATION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.amber,
                width: 220,
                child: Row(
                  children: [
                    Text(
                      'Show:',
                      style: helveticaText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 120,
                      child: BlackDropdown(
                        focusNode: showPerRowsNode,
                        onChanged: (value) {
                          setState(() {
                            currentPaginatedPage = 1;
                            searchTerm.pageNumber = "1";
                            searchTerm.max = value!.toString();
                            getActiveInvitations(
                                    myActiveInvitePage.toString(),
                                    rowPerPage.toString(),
                                    sortBy,
                                    sortAscTemp,
                                    selectedMenu)
                                .then((value) {
                              countPagination(resultRows);
                            });
                          });
                        },
                        value: searchTerm.max,
                        items: showPerPageList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: helveticaText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: eerieBlack,
                              ),
                            ),
                          );
                        }).toList(),
                        enabled: true,
                        hintText: 'Choose',
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: eerieBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    InkWell(
                      onTap: currentPaginatedPage - 1 > 0
                          ? () {
                              setState(() {
                                currentPaginatedPage = currentPaginatedPage - 1;
                                if (availablePage.length > 5 &&
                                    currentPaginatedPage == showedPage[0] &&
                                    currentPaginatedPage != 1) {
                                  showedPage.removeLast();
                                  showedPage.insert(
                                      0, currentPaginatedPage - 1);
                                }
                                searchTerm.pageNumber =
                                    currentPaginatedPage.toString();
                              });
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.chevron_left_sharp,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: paginationWidth, //275,
                      height: 35,
                      child: Row(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: showedPage.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: InkWell(
                                  onTap: currentPaginatedPage ==
                                          showedPage[index]
                                      ? null
                                      : () {
                                          setState(() {
                                            currentPaginatedPage =
                                                showedPage[index];
                                            if (availablePage.length > 5 &&
                                                index ==
                                                    showedPage.length - 1) {
                                              if (currentPaginatedPage !=
                                                  availablePage.last) {
                                                showedPage.removeAt(0);
                                                showedPage.add(
                                                    currentPaginatedPage + 1);
                                              }
                                            }
                                            if (availablePage.length > 5 &&
                                                index == 0 &&
                                                currentPaginatedPage != 1) {
                                              showedPage.removeLast();
                                              showedPage.insert(
                                                  0, currentPaginatedPage - 1);
                                            }
                                          });
                                          searchTerm.pageNumber =
                                              currentPaginatedPage.toString();
                                        },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 8.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: showedPage[index] ==
                                              currentPaginatedPage
                                          ? eerieBlack
                                          : null,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        showedPage[index].toString(),
                                        style: helveticaText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                          color: showedPage[index] ==
                                                  currentPaginatedPage
                                              ? culturedWhite
                                              : davysGray,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: availablePage.length <= 5 ||
                                    currentPaginatedPage == availablePage.last
                                ? false
                                : true,
                            child: Container(
                              width: 35,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 8.5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '...',
                                  style: helveticaText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color: davysGray,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: currentPaginatedPage != availablePage.last
                          ? () {
                              setState(() {
                                currentPaginatedPage = currentPaginatedPage + 1;
                                if (currentPaginatedPage == showedPage.last &&
                                    currentPaginatedPage !=
                                        availablePage.last) {
                                  showedPage.removeAt(0);
                                  showedPage.add(currentPaginatedPage + 1);
                                }
                                searchTerm.pageNumber =
                                    currentPaginatedPage.toString();
                              });
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.chevron_right_sharp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget activeInvitationListViewMobile(
      List data, List visitor, int menu, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // width: 900,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 0),
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
                        ? const Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Divider(
                              thickness: 1,
                              color: spanishGray,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // color: Colors.amber,
                  width: 220,
                  child: Row(
                    children: [
                      Text(
                        'Showing:',
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 120,
                        child: TransparentDropdown(
                          focusNode: showPerRowsNode,
                          onChanged: (value) {
                            setState(() {
                              currentPaginatedPage = 1;
                              searchTerm.pageNumber = "1";
                              searchTerm.max = value!.toString();
                              getActiveInvitations(
                                      myActiveInvitePage.toString(),
                                      rowPerPage.toString(),
                                      sortBy,
                                      sortAscTemp,
                                      selectedMenu)
                                  .then((value) {
                                countPagination(resultRows);
                              });
                            });
                          },
                          value: searchTerm.max,
                          items: showPerPageList.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: helveticaText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: eerieBlack,
                                ),
                              ),
                            );
                          }).toList(),
                          enabled: true,
                          hintText: 'Choose',
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: eerieBlack,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onHover: (value) {},
                            onTap: !prevButttonDisabled
                                ? () {
                                    // setState(() {
                                    currentPaginatedPage =
                                        currentPaginatedPage - 1;
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
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: [
                                const Icon(
                                  Icons.chevron_left,
                                  size: 16,
                                  color: onyxBlack,
                                ),
                                Text(
                                  'Prev',
                                  style: helveticaText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: onyxBlack),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onHover: (value) {},
                            onTap: !nextButtonDisabled
                                ? () {
                                    currentPaginatedPage =
                                        currentPaginatedPage + 1;
                                    myActiveInvitePage = myActiveInvitePage + 1;
                                    getActiveInvitations(
                                      myActiveInvitePage.toString(),
                                      rowPerPage.toString(),
                                      sortBy,
                                      sortAscTemp,
                                      selectedMenu,
                                    ).then((value) {});
                                  }
                                : null,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: helveticaText.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: onyxBlack,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 16,
                                  color: onyxBlack,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    return Column(
      children: [
        index == 0
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Divider(
                  thickness: 0.5,
                  color: davysGray,
                ),
              ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          onTap: () {
            setState(() {
              isLoading = true;
            });
            print(inviteId);
            getInvitationDetail(eventId).then((value) {
              // print('visitor -> ' + visitor.toString());
              setState(() {
                isLoading = false;
              });
              dynamic listVisitor = value['Data']['Visitors'];
              // print('listVisitor - >' + listVisitor.toString());
              Navigator.of(context)
                  .push(DetailVisitorOverlay(
                visitorList: listVisitor,
                eventID: eventId,
                inviteCode: inviteId,
                totalPerson: totalVisitor,
                visitDate: visitTime,
                employeeName: value['Data']['EmployeeName'],
                statusEvent: value['Data']['Status'],
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
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    inviteId,
                    style: tableBodyCode,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    visitTime,
                    style: tableBody,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    '$totalVisitor Person',
                    style: tableBody,
                  ),
                ),
              ),
              detailIsLoading
                  ? const CircularProgressIndicator(
                      color: eerieBlack,
                    )
                  : const Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.chevron_right_sharp,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
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
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        getInvitationDetail(eventId).then((value) {
          setState(() {});
          isLoading = false;
          dynamic listVisitor = value['Data']['Visitors'];
          Navigator.of(context)
              .push(DetailVisitorOverlay(
            eventID: eventId,
            visitorList: listVisitor,
            inviteCode: inviteId,
            totalPerson: totalVisitor,
            visitDate: visitTime,
            employeeName: value['Data']['EmployeeName'],
            statusEvent: value['Data']['Status'],
          ))
              .then((value) {
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
          });
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
          ],
        ),
      ),
    );
  }
}

class FilterSearchBarMyInvite extends StatefulWidget {
  FilterSearchBarMyInvite({
    super.key,
    this.type = "Active",
    this.typeList,
    this.updateList,
    this.search,
    this.searchController,
    this.selectedMenu = 0,
  });

  Function? updateList;
  Function? search;
  List? typeList;
  String? type;
  TextEditingController? searchController;
  int selectedMenu;

  @override
  State<FilterSearchBarMyInvite> createState() =>
      _FilterSearchBarMyInviteState();
}

class _FilterSearchBarMyInviteState extends State<FilterSearchBarMyInvite> {
  // ApiService apiService = ApiService();
  bool onSelected = false;
  String? documentType;
  TextEditingController? _search = TextEditingController();
  bool exportButtonVisible = false;

  List<Color> color = [blueAccent, greenAcent, orangeAccent, violetAccent];
  late int indexColor;
  late Color selectedColor = blueAccent;
  final _random = Random();

  int index = 1;

  void onHighlight(String type) {
    switch (type) {
      case "Active":
        changeHighlight("Active", 1);
        widget.selectedMenu = 1;
        widget.updateList!(1, "Active");
        break;
      case "Past":
        changeHighlight("Past", 2);
        widget.selectedMenu = 2;
        widget.updateList!(2, "Past");
        break;
      case "Canceled":
        changeHighlight("Canceled", 3);
        widget.selectedMenu = 3;
        widget.updateList!(3, "Canceled");
        break;
    }
  }

  void changeHighlight(String type, int newIndex) {
    setState(() {
      index = newIndex;
      documentType = type;
      widget.type = type;
    });
  }

  @override
  void initState() {
    super.initState();
    documentType = widget.type;
    indexColor = _random.nextInt(color.length);
    selectedColor = color[indexColor];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 61,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: grayx11,
                  width: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // bottom: 0,
            // left: 0,
            child: Container(
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // width: 500,
                    child: Wrap(
                      spacing: Responsive.isDesktop(context) ? 50 : 25,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: widget.typeList!.map((e) {
                        return FilterSearchBarMyInviteItem(
                          title: e['menu'],
                          type: e['value'],
                          bookingCount: "0",
                          onHighlight: onHighlight,
                          color: selectedColor,
                          selected: index == e['value'],
                        );
                      }).toList(),
                      // children: [
                      //   FilterSearchBarMyInviteItem(
                      //     title: 'Meeting Room',
                      //     type: 'MeetingRoom',
                      //     onHighlight: onHighlight,
                      //     selected: index == 0,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   FilterSearchBarMyInviteItem(
                      //     title: 'Auditorium',
                      //     type: 'Auditorium',
                      //     onHighlight: onHighlight,
                      //     selected: index == 1,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   FilterSearchBarMyInviteItem(
                      //     title: 'Social Hub',
                      //     type: 'SocialHub',
                      //     onHighlight: onHighlight,
                      //     selected: index == 2,
                      //     color: selectedColor,
                      //   ),
                      // ],
                    ),
                  ),

                  // Expanded(
                  //   child: Container(
                  //     //   child: WhiteInputField(
                  //     //     controller: _search!,
                  //     //     enabled: true,
                  //     //     obsecureText: false,
                  //     //   ),
                  //     child: Text('haha'),
                  //   ),
                  // ),

                  // BlackInputField(
                  //   controller: _search!,
                  //   enabled: true,
                  //   obsecureText: false,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSearchBarMyInviteItem extends StatelessWidget {
  const FilterSearchBarMyInviteItem({
    super.key,
    this.title,
    this.type,
    this.selected,
    this.onHighlight,
    this.color,
    this.bookingCount,
  });

  final String? title;
  final String? type;
  final bool? selected;
  final Function? onHighlight;
  final Color? color;
  final String? bookingCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: FilterSearchBarInteractiveText(
          text: title,
          selected: selected,
          color: color!,
          bookingCount: bookingCount!,
        ),
      ),
    );
  }
}

// class FilterSearchBarInteractiveItem extends MouseRegion {
//   static final appContainer =
//       html.window.document.querySelectorAll('flt-glass-pane')[0];

//   // bool selected;

//   FilterSearchBarInteractiveItem({
//     Widget? child,
//     String? text,
//     bool? selected,
//     String? type,
//     Color color = blueAccent,
//     String? bookingCount,
//   }) : super(
//           onHover: (PointerHoverEvent evt) {
//             appContainer.style.cursor = 'pointer';
//           },
//           onExit: (PointerExitEvent evt) {
//             appContainer.style.cursor = 'default';
//           },
//           child: FilterSearchBarInteractiveText(
//               text: text!,
//               selected: selected!,
//               color: color,
//               bookingCount: bookingCount),
//         );
// }

class FilterSearchBarInteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;
  final Color color;
  final String? bookingCount;

  FilterSearchBarInteractiveText(
      {@required this.text,
      this.selected,
      this.color = blueAccent,
      this.bookingCount});

  @override
  FilterSearchBarInteractiveTextState createState() =>
      FilterSearchBarInteractiveTextState();
}

class FilterSearchBarInteractiveTextState
    extends State<FilterSearchBarInteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide.none,
                right: BorderSide.none,
                top: BorderSide.none,
                bottom: _hovering
                    ? BorderSide(
                        color: widget.color,
                        width: 3,
                        style: BorderStyle.solid,
                      )
                    : (widget.selected!)
                        ? BorderSide(
                            color: widget.color,
                            width: 3,
                            style: BorderStyle.solid,
                          )
                        : BorderSide.none,
              ),
            ),
            child: Wrap(
              children: [
                Text(
                  widget.text!,
                  style: _hovering
                      ? filterSearchBarText.copyWith(
                          color: widget.color, //eerieBlack,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        )
                      : (widget.selected!)
                          ? filterSearchBarText.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            )
                          : filterSearchBarText.copyWith(
                              color: davysGray,
                              fontWeight: FontWeight.w300,
                              height: 1.3,
                            ),
                ),
                // widget.bookingCount == "0"
                //     ? SizedBox()
                //     : Padding(
                //         padding: const EdgeInsets.only(
                //           left: 10,
                //         ),
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(
                //             horizontal: 8,
                //             vertical: 5,
                //           ),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5),
                //             color: sonicSilver,
                //           ),
                //           child: Text(
                //             widget.bookingCount!,
                //             style: helveticaText.copyWith(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //               color: culturedWhite,
                //               height: 1.3,
                //             ),
                //           ),
                //         ),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
