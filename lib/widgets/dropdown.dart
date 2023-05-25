import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/constant/text_style.dart';
import 'package:navigation_example/responsive.dart';

class BlackDropdown extends StatelessWidget {
  BlackDropdown({
    required this.items,
    this.hintText,
    FocusNode? focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.value,
    this.customHeights,
  }) : focusNode = focusNode ?? FocusNode();

  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged? onChanged;
  final FormFieldValidator? validator;
  Widget? suffixIcon = Icon(Icons.keyboard_arrow_down_sharp);
  bool? enabled;
  final VoidCallback? onTap;
  final dynamic value;
  final List<double>? customHeights;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      buttonStyleData: const ButtonStyleData(
        width: 120,
        height: 39,
      ),
      // buttonWidth: 120,
      // buttonHeight: 39,
      value: value,
      focusNode: focusNode,
      // isExpanded: true,
      items: items,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sonicSilver,
            width: 1,
          ),
          color: culturedWhite,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: customHeights,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        // icon: suffixIcon,
      ),
      iconStyleData: IconStyleData(
        icon: suffixIcon!,
      ),
      // customItemsHeights: customHeights,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
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
        fillColor: enabled!
            ? focusNode!.hasFocus
                ? culturedWhite
                : Colors.transparent
            : platinum,
        filled: true,
        isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: Responsive.isDesktop(context) ? 16 : 14,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 0,
          bottom: 12,
        ),
        // suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
        enabled: enabled!,
      ),
      hint: Text(
        hintText!,
        style: helveticaText.copyWith(
          fontSize: Responsive.isDesktop(context) ? 16 : 14,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
      ),
      style: helveticaText.copyWith(
        fontSize: Responsive.isDesktop(context) ? 16 : 14,
        fontWeight: FontWeight.w300,
      ),
      validator: validator,
    );
  }
}

class SearchDropDown extends StatelessWidget {
  SearchDropDown({
    super.key,
    required List<DropdownMenuItem<String>>? items,
    required this.value,
    required this.onChanged,
    this.hintText = "Choose",
    this.suffixIcon,
    this.width = 300,
    this.validator,
    this.enabled = true,
    FocusNode? focusNode,
  })  : items = items ?? [],
        focusNode = focusNode ?? FocusNode();

  TextEditingController searchController = TextEditingController();
  List<DropdownMenuItem<String>> items;
  List<double>? customHeights;
  dynamic value;
  final FormFieldValidator? validator;
  ValueChanged? onChanged;
  String hintText;
  Widget? suffixIcon;
  double width;
  bool enabled;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      validator: validator,
      // isExpanded: true,
      iconStyleData: IconStyleData(
        icon: suffixIcon!,
      ),
      // hint: Text(
      //   hintText,
      //   style: const TextStyle(
      //     fontFamily: 'Helvetica',
      //     fontSize: 16,
      //     fontWeight: FontWeight.w300,
      //     color: sonicSilver,
      //   ),
      // ),
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontFamily: 'Helvetica',
      ),
      items: items,
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
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
        fillColor: enabled
            ? focusNode.hasFocus
                ? culturedWhite
                : Colors.transparent
            : platinum,
        filled: true,
        isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 0,
          bottom: 12,
        ),
        // suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      buttonStyleData: const ButtonStyleData(
        // width: width,
        height: 39,
      ),
      dropdownStyleData: DropdownStyleData(
        // width: width,
        maxHeight: 300,
        // padding: const EdgeInsets.symmetric(
        //   vertical: 20,
        //   horizontal: 15,
        // ),
        offset: const Offset(0, -5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sonicSilver,
            width: 1,
          ),
          color: culturedWhite,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: customHeights,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextFormField(
            expands: true,
            maxLines: null,
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 0,
              ),
              hintText: 'Search here ...',
              hintStyle: helveticaText.copyWith(fontSize: 12),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: davysGray,
                ),
              ),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          return (item.value.toString().toLowerCase().contains(searchValue));
        },
      ),
      //This to clear the search value when you close the menu
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          searchController.clear();
        }
      },
    );
  }
}

class TransparentDropdown extends StatelessWidget {
  TransparentDropdown({
    required this.items,
    this.hintText,
    FocusNode? focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.value,
    this.customHeights,
  }) : focusNode = focusNode ?? FocusNode();

  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged? onChanged;
  final FormFieldValidator? validator;
  Widget? suffixIcon = Icon(Icons.keyboard_arrow_down_sharp);
  bool? enabled;
  final VoidCallback? onTap;
  final dynamic value;
  final List<double>? customHeights;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      buttonStyleData: const ButtonStyleData(
        width: 50,
        height: 39,
      ),
      value: value,
      focusNode: focusNode,
      items: items,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sonicSilver,
            width: 1,
          ),
          color: culturedWhite,
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: customHeights,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        // icon: suffixIcon,
      ),
      customButton: Wrap(
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Text(
            value,
            style: helveticaText.copyWith(
              fontSize: Responsive.isDesktop(context) ? 16 : 14,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
            ),
          ),
          suffixIcon!,
        ],
      ),
      iconStyleData: IconStyleData(
        icon: suffixIcon!,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        fillColor: enabled!
            ? focusNode!.hasFocus
                ? culturedWhite
                : Colors.transparent
            : platinum,
        filled: true,
        isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: Responsive.isDesktop(context) ? 16 : 14,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 0,
          bottom: 12,
        ),
        // suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
        enabled: enabled!,
      ),
      hint: Text(
        hintText!,
        style: helveticaText.copyWith(
          fontSize: Responsive.isDesktop(context) ? 16 : 14,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
      ),
      style: helveticaText.copyWith(
        fontSize: Responsive.isDesktop(context) ? 16 : 14,
        fontWeight: FontWeight.w300,
      ),
      validator: validator,
    );
  }
}
