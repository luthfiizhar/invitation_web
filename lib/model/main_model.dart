import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  String? _listInvite = "";
  int? _indexDrawer = 0;
  String? _listVisitor = "";
  String _listDetailVisitor = "";

  String get listInvite => _listInvite!;
  String get listDetailVisitor => _listDetailVisitor;

  void setListDetailVisitor(String value) {
    _listDetailVisitor = value;
    notifyListeners();
  }

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
