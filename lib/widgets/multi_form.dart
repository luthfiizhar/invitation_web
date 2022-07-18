import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/visitor.dart';
import 'package:navigation_example/widgets/input_visitor.dart';

class MultiVisitorFOrm extends StatefulWidget {
  MultiVisitorFOrm({Key? key, this.visitorModel, this.onRemove, this.index})
      : super(key: key);

  final index;
  Visitor? visitorModel;
  final Function? onRemove;
  final state = _MultiVisitorFOrmState();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  TextEditingController _email = TextEditingController();
  // bool isValidated() => state.validate();

  @override
  State<MultiVisitorFOrm> createState() => _MultiVisitorFOrmState();
}

class _MultiVisitorFOrmState extends State<MultiVisitorFOrm> {
  // final formKey = GlobalKey<FormState>();

  // bool isValidated() => state.validate();

  @override
  Widget build(BuildContext context) {
    int number = widget.index + 1;
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: 700,
      // color: Colors.blue,
      child: Column(
        children: [
          widget.index != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Divider(
                    thickness: 2,
                    color: spanishGray,
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Visitor Detail ' + number.toString(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                TextButton.icon(
                  onPressed: () {
                    widget.onRemove!();
                  },
                  icon: Icon(
                    Icons.close,
                    color: onyxBlack,
                  ),
                  label: Text(''),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: InputVisitor(
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      controller: widget._firstName,
                      label: 'First Name',
                      onSaved: (value) {
                        widget.visitorModel!.FirstName = value.toString();
                      },
                      // focusNode: firstNameNode,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: InputVisitor(
                      validator: (value) =>
                          value! == "" ? "This field is required" : null,
                      controller: widget._lastName,
                      label: 'Last Name',
                      onSaved: (value) {
                        widget.visitorModel!.LastName = value.toString();
                      },
                      // focusNode: lastNameNode,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Expanded(
                  // flex: 12,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Container(
                      child: InputVisitor(
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        controller: widget._email,
                        label: 'Email',
                        onSaved: (value) {
                          widget.visitorModel!.Email = value.toString();
                        },
                        // focusNode: emailNode,
                      ),
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

  // bool validate() {
  //   //Validate Form Fields
  //   bool validate = formKey.currentState.validate();
  //   if (validate) formKey.currentState.save();
  //   return validate;
  // }
}
