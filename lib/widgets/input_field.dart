import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/text_style.dart';
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
      this.onSubmitted,
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
  final html.FunctionStringCallback? onSubmitted;
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
            Text(
              '${widget.label}',
              style: TextStyle(
                fontSize: Responsive.isDesktop(context) ? 20 : 14,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
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
            // cursorRadius: Radius.circular(5),
            // cursorHeight: 50,
            onFieldSubmitted: widget.onSubmitted,
            cursorColor: onyxBlack,
            focusNode: widget.focusNode,
            controller: widget.controller,
            onTap: () {
              // if (widget.focusNode!.hasFocus) {
              //   widget.focusNode!.unfocus();
              // } else {
              //   FocusScope.of(context).requestFocus(widget.focusNode);
              // }
            },
            onSaved: widget.onSaved,
            validator: widget.validator,
            // textAlign: TextAlign.center,
            // textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              hintText: widget.hintText,
              hintStyle: helveticaText.copyWith(
                fontSize: Responsive.isDesktop(context) ? 20 : 14,
                fontWeight: FontWeight.w400,
              ),
              // alignLabelWithHint: false,
              contentPadding: const EdgeInsets.only(
                  top: 17, bottom: 16, left: 20, right: 20),
              // isCollapsed: true,
              focusColor: onyxBlack,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: eerieBlack,
                    width: 2.5,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: eerieBlack,
                  width: 2.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: grayx11, width: 1),
              ),
              fillColor: white,
              filled: true,
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: eerieBlack, width: 2.5)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Color(0xFF929AAB), width: 2.5)),
              errorStyle: TextStyle(color: silver, fontSize: 14),
            ),
            style: TextStyle(
                fontSize: Responsive.isDesktop(context) ? 20 : 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF393E46)),
          ),
          // ),
        ),
      ],
    );
  }
}

class BlackInputField extends StatefulWidget {
  BlackInputField({
    required this.controller,
    this.hintText,
    FocusNode? focusNode,
    this.obsecureText = false,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
    this.maxLines = 1,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.fontSize = 16,
    this.textInputAction,
    this.inputFormatters,
    this.onEditingComplete,
    this.onChanged,
    this.prefixText = "",
    this.contentPadding =
        const EdgeInsets.only(right: 15, left: 15, top: 18, bottom: 15),
    Widget? prefix,
  })  : focusNode = focusNode ?? FocusNode(),
        prefix = prefix ?? SizedBox();

  final TextEditingController controller;
  final String? hintText;
  FocusNode? focusNode;
  final bool? obsecureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  final String prefixText;
  Widget? prefix;
  ValueChanged<String>? onFieldSubmitted;
  ValueChanged<String>? onChanged;
  int? maxLines;
  Widget? prefixIcon;
  VoidCallback? onEditingComplete;
  TextInputAction? textInputAction;
  double fontSize;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry contentPadding;

  @override
  State<BlackInputField> createState() => _BlackInputFieldState();
}

class _BlackInputFieldState extends State<BlackInputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: widget.focusNode!.hasFocus
            ? const [
                BoxShadow(
                  blurRadius: 40,
                  offset: Offset(0, 10),
                  // blurStyle: BlurStyle.outer,
                  color: Color.fromRGBO(29, 29, 29, 0.2),
                )
              ]
            : null,
      ),
      child: TextFormField(
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        mouseCursor: widget.enabled! ? null : SystemMouseCursors.click,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onSaved: widget.onSaved,
        enabled: widget.enabled,
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obsecureText!,
        cursorColor: eerieBlack,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        onTap: widget.onTap,
        decoration: InputDecoration(
          // prefix: widget.prefix!,
          prefixText: widget.prefixText,
          prefixStyle: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: eerieBlack,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: grayx11,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: davysGray,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: davysGray,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: grayx11,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: orangeAccent,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(
            color: orangeAccent,
            fontSize: 14,
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.clip,
          ),
          fillColor: widget.enabled!
              ? widget.focusNode!.hasFocus
                  ? culturedWhite
                  : Colors.transparent
              : platinum,
          filled: true,
          // isDense: true,
          isCollapsed: true,
          focusColor: culturedWhite,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
          contentPadding: widget.contentPadding,
          suffixIcon: widget.suffixIcon,
          suffixIconColor: eerieBlack,
          prefixIcon: widget.prefixIcon,
        ),
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
      ),
    );
  }
}
