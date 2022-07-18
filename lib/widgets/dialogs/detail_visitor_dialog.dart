import 'dart:math';

import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/add_visitor_dialog.dart';
import 'package:navigation_example/widgets/dialogs/change_visit_time_dialog.dart';
import 'package:navigation_example/widgets/dialogs/detail_info_visitor_dialog.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';

Future<bool> inviteDetailDialog(
  BuildContext context,
  List dataSource,
  String invitationId,
  String totalVisitor,
  String visitTime,
  String employeeName,
) async {
  bool isHover = false;
  String name = '';
  String email = '';
  String isVerified = '';
  bool shouldPop = true;
  print(dataSource);
  return await showDialog(
      barrierDismissible: false,
      context: navKey.currentState!.overlay!.context,
      builder: (context) => StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      icon: Icon(
                        Icons.close,
                        color: eerieBlack,
                      ),
                      label: Text(''),
                    ),
                  ],
                ),
                // title: Container(
                //   child: Stack(
                //     children: [
                //       Positioned(
                //         left: 50,
                //         top: 40,
                //         child: Text(
                //           'Invitation Detail',
                //           style: dialogTitle,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Invitation Detail',
                //       style: dialogTitle,
                //     ),
                //     Icon(Icons.close),
                //   ],
                // ),
                backgroundColor: scaffoldBg,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          'Invitation Detail',
                          style: dialogTitle,
                        ),
                      ),
                      Container(
                        width: 550,
                        child: Text(
                          'Invite Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '$invitationId',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      'Visit Time',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      '$visitTime',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      'Total Visitor',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      '$totalVisitor',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          'Visitor List',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 400,
                        width: 500,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: dataSource.length,
                          itemBuilder: (context, index) {
                            return listVisitorDetailDialog(
                              isHover,
                              dataSource[index]['VisitorName'],
                              dataSource[index]['Email'],
                              isVerified,
                              dataSource[index]['VisitorID'],
                              index,
                              dataSource.length,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Invitation Created By',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          '$employeeName',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 250,
                                child: CustTextButon(
                                  // sizeFont: 20,
                                  label: 'Change Visit Time',
                                  onTap: () {
                                    changeVisitDialog(context).then((value) {});
                                    // Navigator.of(context).pop(false);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  height: 50,
                                  width: 250,
                                  child: CustTextButon(
                                    // sizeFont: 20,
                                    label: 'Cancel',
                                    onTap: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  height: 50,
                                  width: 250,
                                  child: RegularButton(
                                    sizeFont: 20,
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
                      )
                    ],
                  ),
                ),
                // children: [
                //   Column(
                //     children: [
                //       Text(
                //         'Message here ....',
                //       ),
                //       SizedBox(
                //         height: 50,
                //         width: 250,
                //         child: RegularButton(
                //           title: 'Confirm',
                //           onTap: () {},
                //         ),
                //       )
                //     ],
                //   )
                // ],
              );
            },
          ));
}

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
              print('hover');
              // removeVisible = value;
              setState(() {
                isHover = value;
                print(removeVisible);
              });
            },
            onTap: () {
              Navigator.of(context).push(VisitorConfirmationOverlay());
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            '$email',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            verified == "APPROVED"
                                ? 'Visitor Verified'
                                : 'Visitor not yet Verified',
                            style: TextStyle(
                              fontSize: 20,
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
                    flex: 2,
                    child: Row(
                      children: [
                        // Icon(Icons.check),
                        verified == "APPROVED"
                            ? SizedBox(
                                width: 30,
                                child: ImageIcon(
                                  AssetImage('assets/icon_verified.png'),
                                ),
                              )
                            : SizedBox(
                                width: 30,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Visibility(
                            visible: isHover ? true : false,
                            child: GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    name = 'hahahaha';
                                  },
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
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: index == length - 1
              ? SizedBox()
              : Divider(
                  thickness: 2,
                  color: spanishGray,
                ),
        ),
      ],
    ),
  );
}

class DetailVisitorOverlay extends ModalRoute<void> {
  DetailVisitorOverlay(
      {this.visitorList,
      this.visitDate,
      this.employeeName,
      this.inviteCode,
      this.totalPerson});
  List? visitorList;
  String? visitDate;
  String? inviteCode;
  String? totalPerson;
  String? employeeName;
  bool? isHover = false;
  String? isVerified = 'AAA';
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
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Container(
              width: 550,
              // color: scaffoldBg,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: scaffoldBg,
              ),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              icon: Icon(
                                Icons.close,
                                color: eerieBlack,
                              ),
                              label: Text(''),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
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
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '$inviteCode',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.only(top: 30),
                                      child: Text(
                                        'Visit Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '$visitDate',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.only(top: 30),
                                      child: Text(
                                        'Total Visitor',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '$totalPerson Person',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Visitor List',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(AddVisitorOverlay(
                                      inviteCode: inviteCode));
                                },
                                child: Text(
                                  'Add Visitor',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                  ),
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
                          height: 20,
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
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Invitation Created By',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '$employeeName',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 250,
                                  child: CustTextButon(
                                    // sizeFont: 20,
                                    label: 'Change Visit Time',
                                    onTap: () {
                                      // changeVisitDialog(context)
                                      //     .then((value) {});
                                      Navigator.of(context)
                                          .push(ChangeVisitDialog());
                                      // Navigator.of(context).pop(false);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    height: 50,
                                    width: 250,
                                    child: CustTextButon(
                                      // sizeFont: 20,
                                      label: 'Cancel',
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 40,
                                  ),
                                  child: SizedBox(
                                    height: 50,
                                    width: 250,
                                    child: RegularButton(
                                      sizeFont: 20,
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
