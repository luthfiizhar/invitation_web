import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:navigation_example/widgets/text_button.dart';
import 'package:universal_html/html.dart' as html;

Future<bool> changeVisitDialog(BuildContext context) async {
  bool shouldPop = true;
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
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();

  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();

  String? startDate;
  String? endDate;

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

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: 700,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: scaffoldBg,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Change Visit Time',
                            style: dialogTitle,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: inputDateContainer(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 40),
                        child: Center(
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: RegularButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              title: 'OK',
                              sizeFont: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  Widget inputDateContainer() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      // width: 700,
      // color: Colors.blue,
      child: Column(
        children: [
          Row(
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
                          height: 50,
                          padding: EdgeInsets.zero,
                          child: TextFormField(
                            cursorColor: onyxBlack,
                            focusNode: startDateNode,
                            controller: _startDate,
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
                                  top: 21, bottom: 17, left: 30, right: 30),
                              focusColor: onyxBlack,
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: eerieBlack,
                                    width: 2.5,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: eerieBlack, width: 2.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Color(0xFF929AAB), width: 2.5)),
                              fillColor: graySand,
                              filled: true,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: eerieBlack, width: 2.5)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Color(0xFF929AAB), width: 2.5)),
                              errorStyle:
                                  TextStyle(color: silver, fontSize: 18),
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
                          height: 50,
                          padding: EdgeInsets.zero,
                          child: TextFormField(
                            cursorColor: onyxBlack,
                            focusNode: endDateNode,
                            controller: _endDate,
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
                                  top: 21, bottom: 17, left: 30, right: 30),
                              focusColor: onyxBlack,
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: eerieBlack,
                                    width: 2.5,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: eerieBlack, width: 2.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Color(0xFF929AAB), width: 2.5)),
                              fillColor: graySand,
                              filled: true,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: eerieBlack, width: 2.5)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Color(0xFF929AAB), width: 2.5)),
                              errorStyle:
                                  TextStyle(color: silver, fontSize: 18),
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
        ],
      ),
    );
  }
}