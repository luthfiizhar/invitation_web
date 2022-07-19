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
  Future login() async {
    var url = Uri.http(apiUrl, '/api/login-hcplus');
    Map<String, String> requestHeader = {
      'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json'
    };
    var bodySend = """ 
      {
          "Username" : "164369",
          "Password" : "test123"
      }
    """;

    var response = await http.post(url, headers: requestHeader, body: bodySend);
    var data = json.decode(response.body);
    print(data);
    if (data['Status'] == '200') {
      var box = await Hive.openBox('userLogin');
      box.put('name', data['Data']['NIP'] != null ? data['Data']['NIP'] : "");
      box.put('nip', data['Data']['Name'] != null ? data['Data']['Name'] : "");
      box.put('jwtToken',
          data['Data']['Token'] != null ? data['Data']['Token'] : "");

      return data['Status'];
    } else {
      return data['Status'];
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
                            padding: EdgeInsets.only(
                                top: 100, left: 100, right: 100),
                            child: Container(
                              // color: Colors.blue,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // color: Colors.amber,
                                        padding:
                                            EdgeInsets.only(right: 70, top: 30),
                                        width: 550,
                                        height: 480,
                                        child: SvgPicture.asset(
                                            'assets/illustration.svg'),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    // flex: 7,
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
                                              width: 620,
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
                                                  Wrap(
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
                                                    onSaved: (value) {},
                                                    obsecureText: true,
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
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState!
                                                          .save();

                                                      // print(userName);
                                                      // Navigator.of(context).push(
                                                      //     NotifProcessDialog());
                                                      // login().then((value) {
                                                      //   if (value == '200') {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              routeInvite);
                                                      //   } else {
                                                      //     print('Login Failed');
                                                      //   }
                                                      // });
                                                    }

                                                    // Navigator.pushNamed(context,
                                                    //     '/invite_page');
                                                    // Navigator
                                                    //     .pushReplacementNamed(
                                                    //         context,
                                                    //         routeMyApp);
                                                  },
                                                )),
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 250,
              left: 50,
              right: 50,
            ),
            child: Column(
              children: [
                InputField(
                  controller: _username,
                  label: 'Username',
                  focusNode: userNameNode,
                  hintText: 'Username here...',
                  onSaved: (value) {
                    userName = value;
                  },
                  obsecureText: false,
                  validator: (value) =>
                      value == "" ? "Please insert your username" : null,
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
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                      width: 175,
                      height: 50,
                      child: RegularButton(
                        title: 'Login',
                        sizeFont: 24,
                        onTap: () {
                          // login().then((value) {
                          //   if (value == '200') {
                          // Navigator.of(context)
                          //     .pushReplacementNamed(
                          //         routeInvite);
                          //   } else {
                          //     print('Login Failed');
                          //   }
                          // });
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print(userName);
                            print(password);
                            Navigator.of(context)
                                .pushReplacementNamed(routeInvite);
                            // Navigator.of(context).push(NotifProcessDialog());
                          }

                          // Navigator.pushNamed(context,
                          //     '/invite_page');
                          // Navigator
                          //     .pushReplacementNamed(
                          //         context,
                          //         routeMyApp);
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
