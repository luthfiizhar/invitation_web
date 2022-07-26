import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
// import 'package:google_fonts/google_fonts.dart';

class InputField extends StatefulWidget {
  // const InputField({Key? key}) : super(key: key);
  InputField(
      {required this.controller,
      required this.label,
      this.width,
      this.height,
      this.focusNode,
      this.keyboardType,
      this.validator,
      this.onSaved,
      this.hintText,
      this.obsecureText,
      Key? key});

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final double? width;
  final double? height;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool? obsecureText;
  // final String? validator;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  // final GlobalKey? formKey;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.controller.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '${widget.label}',
                style: TextStyle(
                    fontSize: Responsive.isDesktop(context) ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: TextFormField(
            obscureText: widget.obsecureText!,
            key: widget.key,
            keyboardType: widget.keyboardType,
            cursorColor: onyxBlack,
            focusNode: widget.focusNode,
            controller: widget.controller,
            onTap: () {
              if (widget.focusNode!.hasFocus) {
                widget.focusNode!.unfocus();
              } else {
                FocusScope.of(context).requestFocus(widget.focusNode);
              }
            },
            onSaved: widget.onSaved,
            validator: widget.validator,
            // textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: Responsive.isDesktop(context) ? 20 : 18,
                fontWeight: FontWeight.w400,
              ),
              alignLabelWithHint: true,
              contentPadding:
                  EdgeInsets.only(top: 21, bottom: 17, left: 30, right: 30),
              // isCollapsed: true,
              focusColor: onyxBlack,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: eerieBlack,
                    width: 2.5,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: eerieBlack,
                  width: 2.5,
                ),
              ),
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
              errorStyle: TextStyle(color: silver, fontSize: 18),
            ),
            style: TextStyle(
                fontSize: Responsive.isDesktop(context) ? 20 : 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF393E46)),
          ),
          // ),
        ),
      ],
    );
  }
}
