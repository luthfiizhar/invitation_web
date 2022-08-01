import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/confirm_dialog.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

Future<bool> changeVisitDialog(BuildContext context) async {
  bool shouldPop = true;
  bool isLoading = false;
  return await showDialog(
      barrierDismissible: false,
      context: navKey.currentState!.overlay!.context,
      builder: (context) => AlertDialog(
            title: Text(
              'Change Visit Time',
              style: dialogTitle,
            ),
            backgroundColor: scaffoldBg,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 50,
                        width: 250,
                        child: CustTextButon(
                          // sizeFont: 20,
                          label: 'Change Visit Time',
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
                        child: CustTextButon(
                          // sizeFont: 20,
                          label: 'Cancel',
                          onTap: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
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
          ));
}

class ChangeVisitDialog extends ModalRoute<void> {
  ChangeVisitDialog({this.eventID});

  bool isLoading = false;
  String? eventID;
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();

  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();

  String? startDate;
  String? endDate;

  Future changeVisitTime(String eventId, String start, String end) async {
    // print('$start');
    // print('$end');
    // print('$eventId');
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/event/update-event-date');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "StartDate" : "$start",
          "EndDate" : "$end",
          "EventID" : "$eventID"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data);
    // if (data['Status'] == '200') {
    // } else {}
    return data['Status'];
  }

  final _formKey = new GlobalKey<FormState>();
  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black.withOpacity(0.1);

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

  showConfirmDialog(String eventId, String start, String end) {
    return confirmDialog(navKey.currentState!.context,
            'Are you sure want to change visit date?', true)
        .then((value) {
      if (value) {
        changeVisitTime(eventId, start, end).then((value) {
          setState(() {
            isLoading = false;
          });
          if (value == '200') {
            print('success');
            Navigator.of(navKey.currentState!.context)
                .push(NotifProcessDialog(
                    isSuccess: true, message: "Visit date has been updated!"))
                .then((value) {
              Navigator.pop(navKey.currentState!.context);
            });
            // Navigator.pop(navKey.currentState!.context);
          } else {
            Navigator.of(navKey.currentState!.context)
                .push(NotifProcessDialog(
                    isSuccess: false, message: "Something Wrong!"))
                .then((value) {
              Navigator.pop(navKey.currentState!.context);
            });
          }
        });
      }
    });
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage

    return Padding(
      padding: Responsive.isDesktop(context)
          ? EdgeInsets.all(15.0)
          : EdgeInsets.only(top: 15, bottom: 15),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 650,
                decoration: BoxDecoration(
                  borderRadius: Responsive.isDesktop(context)
                      ? BorderRadius.circular(15)
                      : BorderRadius.circular(10),
                  color: scaffoldBg,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: Responsive.isDesktop(context)
                          ? EdgeInsets.only(left: 50, right: 50, top: 40)
                          : EdgeInsets.only(left: 25, right: 25, top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     TextButton.icon(
                          //       onPressed: () {
                          //         Navigator.of(context).pop(false);
                          //       },
                          //       icon: Icon(
                          //         Icons.close,
                          //         color: eerieBlack,
                          //       ),
                          //       label: Text(''),
                          //     ),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Change Visit Time',
                                style: dialogTitle,
                              ),
                            ],
                          ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Responsive.isDesktop(context)
                                  ? inputDateContainer()
                                  : inputDateContainerMobile(),
                            ),
                          ),
                          Padding(
                            padding: Responsive.isDesktop(context)
                                ? EdgeInsets.only(top: 60, bottom: 40)
                                : EdgeInsets.only(top: 30, bottom: 25),
                            child: Center(
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: eerieBlack,
                                    )
                                  : SizedBox(
                                      width: Responsive.isBigDesktop(context)
                                          ? 250
                                          : null,
                                      height: 50,
                                      child: RegularButton(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            setState(
                                              () {
                                                isLoading = true;
                                              },
                                            );
                                            showConfirmDialog(eventID!,
                                                _startDate.text, _endDate.text);
                                          }
                                        },
                                        title: 'Confirm',
                                        sizeFont: Responsive.isDesktop(context)
                                            ? 24
                                            : 16,
                                      ),
                                    ),
                            ),
                          ),
                        ],
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
      ),
    );
  }

  Future _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: navKey.currentState!.context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: eerieBlack, // <-- SEE HERE
              onPrimary: silver, // <-- SEE HERE
              onSurface: eerieBlack, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: eerieBlack, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String formattedDate = DateFormat('d MMMM yyyy').format(picked!);
    if (picked != null) setState(() => controller.text = formattedDate);
  }

  Widget inputDateContainerMobile() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Visitation Start',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: eerieBlack),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    // height: 50,
                    padding: EdgeInsets.zero,
                    child: TextFormField(
                      cursorColor: onyxBlack,
                      focusNode: startDateNode,
                      controller: _startDate,
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      onTap: () {
                        FocusScope.of(navKey.currentState!.context)
                            .requestFocus(new FocusNode());
                        _selectDate(_startDate);
                      },
                      onSaved: (value) {
                        setState(() {
                          startDate = _startDate.text;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintText: '',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: 17, bottom: 16, left: 20, right: 20),
                        focusColor: onyxBlack,
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: eerieBlack,
                              width: 2.5,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 2.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        fillColor: graySand,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 2.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        errorStyle: TextStyle(color: orangeRed, fontSize: 14),
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF393E46)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Visitation End',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: eerieBlack),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.zero,
                    child: TextFormField(
                      cursorColor: onyxBlack,
                      focusNode: endDateNode,
                      controller: _endDate,
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      onTap: () {
                        FocusScope.of(navKey.currentState!.context)
                            .requestFocus(new FocusNode());
                        _selectDate(_endDate);
                      },
                      onSaved: (value) {
                        endDate = _endDate.text;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintText: '',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: 17, bottom: 16, left: 20, right: 20),
                        focusColor: onyxBlack,
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: eerieBlack,
                              width: 2.5,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 2.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        fillColor: graySand,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 2.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        errorStyle: TextStyle(color: silver, fontSize: 14),
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF393E46)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputDateContainer() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      // width: 700,
      // color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Visitation Start',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: eerieBlack),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      // height: 50,
                      padding: EdgeInsets.zero,
                      child: TextFormField(
                        cursorColor: onyxBlack,
                        focusNode: startDateNode,
                        controller: _startDate,
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        onTap: () {
                          FocusScope.of(navKey.currentState!.context)
                              .requestFocus(new FocusNode());
                          _selectDate(_startDate);
                        },
                        onSaved: (value) {
                          setState(() {
                            startDate = _startDate.text;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintText: '',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: 17, bottom: 17, left: 20, right: 20),
                          focusColor: onyxBlack,
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: eerieBlack,
                                width: 2.5,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: eerieBlack, width: 2.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF929AAB), width: 2.5)),
                          fillColor: graySand,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: eerieBlack, width: 2.5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF929AAB), width: 2.5)),
                          errorStyle: TextStyle(color: silver, fontSize: 18),
                        ),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF393E46)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Visitation End',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: eerieBlack),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      // height: 50,
                      padding: EdgeInsets.zero,
                      child: TextFormField(
                        cursorColor: onyxBlack,
                        focusNode: endDateNode,
                        controller: _endDate,
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        onTap: () {
                          FocusScope.of(navKey.currentState!.context)
                              .requestFocus(new FocusNode());
                          _selectDate(_endDate);
                        },
                        onSaved: (value) {
                          endDate = _endDate.text;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintText: '',
                          hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.only(
                              top: 17, bottom: 17, left: 20, right: 20),
                          focusColor: onyxBlack,
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: eerieBlack,
                                width: 2.5,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: eerieBlack, width: 2.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF929AAB), width: 2.5)),
                          fillColor: graySand,
                          filled: true,
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: eerieBlack, width: 2.5)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color(0xFF929AAB), width: 2.5)),
                          errorStyle: TextStyle(color: silver, fontSize: 18),
                        ),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF393E46)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
