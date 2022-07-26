import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/responsive.dart';
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
  late String phoneCode;
  late String phoneNumber;
  late String email;

  late String name = "";
  late String nip = "";

  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _phoneNumberCode = TextEditingController();

  late FocusNode emailNode;
  late FocusNode phoneNumberNode;
  late FocusNode phoneCodeNode;

  Future getDataEmployee() async {
    var box = await Hive.openBox('userLogin');

    setState(() {
      name = box.get('name') != "" ? box.get('name') : "";
      nip = box.get('nip') != "" ? box.get('nip') : "";
      phoneCode = "62";
      phoneNumber = box.get('phoneNumber') != "" ? box.get('phoneNumber') : "";
      email = box.get('email') != "" ? box.get('email') : "";
    });
    _phoneNumberCode.text = phoneCode;
    _phoneNumber.text = phoneNumber.substring(1);
    _email.text = email;
  }

  Future updateDataEmployee(String code, String number, String email) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    // print(visitorId);

    final url = Uri.https(apiUrl,
        '/VisitorManagementBackend/public/api/visitor/approve-visitor-data');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          
      }
    """;

    print(bodySend);
    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print('first name' + data['Data']['FirstName']);
    // if (data['Status'] == '200') {
    //   isLoading = false;
    // } else {
    //   isLoading = false;
    // }
    // setState(() {});
    return data['Data'];
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
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              NavigationBarWeb(
                index: 2,
              ),
            ],
          ),
        ),
      ],
    );
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
              Padding(
                padding: Responsive.isBigDesktop(context)
                    ? EdgeInsets.only(top: 60, left: 500, right: 500)
                    : EdgeInsets.only(top: 60, left: 300, right: 300),
                child: Form(
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Employee',
                              style: pageTitle,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Please confirm your data below. We will send notification when your guest is coming to your phone number.',
                            style: pageSubtitle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 100, right: 100),
                          child: Center(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  nameField(),
                                  phoneNoField(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 30,
                                    ),
                                    child: InputVisitor(
                                      controller: _email,
                                      label: 'Email',
                                      focusNode: emailNode,
                                      onSaved: (value) {},
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 80, bottom: 30),
                                    child: SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: RegularButton(
                                        title: 'Confirm',
                                        sizeFont: 24,
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
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Form(
                  child: Container(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Employee',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Please confirm your data below. We will send notification when your guest is coming to your phone number.',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 40, left: 0, right: 0),
                          child: Center(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  nameField(),
                                  phoneNoField(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 30,
                                    ),
                                    child: InputVisitor(
                                      controller: _email,
                                      label: 'Email',
                                      focusNode: emailNode,
                                      onSaved: (value) {},
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 80, bottom: 30),
                                    child: SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: RegularButton(
                                        title: 'Confirm',
                                        sizeFont: 24,
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
    return Column(
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
                    fontWeight: FontWeight.w400,
                    color: onyxBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Employee Number',
                  style: TextStyle(
                    fontSize: 20,
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
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: onyxBlack,
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
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Text(
                'Phone Number',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                width: 120,
                // height: 50,
                child: phoneCodeInput(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    padding: EdgeInsets.zero,
                    // width: 250,
                    // height: 50,
                    child: phoneNumberInput(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget phoneNumberInput() {
    return TextFormField(
      focusNode: phoneNumberNode,
      controller: _phoneNumber,
      keyboardType: TextInputType.phone,
      validator: (value) => value!.isEmpty ? 'This field is required' : null,
      onSaved: (value) {
        setState(() {
          phoneNumber = _phoneNumber.text;
        });
      },
      cursorColor: eerieBlack,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        isCollapsed: true,
        focusColor: eerieBlack,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: eerieBlack,
              width: 2.5,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: eerieBlack, width: 2.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
        fillColor: graySand,
        filled: true,
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: eerieBlack, width: 2.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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

  Widget phoneCodeInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              counterText: "",
              prefixIcon: Icon(
                Icons.add,
                size: 24,
                color: eerieBlack,
              ),
              prefixIconColor: eerieBlack,
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              isCollapsed: true,
              focusColor: eerieBlack,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: eerieBlack,
                  width: 2.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: eerieBlack, width: 2.5)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
              fillColor: graySand,
              filled: true,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: eerieBlack, width: 2.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
                color: eerieBlack),
          ),
        ),
      ],
    );
  }
}
