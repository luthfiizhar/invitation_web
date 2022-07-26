import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  String? _listInvite = "";
  int? _indexDrawer = 0;
  String? _listVisitor = "";

  String get listInvite => _listInvite!;

  set listInvite(String value) {
    // if (value != _listInvite) {
    _listInvite = value;
    notifyListeners();
    // }
  }

  int get indexDrawer => _indexDrawer!;

  void setIndexDrawer(int value) {
    _indexDrawer = value;
    notifyListeners();
  }

  String get listVisitor => _listVisitor!;
}
