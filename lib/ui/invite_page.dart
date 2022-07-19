import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/confirm_invitation_page.dart';
import 'package:navigation_example/visitor.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/multi_form.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:http/http.dart' as http;

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  int visitorLength = 1;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  TextEditingController _email = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();
  FocusNode emailNode = FocusNode();

  String? startDate;
  String? endDate;

  final _formKey = new GlobalKey<FormState>();
  List<Visitor> visitorList = [];

  List<MultiVisitorFOrm> formList = List.empty(growable: true);
  List<MultiVisitorFOrmMobile> formListMobile = List.empty(growable: true);
  MultiVisitorFOrm? items;

  Future saveInviteVisitorData(var items) async {
    var box = await Hive.openBox('inputvisitorBox');
    box.put('listInvite', items != null ? items : "");
    box.put('startDate', startDate != null ? startDate : "");
    box.put('endDate', endDate != null ? endDate : "");

    var name;
    name = box.get('listInvite');
    var date;
    date = box.get('startDate');
    print(name);
    print(date);
    // print(name);
  }

  Future clearVisitorData() async {
    var box = await Hive.openBox('visitorBox');
    box.delete('listInvite');
    box.delete('startDate');
    box.delete('endDate');
    print('deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? desktopLayoutInvitePage(context)
        : mobileLayoutInvitePage(context);
    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       NavigationBarWeb(
    //         index: 0,
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(top: 50, left: 500, right: 500),
    //         child: Container(
    //           // color: Colors.red,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 'Invite Visitor',
    //                 style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 10),
    //                 child: Container(
    //                   height: 60,
    //                   child: Wrap(
    //                     children: [
    //                       Text(
    //                         'Please fill visitor\'s name & email below. We will send them an email to complete their data.',
    //                         style: TextStyle(
    //                             fontSize: 24, fontWeight: FontWeight.w300),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Form(
    //                 key: _formKey,
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: EdgeInsets.only(top: 10),
    //                       child: inputDateContainer(),
    //                     ),
    //                     formList.length > 0
    //                         ? Padding(
    //                             padding: const EdgeInsets.only(top: 30),
    //                             child: Divider(
    //                               thickness: 2,
    //                               color: spanishGray,
    //                             ),
    //                           )
    //                         : SizedBox(),
    //                     ListView.builder(
    //                       shrinkWrap: true,
    //                       itemCount: formList.length,
    //                       itemBuilder: (context, index) {
    //                         return formList[index];
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 20, bottom: 30),
    //                 child: Center(
    //                   child: IconButton(
    //                     padding: EdgeInsets.zero,
    //                     onPressed: () {
    //                       setState(() {
    //                         Visitor _visitorModel =
    //                             Visitor(number: formList.length);

    //                         formList.add(MultiVisitorFOrm(
    //                           index: formList.length,
    //                           visitorModel: _visitorModel,
    //                           onRemove: () {
    //                             onRemove(_visitorModel);
    //                           },
    //                         ));
    //                       });
    //                     },
    //                     icon: Icon(
    //                       Icons.add_circle_outline,
    //                       size: 40,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Center(
    //                 child: SizedBox(
    //                   height: 60,
    //                   width: 275,
    //                   child: RegularButton(
    //                     title: 'Next',
    //                     sizeFont: 24,
    //                     onTap: () {
    //                       if (_formKey.currentState!.validate()) {
    //                         _formKey.currentState!.save();
    //                         onSave();

    //                         var json = jsonEncode(visitorList);
    //                         saveInviteVisitorData(json);
    //                         print(visitorList.toList());
    //                         Navigator.pushNamed(context, routeConfiemInvite)
    //                             .then((value) {
    //                           setState(() {
    //                             visitorList.clear();
    //                             clearVisitorData().then((value) {
    //                               setState(() {});
    //                             });
    //                           });
    //                         });
    //                       } else {
    //                         print('gagal');
    //                       }

    //                       // Navigator.push(
    //                       //     context,
    //                       //     MaterialPageRoute(
    //                       //         builder: (BuildContext context) =>
    //                       //             ConfirmInvitePage()));

    //                       // print(json);
    //                     },
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 30,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 170),
    //         child: FooterInviteWeb(),
    //       ),
    //     ],
    //   ),
    // );
  }

  // bool validate() {
  //   //Validate Form Fields by form key
  //   bool validate = _formKey.currentState!.validate();
  //   if (validate) _formKey.currentState!.save();
  //   return validate;
  // }

  onRemove(Visitor visitor) {
    setState(() {
      int index =
          formList.indexWhere((element) => element.index == visitor.number);

      print(index);

      if (formList != null) formList.removeAt(index);
    });
  }

  onSave() {
    bool allValid = true;

    //If any form validation function returns false means all forms are not valid
    // formList
    //     .forEach((element) => allValid = (allValid && element.isValidated()));

    // if (allValid) {
    for (int i = 0; i < formList.length; i++) {
      items = formList[i];

      // print("Name: ${item.visitorModel!.firstName}");
      // print("Number: ${item.visitorModel!.lastName}");
      // print("Email: ${item.visitorModel!.email}");
      print(items!.visitorModel!);
      visitorList.add(Visitor(
          FirstName: items!.visitorModel!.FirstName,
          LastName: items!.visitorModel!.LastName,
          Email: items!.visitorModel!.Email));
    }

    //Submit Form Here
    // } else {
    //   debugPrint("Form is Not Valid");
    // }
  }

  Future _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
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
                          // height: 50,
                          padding: EdgeInsets.zero,
                          child: TextFormField(
                            validator: (value) =>
                                value == "" ? "This field is required" : null,
                            cursorColor: onyxBlack,
                            focusNode: startDateNode,
                            controller: _startDate,
                            onTap: () {
                              // FocusScope.of(context)
                              //     .requestFocus(new FocusNode());
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
                              hintText: 'Click here to select start date',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 21, bottom: 17, left: 30, right: 30),
                              focusColor: onyxBlack,
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: eerieBlack,
                                    width: 10,
                                  )),
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: eerieBlack, width: 10)),
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
                          // height: 50,
                          padding: EdgeInsets.zero,
                          child: TextFormField(
                            validator: (value) =>
                                value == "" ? "This field is required" : null,
                            cursorColor: onyxBlack,
                            focusNode: endDateNode,
                            controller: _endDate,
                            onTap: () {
                              // FocusScope.of(context)
                              //     .requestFocus(new FocusNode());
                              _selectDate(_endDate);
                            },
                            onSaved: (value) {
                              endDate = _endDate.text;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintText: 'Click here to select end date',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 21, bottom: 17, left: 30, right: 30),
                              focusColor: onyxBlack,
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: eerieBlack,
                                    width: 10,
                                  )),
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: eerieBlack, width: 10)),
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

  Widget desktopLayoutInvitePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarWeb(
                index: 0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 500, right: 500),
                child: Container(
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invite Visitor',
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          height: 60,
                          child: Wrap(
                            children: [
                              Text(
                                'Please fill visitor\'s name & email below. We will send them an email to complete their data.',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: inputDateContainer(),
                            ),
                            formList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Divider(
                                      thickness: 2,
                                      color: spanishGray,
                                    ),
                                  )
                                : SizedBox(),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: formList.length,
                              itemBuilder: (context, index) {
                                return formList[index];
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                Visitor _visitorModel =
                                    Visitor(number: formList.length);

                                formList.add(MultiVisitorFOrm(
                                  index: formList.length,
                                  visitorModel: _visitorModel,
                                  onRemove: () {
                                    onRemove(_visitorModel);
                                  },
                                ));
                              });
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 275,
                          child: RegularButton(
                            title: 'Next',
                            sizeFont: 24,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                onSave();

                                var json = jsonEncode(visitorList);
                                saveInviteVisitorData(json);
                                print(visitorList.toList());
                                Navigator.pushNamed(context, routeConfiemInvite)
                                    .then((value) {
                                  setState(() {
                                    visitorList.clear();
                                    clearVisitorData().then((value) {
                                      setState(() {});
                                    });
                                  });
                                });
                              } else {
                                print('gagal');
                              }

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             ConfirmInvitePage()));

                              // print(json);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
        ),
      ],
    );
  }

  Widget inputDateContainerMobile() {
    return Container(
      padding: EdgeInsets.only(top: 40),
      // width: 700,
      // color: Colors.blue,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
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
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      cursorColor: onyxBlack,
                      focusNode: startDateNode,
                      controller: _startDate,
                      onTap: () {
                        // FocusScope.of(context)
                        //     .requestFocus(new FocusNode());
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
                        hintText: 'Click here to select start date',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: 21, bottom: 17, left: 30, right: 30),
                        focusColor: onyxBlack,
                        focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: eerieBlack,
                              width: 10,
                            )),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 10)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        fillColor: graySand,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 2.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
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
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      cursorColor: onyxBlack,
                      focusNode: endDateNode,
                      controller: _endDate,
                      onTap: () {
                        // FocusScope.of(context)
                        //     .requestFocus(new FocusNode());
                        _selectDate(_endDate);
                      },
                      onSaved: (value) {
                        endDate = _endDate.text;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintText: 'Click here to select end date',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: 21, bottom: 17, left: 30, right: 30),
                        focusColor: onyxBlack,
                        focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: eerieBlack,
                              width: 10,
                            )),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 10)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        fillColor: graySand,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: eerieBlack, width: 2.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
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
        ],
      ),
    );
  }

  Widget mobileLayoutInvitePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarMobile(),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: Container(
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invite Visitor',
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          height: 60,
                          child: Wrap(
                            children: [
                              Text(
                                'Please fill visitor\'s name & email below. We will send them an email to complete their data.',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: inputDateContainerMobile(),
                            ),
                            formList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Divider(
                                      thickness: 2,
                                      color: spanishGray,
                                    ),
                                  )
                                : SizedBox(),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: formList.length,
                              itemBuilder: (context, index) {
                                return formList[index];
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                Visitor _visitorModel =
                                    Visitor(number: formList.length);

                                formList.add(MultiVisitorFOrm(
                                  index: formList.length,
                                  visitorModel: _visitorModel,
                                  onRemove: () {
                                    onRemove(_visitorModel);
                                  },
                                ));
                              });
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 275,
                          child: RegularButton(
                            title: 'Next',
                            sizeFont: 24,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                onSave();

                                var json = jsonEncode(visitorList);
                                saveInviteVisitorData(json);
                                print(visitorList.toList());
                                Navigator.pushNamed(context, routeConfiemInvite)
                                    .then((value) {
                                  setState(() {
                                    visitorList.clear();
                                    clearVisitorData().then((value) {
                                      setState(() {});
                                    });
                                  });
                                });
                              } else {
                                print('gagal');
                              }

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             ConfirmInvitePage()));

                              // print(json);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
}
