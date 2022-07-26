import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/my_app.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/input_field.dart';
import 'package:navigation_example/widgets/regular_button.dart';

class WelcomePage extends StatelessWidget {
  // const WelcomePage({Key? key}) : super(key: key);
  Future loginAuth() async {
    var url = Uri.http(apiUrl, '/api/login-hcplus');
    Map<String, String> requestHeader = {
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "Username" : "$userName",
          "Password" : "$password"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data);
    if (data['Status'] == '200') {
      var box = await Hive.openBox('userLogin');
      box.put('nip', data['Data']['NIP'] != null ? data['Data']['NIP'] : "");
      box.put('name', data['Data']['Name'] != null ? data['Data']['Name'] : "");
      box.put('jwtToken',
          data['Data']['Token'] != null ? data['Data']['Token'] : "");

      return data['Status'];
    } else {
      return data['Status'];
    }
  }

  login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      loginAuth().then((value) {
        if (value == '200') {
          Navigator.of(context).pushReplacementNamed(routeInvite);
        }
      });
      // print(userName);
      // Navigator.of(context).push(
      //     NotifProcessDialog());
      // login().then((value) {
      //   if (value == '200') {

      //   } else {
      //     print('Login Failed');
      //   }
      // });
    }
  }

  String? userName;
  String? password;

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  FocusNode userNameNode = FocusNode();
  FocusNode passNode = FocusNode();
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Responsive.isDesktop(context)
          ? desktopLayout(context)
          : phoneLayout(context),
    );
  }

  Widget desktopLayout(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: -20,
              // left: ,
              child: Container(
                padding: EdgeInsets.zero,
                width: 232,
                height: 75,
                // color: Colors.blue,
                child: SvgPicture.asset(
                  'assets/klg_main_logo_old.svg',
                  color: eerieBlack,
                  fit: BoxFit.cover,
                  // height: 100,
                  // width: 300,
                ),
              )
              // Container(
              //   height: 75,
              //   width: 232,
              //   // color: Colors.black,
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //           fit: BoxFit.fitHeight,
              //           image: AssetImage('assets/KLG_Main_logo_tagline.png'))),
              // ),
              ),
          Positioned(
              bottom: 20,
              right: 20,
              // left: ,
              child: Text('Facility Management 2022')),
          LayoutBuilder(builder: (context, c) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('${window.screen?.width}   ${window.screen?.height}'),
                      Container(
                          // height: 500,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              // color: Colors.grey,
                              // image: DecorationImage(
                              //     image: AssetImage('assets/welcome_page_image.png')),
                              ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 100, left: 0, right: 0),
                            child: Container(
                              // color: Colors.blue,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // color: Colors.amber,
                                        // padding:
                                        //     EdgeInsets.only(right: 70, top: 30),
                                        width: 550,
                                        height: 500,
                                        child: SvgPicture.asset(
                                            'assets/Ilustrasi Welcome Website B.svg',
                                            fit: BoxFit.fitHeight),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    // flex: 9,
                                    child: Container(
                                      // color: Colors.blue,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, top: 15),
                                            child: Container(
                                              // color: Colors.yellow,
                                              // height: 200,
                                              // width: 620,
                                              padding: EdgeInsets.zero,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Welcome to',
                                                    style: TextStyle(
                                                        // letterSpacing: 1,
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        // fontFamily: 'Helvetica',
                                                        color: eerieBlack),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 600,
                                                    child: Wrap(
                                                      children: [
                                                        Text(
                                                          'Kawan Lama Group',
                                                          style: TextStyle(
                                                            // letterSpacing: 1,
                                                            fontSize: 48,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: eerieBlack,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Visitor Invitation',
                                                          style: TextStyle(
                                                            // letterSpacing: 1,
                                                            fontSize: 64,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: eerieBlack,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 15, left: 15),
                                            child: Container(
                                              child: Text(
                                                'Please login using HC Plus for using the site',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w300,
                                                  color: onyxBlack,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 40,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  width: 300,
                                                  // height: 70,
                                                  child: InputField(
                                                    controller: _username,
                                                    label: 'Username',
                                                    focusNode: userNameNode,
                                                    hintText:
                                                        'Username here...',
                                                    onSaved: (value) {
                                                      userName = value;
                                                    },
                                                    obsecureText: false,
                                                    validator: (value) => value ==
                                                            ""
                                                        ? "This field is required"
                                                        : null,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  width: 300,
                                                  child: InputField(
                                                    controller: _password,
                                                    label: 'Password',
                                                    focusNode: passNode,
                                                    hintText:
                                                        'Password here...',
                                                    onSaved: (value) {
                                                      password = value;
                                                    },
                                                    obsecureText: true,
                                                    validator: (value) => value ==
                                                            ""
                                                        ? "This field is required"
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 35,
                                                left: 15,
                                                right: 15,
                                                bottom: 40),
                                            child: SizedBox(
                                              width: 140,
                                              height: 50,
                                              //Tombol Login Desktop Layout
                                              child: RegularButton(
                                                title: 'Login',
                                                sizeFont: 20,
                                                onTap: () {
                                                  login(context);
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
                          )),
                      // Container(),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget phoneLayout(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      width: 120,
                      height: 40,
                      // color: Colors.blue,
                      child: SvgPicture.asset(
                        'assets/klg_main_logo_old.svg',
                        color: eerieBlack,
                        fit: BoxFit.cover,
                        // height: 100,
                        // width: 300,
                      ),
                    ),
                  ],
                ),
                Container(
                  // color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 50,
                      left: 50,
                      right: 50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.amber,
                          // padding:
                          //     EdgeInsets.only(right: 70, top: 30),
                          width: 200,
                          height: 200,
                          child: SvgPicture.asset(
                              'assets/Ilustrasi Welcome Website B.svg',
                              fit: BoxFit.fitHeight),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                // color: Colors.yellow,
                                // height: 200,
                                // width: 620,
                                padding: EdgeInsets.zero,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome to',
                                      style: TextStyle(
                                          // letterSpacing: 1,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          // fontFamily: 'Helvetica',
                                          color: eerieBlack),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      // color: Colors.amber,
                                      // width: 300,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kawan Lama Group',
                                            style: TextStyle(
                                              // letterSpacing: 1,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w700,
                                              color: eerieBlack,
                                            ),
                                          ),
                                          Text(
                                            'Visitor Invitation',
                                            style: TextStyle(
                                              // letterSpacing: 1,
                                              fontSize: 26,
                                              fontWeight: FontWeight.w700,
                                              color: eerieBlack,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Please login using HC Plus for using the site',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: onyxBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: InputField(
                            controller: _username,
                            label: 'Username',
                            focusNode: userNameNode,
                            hintText: 'Username here...',
                            onSaved: (value) {
                              userName = value;
                            },
                            obsecureText: false,
                            validator: (value) => value == ""
                                ? "Please insert your username"
                                : null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: InputField(
                            controller: _password,
                            label: 'Password',
                            focusNode: passNode,
                            hintText: 'Password here...',
                            onSaved: (value) {
                              password = value;
                            },
                            obsecureText: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 30),
                          child: SizedBox(
                              width: 175,
                              height: 50,
                              child: RegularButton(
                                title: 'Login',
                                sizeFont: 24,
                                onTap: () {
                                  login(context);
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 100, bottom: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text('Facility Management 2022'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
