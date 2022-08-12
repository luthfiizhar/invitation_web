import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:navigation_example/constant/color.dart';
import 'package:navigation_example/responsive.dart';
import 'package:navigation_example/routes/routes.dart';
import 'package:navigation_example/visitor.dart';
import 'package:navigation_example/widgets/footer.dart';
import 'package:navigation_example/widgets/multi_form.dart';
import 'package:navigation_example/widgets/navigation_bar.dart';
import 'package:navigation_example/widgets/regular_button.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  int visitorLength = 1;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  TextEditingController _email = TextEditingController();

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode startDateNode = FocusNode();
  FocusNode endDateNode = FocusNode();
  FocusNode emailNode = FocusNode();

  bool endDateEnable = false;

  String? startDate;
  String? endDate;
  DateTime? startDateOriginal;

  final _formKey = new GlobalKey<FormState>();
  List<Visitor> visitorList = [];
  Visitor? _visitorModel = Visitor(number: 1);

  List<MultiVisitorFOrm> formList = List.empty(growable: true);
  List<MultiVisitorFOrmMobile> formListMobile = List.empty(growable: true);
  MultiVisitorFOrm? items;

  Future saveInviteVisitorData(var items) async {
    var box = await Hive.openBox('inputvisitorBox');
    box.put('listInvite', items ?? "");
    box.put('startDate', startDate ?? "");
    box.put('endDate', endDate ?? "");

    var name;
    name = box.get('listInvite');
    var date;
    date = box.get('startDate');
  }

  @override
  void initState() {
    super.initState();
    formList.add(MultiVisitorFOrm(
      index: 0,
      onRemove: onRemove,
      visitorModel: _visitorModel,
    ));
  }

  Future clearVisitorData() async {
    var box = await Hive.openBox('visitorBox');
    box.delete('listInvite');
    box.delete('startDate');
    box.delete('endDate');
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isDesktop(context)
        ? desktopLayoutInvitePage(context)
        : mobileLayoutInvitePage(context);
  }

  onRemove(Visitor visitor) {
    setState(() {
      _visitorModel = Visitor(number: 1);
      int index =
          formList.indexWhere((element) => element.index == visitor.number);

      if (formList != null) formList.removeAt(index);
    });
  }

  onSave() {
    bool allValid = true;
    print(formList);

    for (int i = 0; i < formList.length; i++) {
      items = formList[i];
      visitorList.add(Visitor(
          FirstName: items!.visitorModel!.FirstName,
          LastName: items!.visitorModel!.LastName,
          Email: items!.visitorModel!.Email));
    }
  }

  Future _selectStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate != "" ? DateTime.now() : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: eerieBlack, // <-- SEE HERE
              onPrimary: silver, // <-- SEE HERE
              onSurface: eerieBlack, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: eerieBlack, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String formattedDate = DateFormat('d MMMM yyyy').format(picked!);
    if (picked != null)
      setState(() {
        _startDate.text = formattedDate;
        startDateOriginal = picked;
      });
  }

  Future _selectDate(
      TextEditingController controller, DateTime startDate) async {
    // if (startDate != "") {
    // DateFormat format = DateFormat();
    // var start = DateTime.tryParse(startDate);
    print(startDate.toString());
    // }

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: eerieBlack, // <-- SEE HERE
              onPrimary: silver, // <-- SEE HERE
              onSurface: eerieBlack, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: eerieBlack, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String formattedDate = DateFormat('d MMMM yyyy').format(picked!);
    if (picked != null)
      setState(() {
        controller.text = formattedDate;
      });
    // if (startDate == "") String startDateOriginal = picked.toString();
  }

  Widget inputDateContainer() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      // width: 700,
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Visitation Start',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: eerieBlack),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      enabled: true,
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      cursorColor: onyxBlack,
                      focusNode: startDateNode,
                      controller: _startDate,
                      onChanged: (_) {},
                      onTap: () {
                        _selectStartDate().then((value) {
                          print(_startDate.text);
                          setState(() {
                            endDateEnable = true;
                          });
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          startDate = _startDate.text;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintText: 'Click here to select start date',
                        hintStyle: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 20 : 14,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: Responsive.isDesktop(context)
                            ? const EdgeInsets.only(
                                top: 17,
                                bottom: 15,
                                left: 20,
                                right: 20,
                              )
                            : const EdgeInsets.only(
                                top: 16,
                                bottom: 17,
                                left: 20,
                                right: 20,
                              ),
                        focusColor: onyxBlack,
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.isDesktop(context) ? 10 : 7),
                            borderSide: const BorderSide(
                              color: eerieBlack,
                              width: 2.5,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.isDesktop(context) ? 10 : 7),
                            borderSide: const BorderSide(
                                color: eerieBlack, width: 2.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.isDesktop(context) ? 10 : 7),
                            borderSide: const BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        fillColor: graySand,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.isDesktop(context) ? 10 : 7),
                            borderSide: const BorderSide(
                                color: eerieBlack, width: 2.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.isDesktop(context) ? 10 : 7),
                            borderSide: const BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        errorStyle: TextStyle(
                            color: orangeRed,
                            fontSize: Responsive.isDesktop(context) ? 18 : 14),
                      ),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF393E46)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Visitation End',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: eerieBlack),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      enabled: endDateEnable,
                      validator: (value) =>
                          value == "" ? "This field is required" : null,
                      cursorColor: onyxBlack,
                      focusNode: endDateNode,
                      controller: _endDate,
                      onTap: () {
                        _selectDate(_endDate, startDateOriginal!);
                      },
                      onSaved: (value) {
                        endDate = _endDate.text;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintText: 'Click here to select end date',
                        hintStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 17, bottom: 15, left: 20, right: 20),
                        focusColor: onyxBlack,
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: eerieBlack,
                              width: 2.5,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: eerieBlack, width: 2.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        fillColor: graySand,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: eerieBlack, width: 2.5)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFF929AAB), width: 2.5)),
                        errorStyle: TextStyle(color: orangeRed, fontSize: 18),
                      ),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF393E46)),
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

  Widget desktopLayoutInvitePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarWeb(
                index: 0,
              ),
              Padding(
                padding: Responsive.isBigDesktop(context)
                    ? const EdgeInsets.only(top: 5, left: 350, right: 350)
                    : const EdgeInsets.only(top: 5, left: 350, right: 350),
                child: Container(
                  // color: Colors.orange,
                  width: Responsive.isBigDesktop(context) ? 650 : 650,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.blue,
                        // padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.amber,
                              child: const Text(
                                'Invite Visitor',
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                // height: 56,
                                // color: Colors.green,
                                child: Wrap(
                                  children: const [
                                    Text(
                                      'Please fill visitor\'s name & email below. We will send them an email to complete their data.',
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
                      Container(
                        // color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 10),
                              child: Container(
                                // color: Colors.amber,
                                width: 650,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            inputDateContainer(),
                                          ],
                                        ),
                                      ),
                                      formList.length > 0
                                          ? const Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Divider(
                                                thickness: 2,
                                                color: spanishGray,
                                              ),
                                            )
                                          : const SizedBox(),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: formList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              // color: Colors.lightBlue,
                                              child: formList[index]);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _visitorModel =
                                    Visitor(number: formList.length);

                                formList.add(MultiVisitorFOrm(
                                  index: formList.length,
                                  visitorModel: _visitorModel,
                                  onRemove: () {
                                    onRemove(_visitorModel!);
                                  },
                                ));
                              });
                            },
                            icon: const Icon(
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                onSave();
                                print('visitorList');
                                print(visitorList);
                                var json = jsonEncode(visitorList);
                                saveInviteVisitorData(json);
                                print(visitorList.toList());
                                Navigator.pushNamed(context, routeConfiemInvite)
                                    .then((value) {
                                  setState(() {
                                    visitorList.clear();
                                    clearVisitorData().then((value) {
                                      setState(() {});
                                    });
                                  });
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
        ),
      ],
    );
  }

  Widget inputDateContainerMobile() {
    return Column(
      children: [
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Visitation Start',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: eerieBlack),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                // height: 50,
                padding: EdgeInsets.zero,
                child: TextFormField(
                  keyboardType: TextInputType.none,
                  validator: (value) =>
                      value == "" ? "This field is required" : null,
                  cursorColor: onyxBlack,
                  focusNode: startDateNode,
                  controller: _startDate,
                  onChanged: (_) {
                    setState(() {
                      endDateEnable = true;
                    });
                  },
                  onTap: () {
                    // FocusScope.of(context)
                    //     .requestFocus(new FocusNode());
                    _selectStartDate();
                  },
                  onSaved: (value) {
                    setState(() {
                      startDate = _startDate.text;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    hintText: 'Click here to select start date',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 17, bottom: 17, left: 20, right: 20),
                    focusColor: onyxBlack,
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: eerieBlack,
                          width: 2.5,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide:
                            const BorderSide(color: eerieBlack, width: 2.5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                            color: Color(0xFF929AAB), width: 2.5)),
                    fillColor: graySand,
                    filled: true,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: eerieBlack, width: 2.5)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(0xFF929AAB), width: 2.5)),
                    errorStyle: TextStyle(color: orangeRed, fontSize: 14),
                  ),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF393E46)),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Visitation End',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: eerieBlack),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  // height: 50,
                  padding: EdgeInsets.zero,
                  child: TextFormField(
                    enabled: endDateEnable,
                    keyboardType: TextInputType.none,
                    validator: (value) =>
                        value == "" ? "This field is required" : null,
                    cursorColor: onyxBlack,
                    focusNode: endDateNode,
                    controller: _endDate,
                    onTap: () {
                      // FocusScope.of(context)
                      //     .requestFocus(new FocusNode());
                      _selectDate(_endDate, startDateOriginal!);
                    },
                    onSaved: (value) {
                      endDate = _endDate.text;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      hintText: 'Click here to select end date',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: const EdgeInsets.only(
                          top: 17, bottom: 17, left: 20, right: 20),
                      focusColor: onyxBlack,
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: eerieBlack,
                            width: 2.5,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide:
                              const BorderSide(color: eerieBlack, width: 2.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: Color(0xFF929AAB), width: 2.5)),
                      fillColor: graySand,
                      filled: true,
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide:
                              const BorderSide(color: eerieBlack, width: 2.5)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              color: Color(0xFF929AAB), width: 2.5)),
                      errorStyle: TextStyle(color: orangeRed, fontSize: 14),
                    ),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF393E46)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileLayoutInvitePage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              NavigationBarMobile(),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 35, right: 35),
                child: Container(
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Invite Visitor',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 40,
                          child: Wrap(
                            children: const [
                              Text(
                                'Please fill visitor\'s name & email below. We will send them an email to complete their data.',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: onyxBlack),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: inputDateContainerMobile(),
                            ),
                            formList.length > 0
                                ? const Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Divider(
                                      thickness: 2,
                                      color: spanishGray,
                                    ),
                                  )
                                : const SizedBox(),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: formList.length,
                              itemBuilder: (context, index) {
                                return formList[index];
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _visitorModel =
                                    Visitor(number: formList.length);

                                formList.add(MultiVisitorFOrm(
                                  index: formList.length,
                                  visitorModel: _visitorModel,
                                  onRemove: () {
                                    onRemove(_visitorModel!);
                                  },
                                ));
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20, bottom: 30),
                      //   child: Center(
                      //     child: ImageIcon(
                      //       AssetImage('assets/Add.png'),
                      //       size: 35,
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          // width: 275,
                          child: RegularButton(
                            title: 'Next',
                            sizeFont: 16,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                onSave();

                                var json = jsonEncode(visitorList);
                                saveInviteVisitorData(json);
                                print(visitorList.toList());
                                Navigator.pushNamed(context, routeConfiemInvite)
                                    .then((value) {
                                  setState(() {
                                    visitorList.clear();
                                    clearVisitorData().then((value) {
                                      setState(() {});
                                    });
                                  });
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
}
