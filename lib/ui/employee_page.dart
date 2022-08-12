import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/input_field.dart';
import 'package:navigation_example/widgets/input_visitor.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:http/http.dart' as http;

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  bool isLoading = false;
  late String phoneCode;
  late String phoneNumber;
  late String email;
  late String firstLogin;

  late String name = "";
  late String nip = "";

  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _phoneNumberCode = TextEditingController();

  late FocusNode emailNode;
  late FocusNode phoneNumberNode;
  late FocusNode phoneCodeNode;
  final _formKey = new GlobalKey<FormState>();

  Future getDataEmployee() async {
    var box = await Hive.openBox('userLogin');

    setState(() {
      name = box.get('name') != "" ? box.get('name') : "";
      nip = box.get('nip') != "" ? box.get('nip') : "";
      phoneCode = "62";
      phoneNumber = box.get('phoneNumber') != "" ? box.get('phoneNumber') : "";
      email = box.get('email') != "" ? box.get('email') : "";
      firstLogin =
          box.get('firstLogin') != "" ? box.get('firstLogin').toString() : "";
    });
    if (firstLogin == 'true') {
      _phoneNumberCode.text = phoneCode;
      _phoneNumber.text = phoneNumber.substring(1);
      _email.text = email;
    } else {
      getDataEmployeeLocal().then((value) {
        print(value);
        _phoneNumberCode.text = value['Data']['CountryCode'];
        _phoneNumber.text = value['Data']['PhoneNumber'];
        _email.text = value['Data']['Email'];
      });
    }
  }

  Future getDataEmployeeLocal() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(visitorId);

    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/get-employee-data');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      
    """;
    var response = await http.get(url, headers: requestHeader);
    var data = json.decode(response.body);
    // print('first name' + data['Data']['FirstName']);
    // if (data['Status'] == '200') {
    //   isLoading = false;
    // } else {
    //   isLoading = false;
    // }
    // setState(() {});
    return data;
  }

  Future updateDataEmployee(String code, String number, String email) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(visitorId);

    final url = Uri.https(
        apiUrl, '/VisitorManagementBackend/public/api/user/update-user-data');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "CountryCode" : "$code",
          "PhoneNumber" : "$number",
          "Email" : "$email"
      }
    """;

    print(bodySend);
    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    // print('first name' + data['Data']['FirstName']);
    // if (data['Status'] == '200') {
    //   isLoading = false;
    // } else {
    //   isLoading = false;
    // }
    // setState(() {});
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState

    emailNode = FocusNode();
    phoneCodeNode = FocusNode();
    phoneNumberNode = FocusNode();
    getDataEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? desktopLayoutEmployeePage(context)
        : mobileLayoutEmployeePage(context);
  }

  desktopLayoutEmployeePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarWeb(
                index: 2,
              ),
              Form(
                key: _formKey,
                child: Container(
                  // width: Responsive.isBigDesktop(context) ? 575 : 575,
                  // color: Colors.amber,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Responsive.isBigDesktop(context) ? 575 : 575,
                        padding: Responsive.isBigDesktop(context)
                            ? const EdgeInsets.only(top: 0, left: 0, right: 0)
                            : const EdgeInsets.only(top: 0, left: 0, right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.blue,
                              child: const Text(
                                'Employee Data',
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                // height: 56,
                                // color: Colors.green,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: const [
                                    Text(
                                      'Please confirm your data below. We will send notification when your guest is coming to your phone number.',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300,
                                          color: onyxBlack),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   color: Colors.blue,
                      //   child: Text(
                      //     'Employee',
                      //     style: pageTitle,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 20),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Container(
                      //         color: Colors.green,
                      //         child: Wrap(
                      //           alignment: WrapAlignment.start,
                      //           // runAlignment: WrapAlignment.start,
                      //           // crossAxisAlignment: WrapCrossAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Please confirm your data below. We will send notification when your guest is coming to your phone number.',
                      //               style: pageSubtitle,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30, left: 100, right: 100),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 450,
                              // color: Colors.amber,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  nameField(),
                                ],
                              ),
                            ),
                            Container(
                              // color: Colors.green,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  phoneNoField(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: SizedBox(
                                width: 450,
                                child: InputVisitor(
                                  controller: _email,
                                  label: 'Email',
                                  focusNode: emailNode,
                                  onSaved: (value) {
                                    email = value!;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 80, bottom: 30),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: eerieBlack,
                                    )
                                  : SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: RegularButton(
                                        title: 'Confirm',
                                        sizeFont: 24,
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            setState(() {
                                              isLoading = true;
                                            });
                                            updateDataEmployee(phoneCode,
                                                    phoneNumber, email)
                                                .then((value) async {
                                              print(value);
                                              setState(() {});
                                              isLoading = false;
                                              if (value['Status'] == "200") {
                                                var box = await Hive.openBox(
                                                    'userLogin');
                                                box.put('firstLogin', "false");
                                                Navigator.of(context)
                                                    .push(NotifProcessDialog(
                                                        isSuccess: true,
                                                        message:
                                                            "Data has been updated!"))
                                                    .then((value) {
                                                  if (firstLogin == 'true') {
                                                    navKey.currentState!
                                                        .pushReplacementNamed(
                                                            routeInvite);
                                                  } else {
                                                    navKey.currentState!
                                                        .pushReplacementNamed(
                                                            routeInvite);
                                                  }
                                                });
                                              } else {
                                                Navigator.of(context).push(
                                                    NotifProcessDialog(
                                                        isSuccess: false,
                                                        message:
                                                            value['Message']));
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
              alignment: Alignment.bottomCenter, child: FooterInviteWeb()),
        )
      ],
    );
  }

  mobileLayoutEmployeePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarMobile(
                index: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 35, right: 35),
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Employee Data',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please confirm your data below. We will send notification when your guest is coming to your phone number.',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: onyxBlack),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20, left: 0, right: 0),
                          child: Center(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  nameField(),
                                  phoneNoFieldMobile(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: InputVisitor(
                                      controller: _email,
                                      label: 'Email',
                                      focusNode: emailNode,
                                      onSaved: (value) {
                                        email = value!;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 30),
                                    child: SizedBox(
                                      // width: 200,
                                      height: 40,
                                      child: RegularButton(
                                        title: 'Confirm',
                                        sizeFont: 16,
                                        onTap: () {},
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget nameField() {
    return Container(
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: Responsive.isDesktop(context) ? 20 : 14,
                    fontWeight: FontWeight.w700,
                    color: onyxBlack,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: Responsive.isDesktop(context) ? 20 : 14,
                      fontWeight: FontWeight.w300,
                      color: onyxBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Employee Number',
                    style: TextStyle(
                      fontSize: Responsive.isDesktop(context) ? 20 : 14,
                      fontWeight: FontWeight.w700,
                      color: onyxBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    nip,
                    style: TextStyle(
                      fontSize: Responsive.isDesktop(context) ? 20 : 14,
                      fontWeight: FontWeight.w300,
                      color: onyxBlack,
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

  Widget phoneNoFieldMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                'Phone Number',
                style: TextStyle(
                    fontSize: Responsive.isDesktop(context) ? 20 : 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            children: [
              SizedBox(
                // padding: EdgeInsets.zero,
                width: 80,
                // height: 50,
                child: phoneCodeInput(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    padding: EdgeInsets.zero,
                    width: Responsive.isDesktop(context) ? 330 : null,
                    // height: 50,
                    child: phoneNumberInput(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget phoneNoField() {
    return Container(
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      fontSize: Responsive.isDesktop(context) ? 20 : 14,
                      fontWeight: FontWeight.w700,
                      color: onyxBlack),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                SizedBox(
                  // padding: EdgeInsets.zero,
                  width: 100,
                  height: 50,
                  child: phoneCodeInput(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    // padding: EdgeInsets.zero,
                    width: Responsive.isDesktop(context) ? 330 : null,
                    height: 50,
                    child: phoneNumberInput(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumberInput() {
    return TextFormField(
      focusNode: phoneNumberNode,
      controller: _phoneNumber,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) => value!.isEmpty ? 'This field is required' : null,
      onSaved: (value) {
        setState(() {
          phoneNumber = _phoneNumber.text;
        });
      },
      cursorColor: eerieBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: Responsive.isDesktop(context)
            ? EdgeInsets.only(
                top: 17,
                bottom: 15,
                left: 20,
                right: 20,
              )
            : EdgeInsets.only(
                top: 16,
                bottom: 17,
                left: 20,
                right: 20,
              ),
        isCollapsed: true,
        focusColor: eerieBlack,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(
              color: eerieBlack,
              width: 2.5,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: eerieBlack, width: 2.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
        fillColor: graySand,
        filled: true,
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: eerieBlack, width: 2.5)),
        border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
        errorStyle: phoneNumberNode.hasFocus
            ? TextStyle(fontSize: 0, height: 0)
            : TextStyle(
                color: silver,
                fontSize: Responsive.isDesktop(context) ? 18 : 14),
      ),
      style: TextStyle(
        fontSize: Responsive.isDesktop(context) ? 20 : 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF393E46),
      ),
    );
  }

  Widget phoneNumberInputMobile() {
    return Expanded(
      child: TextFormField(
        focusNode: phoneNumberNode,
        controller: _phoneNumber,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => value!.isEmpty ? 'This field is required' : null,
        onSaved: (value) {
          setState(() {
            phoneNumber = _phoneNumber.text;
          });
        },
        cursorColor: eerieBlack,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: Responsive.isDesktop(context)
              ? EdgeInsets.symmetric(vertical: 20, horizontal: 20)
              : EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          isCollapsed: true,
          focusColor: eerieBlack,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
              borderSide: BorderSide(
                color: eerieBlack,
                width: 2.5,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
              borderSide: BorderSide(color: eerieBlack, width: 2.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
              borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
          fillColor: graySand,
          filled: true,
          errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
              borderSide: BorderSide(color: eerieBlack, width: 2.5)),
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
              borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
          errorStyle: phoneNumberNode.hasFocus
              ? TextStyle(fontSize: 0, height: 0)
              : TextStyle(
                  color: silver,
                  fontSize: Responsive.isDesktop(context) ? 18 : 14),
        ),
        style: TextStyle(
          fontSize: Responsive.isDesktop(context) ? 20 : 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF393E46),
        ),
      ),
    );
  }

  Widget phoneCodeInput() {
    return TextFormField(
      maxLength: 2,
      cursorColor: eerieBlack,
      controller: _phoneNumberCode,
      focusNode: phoneCodeNode,
      validator: (value) {
        if (_phoneNumber.text.isEmpty) {
          return '';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        phoneCode = _phoneNumberCode.text;
      },
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixStyle: TextStyle(
            fontSize: Responsive.isDesktop(context) ? 20 : 14,
            fontWeight: FontWeight.w700,
            color: onyxBlack),
        counterText: "",
        prefixIconConstraints: Responsive.isDesktop(context)
            ? null
            : BoxConstraints(minWidth: 30, minHeight: 37),
        prefixIcon: Padding(
          padding: Responsive.isDesktop(context)
              ? EdgeInsets.only(bottom: 3, left: 0, right: 0)
              : EdgeInsets.only(bottom: 1, right: 0, left: 1),
          child: Icon(
            Icons.add,
            size: Responsive.isDesktop(context) ? 20 : 14,
            color: eerieBlack,
          ),
        ),
        prefixIconColor: eerieBlack,
        isDense: true,
        contentPadding: Responsive.isDesktop(context)
            ? EdgeInsets.only(
                top: 17,
                bottom: 15,
                left: 10,
                right: 10,
              )
            : EdgeInsets.only(
                top: 17,
                bottom: 0,
                left: 0,
                right: 2,
              ),
        isCollapsed: true,
        focusColor: eerieBlack,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(
              color: eerieBlack,
              width: 2.5,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: eerieBlack, width: 2.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
        fillColor: graySand,
        filled: true,
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: eerieBlack, width: 2.5)),
        border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(Responsive.isDesktop(context) ? 10 : 7),
            borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
        errorStyle: phoneNumberNode.hasFocus
            ? TextStyle(fontSize: 0, height: 0)
            : TextStyle(
                color: silver,
                fontSize: Responsive.isDesktop(context) ? 18 : 14),
      ),
      style: TextStyle(
          fontSize: Responsive.isDesktop(context) ? 20 : 14,
          fontWeight: FontWeight.w700,
          color: eerieBlack),
    );
  }
}
