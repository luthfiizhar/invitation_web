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
import 'package:navigation_example/main.dart';
import 'package:navigation_example/model/main_model.dart';
import 'package:navigation_example/my_app.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/ui/employee_page.dart';
import 'package:navigation_example/widgets/dialogs/notif_process_dialog.dart';
import 'package:navigation_example/widgets/input_field.dart';
import 'package:navigation_example/widgets/regular_button.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // const WelcomePage({Key? key}) : super(key: key);

  bool isLoading = false;
  Future loginAuth(MainModel model) async {
    var url =
        Uri.https(apiUrl, '/VisitorManagementBackend/public/api/login-hcplus');
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
      box.put(
          'phoneNumber',
          data['Data']['PhoneNumber'] != null
              ? data['Data']['PhoneNumber']
              : "");
      box.put(
          'email', data['Data']['Email'] != null ? data['Data']['Email'] : "");
      box.put('jwtToken',
          data['Data']['Token'] != null ? data['Data']['Token'] : "");
      box.put('firstLogin',
          data['Data']['FirstLogin'] != null ? data['Data']['FirstLogin'] : "");
      // Provider.of<MainModel>(context, listen: false).setIsExpired(false);
      model.setIsExpired(false);
      return data;
    } else {
      return data;
    }
  }

  login(BuildContext context, MainModel model) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      loginAuth(model).then((value) {
        // var firstLogin = false;
        isLoading = false;
        setState(() {});
        if (value['Status'] == '200') {
          jwtToken = value['Data']['Token'];
          model.setJwt(value['Data']['Token']);
          value['Data']['FirstLogin']
              ? Navigator.of(context).pushReplacementNamed(routeEmployee)
              : Navigator.of(context).pushReplacementNamed(routeInvite);
        } else {
          jwtToken = "";
          Navigator.of(context).push(
              NotifProcessDialog(message: value['Message'], isSuccess: false));
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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameNode.addListener(() {});
    passNode.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameNode.dispose();
    passNode.dispose();
  }

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
              left: -15,
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
              child: Text(
                'Facility Management. 2022.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: spanishGray,
                ),
              )),
          Consumer<MainModel>(builder: (context, model, child) {
            return LayoutBuilder(builder: (context, c) {
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text('${window.screen?.width}   ${window.screen?.height}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  // height: 500,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      // color: Colors.grey,
                                      // image: DecorationImage(
                                      //     image: AssetImage('assets/welcome_page_image.png')),
                                      ),
                                  child: Padding(
                                    padding: Responsive.isBigDesktop(context)
                                        ? EdgeInsets.only(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 20)
                                        : EdgeInsets.only(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 20),
                                    child: Container(
                                      // color: Colors.blue,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // color: Colors.amber,
                                            // padding:
                                            //     EdgeInsets.only(right: 70, top: 30),
                                            width:
                                                Responsive.isBigDesktop(context)
                                                    ? 600
                                                    : 500,
                                            height:
                                                Responsive.isBigDesktop(context)
                                                    ? 600
                                                    : 500,
                                            child: SvgPicture.asset(
                                                'assets/login_ilustrasi.svg',
                                                fit: BoxFit.contain),
                                          ),
                                          Container(
                                            // color: Colors.blue,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0, top: 15),
                                                  child: Container(
                                                    // color: Colors.yellow,
                                                    // height: 200,
                                                    // width: 620,
                                                    padding: EdgeInsets.zero,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 600,
                                                          child: Wrap(
                                                            children: [
                                                              Text(
                                                                'Kawan Lama Group',
                                                                style:
                                                                    TextStyle(
                                                                  // letterSpacing: 1,
                                                                  fontSize: 56,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      eerieBlack,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Visitor Invitation',
                                                                style:
                                                                    TextStyle(
                                                                  // letterSpacing: 1,
                                                                  fontSize: 56,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      eerieBlack,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 50, left: 15),
                                                  child: Container(
                                                    child: const Text(
                                                      'Please login using HC Plus for using the site',
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: onyxBlack,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 20,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15),
                                                        width: 300,
                                                        // height: 70,
                                                        child: InputField(
                                                          onSubmitted: (data) {
                                                            login(
                                                                context, model);
                                                          },
                                                          controller: _username,
                                                          label: 'Username',
                                                          focusNode:
                                                              userNameNode,
                                                          hintText:
                                                              'Username here...',
                                                          onSaved: (value) {
                                                            userName = value;
                                                          },
                                                          obsecureText: false,
                                                          validator: (value) =>
                                                              value == ""
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
                                                          onSubmitted: (data) {
                                                            login(
                                                                context, model);
                                                          },
                                                          controller: _password,
                                                          label: 'Password',
                                                          focusNode: passNode,
                                                          hintText:
                                                              'Password here...',
                                                          onSaved: (value) {
                                                            password = value;
                                                          },
                                                          obsecureText: true,
                                                          validator: (value) =>
                                                              value == ""
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
                                                  child: isLoading
                                                      ? CircularProgressIndicator(
                                                          color: eerieBlack,
                                                        )
                                                      : SizedBox(
                                                          width: 140,
                                                          height: 50,
                                                          //Tombol Login Desktop Layout
                                                          child: RegularButton(
                                                            title: 'Login',
                                                            sizeFont: 20,
                                                            onTap: () {
                                                              login(context,
                                                                  model);
                                                            },
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        // Container(),
                      ],
                    ),
                  ),
                ),
              );
            });
          }),
        ],
      ),
    );
  }

  Widget phoneLayout(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, child) {
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
                        padding: EdgeInsets.only(left: 0, top: 0),
                        width: 150,
                        height: 60,
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
                        top: 20,
                        left: 50,
                        right: 50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Container(
                          //   // color: Colors.amber,
                          //   // padding:
                          //   //     EdgeInsets.only(right: 70, top: 30),
                          //   width: 250,
                          //   height: 250,
                          // child:
                          SvgPicture.asset('assets/login_ilustrasi.svg',
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.65),
                          // ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                              top: 45,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
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
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: InputField(
                              onSubmitted: (data) {
                                login(context, model);
                              },
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
                            padding: const EdgeInsets.only(top: 20),
                            child: InputField(
                              onSubmitted: (data) {
                                login(context, model);
                              },
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
                            padding: const EdgeInsets.only(top: 40, bottom: 30),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: eerieBlack,
                                  )
                                : SizedBox(
                                    width: 110,
                                    height: 40,
                                    child: RegularButton(
                                      title: 'Login',
                                      sizeFont: 16,
                                      onTap: () {
                                        login(context, model);
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
                          child: Text(
                            'Facility Management 2022',
                            style: TextStyle(
                              color: spanishGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
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
      );
    });
  }
}
