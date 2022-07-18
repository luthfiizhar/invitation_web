import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/constant.dart';
import 'package:navigation_example/visitor.dart';
import 'package:navigation_example/widgets/multi_form.dart';
import 'package:navigation_example/widgets/regular_button.dart';

class AddVisitorOverlay extends ModalRoute<void> {
  AddVisitorOverlay({this.inviteCode});

  final String? inviteCode;
  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black.withOpacity(0.5);

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

  final _formKey = new GlobalKey<FormState>();
  List<Visitor> visitorList = [];

  List<MultiVisitorFOrm> formList = List.empty(growable: true);
  MultiVisitorFOrm? items;

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

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Container(
              width: 700,
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
                                'Add Visitor',
                                style: dialogTitle,
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: formList.length,
                            itemBuilder: (context, index) {
                              return formList[index];
                            },
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
                                    visitorModel: _visitorModel,
                                    index: formList.length,
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
                                _formKey.currentState!.save();
                                onSave();

                                var json = jsonEncode(visitorList);
                                // saveInviteVisitorData(json);
                                print(visitorList.toList());
                                // Navigator.pushNamed(context, routeConfiemInvite)
                                //     .then((value) {
                                //   setState(() {
                                //     visitorList.clear();
                                //     clearVisitorData();
                                //   });
                                // });
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
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
