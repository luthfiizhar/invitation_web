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
import 'package:navigation_example/myinvite_source.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/change_visit_time_dialog.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/interactive_myinvite_menu_item.dart';
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
  var _rowsPerPage = AdvancedPaginatedDataTable.defaultRowsPerPage;
  final _source = ExampleSource();
  var _sortIndex = 0;
  var _sortAsc = true;
  final _searchController = TextEditingController();
  var _customFooter = false;
  List myInviteMenu = [
    {"id": 1, "menu": "Active Invitation"},
    {"id": 2, "menu": "Past Invitation"},
    {"id": 3, "menu": "Canceled"},
  ];
  int selectedMenu = 1;

  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "id": index,
            "title": "Item $index",
            "price": Random().nextInt(10000),
          });

  var _rowPerPages = 5;
  List<int> _rowPerPageList = [5, 10, 25, 50, 100];

  List<dynamic> contohData = [
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "3",
    //   "EmployeeName": "Dua Lima",
    //   "VisitTime": "12 Jul - 15 Jul 2022",
    //   "Visitors": [
    //     {
    //       "VisitorID": "VT-10",
    //       "VisitorName": "Ayana Dunne",
    //       "Email": "ayanna@gmail.com",
    //       "Status": "CHECKED IN"
    //     },
    //     {
    //       "VisitorID": "VT-11",
    //       "VisitorName": "Sion Goulding",
    //       "Email": "sion@gmail.com",
    //       "Status": "APPROVED"
    //     },
    //     {
    //       "VisitorID": "VT-9",
    //       "VisitorName": "Jacques Sierra",
    //       "Email": "jacques@gmail.com",
    //       "Status": "CHECKED IN"
    //     }
    //   ]
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "EmployeeName": "Dua Lima",
    //   "VisitTime": "21 Jul - 21 Jul 2022",
    //   "Visitors": [
    //     {
    //       "VisitorID": "VT-10",
    //       "VisitorName": "Ayana Dunne",
    //       "Email": "ayanna@gmail.com",
    //       "Status": "CHECKED IN"
    //     },
    //   ]
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-2",
    //   "InvitationID": "53MI00",
    //   "TotalVisitor": "1",
    //   "VisitTime": "21 Jul - 21 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
    // {
    //   "EventID": "EV-1",
    //   "InvitationID": "8Z7E4S",
    //   "TotalVisitor": "2",
    //   "VisitTime": "12 Jul - 15 Jul 2022"
    // },
  ];

  dynamic data;

  Future getActiveInvitations() async {
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
      setState(() {
        contohData = data['Data']['Invitations'];
      });
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActiveInvitations();
    // _rowPerPages = contohData.length;
    // _rowPerPageList.add(_rowPerPages);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? desktopLayoutMyInvitePage(context)
        : mobileLayoutMyInvitePage(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          NavigationBarWeb(
            index: 1,
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 300, right: 300),
            child: Container(
              // color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // color: Colors.blue,
                    padding: EdgeInsets.only(left: 350),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'My Invitation',
                              style: TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'All of your booking listing can be found here.',
                                style: pageSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Container(
                          width: 600,
                          height: 60,
                          // color: Colors.blue,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: myInviteMenu.length,
                            itemBuilder: (context, index) {
                              var menuName = myInviteMenu[index]['menu'];
                              var selected = myInviteMenu[index]['id'];
                              return MyInviteMenu(
                                menuName: menuName,
                                selected: selectedMenu == selected,
                                onHighlight: onHighlight,
                                index: index + 1,
                              );
                            },
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
                      padding: EdgeInsets.only(top: 40),
                      child: Container(
                        // height: 600,
                        width: 1000,
                        // color: Colors.black,
                        child: Builder(
                          builder: (context) {
                            if (selectedMenu == 1) {
                              return activeInvitation(contohData);
                            }
                            if (selectedMenu == 2) {
                              return serverSideTable();
                            }
                            if (selectedMenu == 3) {
                              return Text('Canceled');
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FooterInviteWeb(),
        ],
      ),
    );
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
                padding: EdgeInsets.only(top: 30, left: 300, right: 300),
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
                                          fontSize: 48,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text(
                                        'All of your booking listing can be found here.',
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
                            padding: EdgeInsets.only(top: 40),
                            child: Container(
                              width: 600,
                              height: 60,
                              // color: Colors.blue,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: myInviteMenu.length,
                                itemBuilder: (context, index) {
                                  var menuName = myInviteMenu[index]['menu'];
                                  var selected = myInviteMenu[index]['id'];
                                  return MyInviteMenu(
                                    menuName: menuName,
                                    selected: selectedMenu == selected,
                                    onHighlight: onHighlight,
                                    index: index + 1,
                                  );
                                },
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
                          padding: EdgeInsets.only(top: 40),
                          child: Container(
                            // height: 600,
                            width: 1000,
                            // color: Colors.black,
                            child: Builder(
                              builder: (context) {
                                if (selectedMenu == 1) {
                                  return activeInvitation(contohData);
                                }
                                if (selectedMenu == 2) {
                                  return serverSideTable();
                                }
                                if (selectedMenu == 3) {
                                  return Text('Canceled');
                                }
                                return SizedBox();
                              },
                            ),
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
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
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
                                          fontSize: 48,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text(
                                        'All of your booking listing can be found here.',
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
                            padding: EdgeInsets.only(top: 40),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 60,
                              // color: Colors.blue,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: myInviteMenu.length,
                                itemBuilder: (context, index) {
                                  var menuName = myInviteMenu[index]['menu'];
                                  var selected = myInviteMenu[index]['id'];
                                  return MyInviteMenu(
                                    menuName: menuName,
                                    selected: selectedMenu == selected,
                                    onHighlight: onHighlight,
                                    index: index + 1,
                                  );
                                },
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
                          padding: EdgeInsets.only(top: 40),
                          child: Container(
                            // height: 600,
                            width: 1000,
                            // color: Colors.black,
                            child: Builder(
                              builder: (context) {
                                if (selectedMenu == 1) {
                                  return activeInvitation(contohData);
                                }
                                if (selectedMenu == 2) {
                                  return serverSideTable();
                                }
                                if (selectedMenu == 3) {
                                  return Text('Canceled');
                                }
                                return SizedBox();
                              },
                            ),
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

  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> getField(d), int columnIndex, bool ascending) {
    contohData.sort();
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  Widget activeInvitation(List data) {
    final DataTableSource _data = MyInviteDataSource(dataSource: data);
    return Theme(
      data: ThemeData(
          dataTableTheme: DataTableThemeData(),
          fontFamily: 'Helvetica',
          cardColor: scaffoldBg,
          cardTheme: CardTheme(
            elevation: 0,
          )),
      child: PaginatedDataTable(
        // header: const Text('My Invitati'),

        columns: [
          DataColumn(
              label: Text(
            'Invitation ID',
            style: tableHeader,
          )),
          DataColumn(
              label: Text(
            'Visit Time',
            style: tableHeader,
          )),
          DataColumn(
              label: Text(
                'Total Visitor',
                style: tableHeader,
              ),
              onSort: (int columnIndex, bool ascending) {}),
          DataColumn(
            label: Text(''),
          ),
        ],
        source: _data,
        columnSpacing:
            Responsive.isDesktop(navKey.currentState!.context) ? 100 : 20,
        horizontalMargin: 10,
        rowsPerPage: _rowPerPages,
        onRowsPerPageChanged: (value) {
          setState(() {
            _rowPerPages = value!;
            print('changed');
          });
        },
        onPageChanged: (value) {
          print('value: $value');
        },
        availableRowsPerPage: _rowPerPageList,
        showCheckboxColumn: false,
      ),
    );
    // return DataTable(columns: [
    //   DataColumn(label: Text('Invitation ID')),
    //   DataColumn(label: Text('Visit Time')),
    //   DataColumn(label: Text('Total Visitor')),
    //   DataColumn(label: Text('')),
    // ], rows: [
    //   DataRow(cells: [
    //     DataCell(Text('1')),
    //     DataCell(Text('Arya')),
    //     DataCell(Text('6')),
    //     DataCell(Text('6')),
    //   ]),
    //   DataRow(cells: [
    //     DataCell(Text('12')),
    //     DataCell(Text('John')),
    //     DataCell(Text('9')),
    //     DataCell(Text('6')),
    //   ]),
    //   DataRow(cells: [
    //     DataCell(Text('42')),
    //     DataCell(Text('Tony')),
    //     DataCell(Text('8')),
    //     DataCell(Text('6')),
    //   ]),
    // ]);
  }

  void setSort(int i, bool asc) => setState(() {
        _sortIndex = i;
        _sortAsc = asc;
      });

  Widget serverSideTable() {
    return AdvancedPaginatedDataTable(
      addEmptyRows: false,
      source: _source,
      showHorizontalScrollbarAlways: true,
      sortAscending: _sortAsc,
      sortColumnIndex: _sortIndex,
      showFirstLastButtons: true,
      rowsPerPage: _rowsPerPage,
      availableRowsPerPage: const [5, 10],
      onRowsPerPageChanged: (newRowsPerPage) {
        if (newRowsPerPage != null) {
          setState(() {
            _rowsPerPage = newRowsPerPage;
          });
        }
      },
      columns: [
        DataColumn(
          label: const Text('ID'),
          // numeric: dalse,
          onSort: setSort,
        ),
        DataColumn(
          label: const Text('Company'),
          onSort: setSort,
        ),
        DataColumn(
          label: const Text('First name'),
          onSort: setSort,
        ),
        DataColumn(
          label: const Text('Last name'),
          onSort: setSort,
        ),
        // DataColumn(
        //   label: const Text('Phone'),
        //   onSort: setSort,
        // ),
      ],
      //Optianl override to support custom data row text / translation
      getFooterRowText:
          (startRow, pageSize, totalFilter, totalRowsWithoutFilter) {
        final localizations = MaterialLocalizations.of(context);
        var amountText = localizations.pageRowsInfoTitle(
          startRow,
          pageSize,
          totalFilter ?? totalRowsWithoutFilter,
          false,
        );

        if (totalFilter != null) {
          //Filtered data source show addtional information
          amountText += ' filtered from ($totalRowsWithoutFilter)';
        }

        return amountText;
      },
      customTableFooter: _customFooter
          ? (source, offset) {
              const maxPagesToShow = 6;
              const maxPagesBeforeCurrent = 3;
              final lastRequestDetails = source.lastDetails!;
              final rowsForPager = lastRequestDetails.filteredRows ??
                  lastRequestDetails.totalRows;
              final totalPages = rowsForPager ~/ _rowsPerPage;
              final currentPage = (offset ~/ _rowsPerPage) + 1;
              final List<int> pageList = [];
              if (currentPage > 1) {
                pageList.addAll(
                  List.generate(currentPage - 1, (index) => index + 1),
                );
                //Keep up to 3 pages before current in the list
                pageList.removeWhere(
                  (element) => element < currentPage - maxPagesBeforeCurrent,
                );
              }
              pageList.add(currentPage);
              //Add reminding pages after current to the list
              pageList.addAll(
                List.generate(
                  maxPagesToShow - (pageList.length - 1),
                  (index) => (currentPage + 1) + index,
                ),
              );
              pageList.removeWhere((element) => element > totalPages);

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: pageList
                    .map(
                      (e) => TextButton(
                        onPressed: e != currentPage
                            ? () {
                                //Start index is zero based
                                source.setNextView(
                                  startIndex: (e - 1) * _rowsPerPage,
                                );
                              }
                            : null,
                        child: Text(
                          e.toString(),
                        ),
                      ),
                    )
                    .toList(),
              );
            }
          : null,
    );
  }
}
