import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  String? _listInvite = "";
  int? _indexDrawer = 0;
  String? _listVisitor = "";
  String _listDetailVisitor = "";
  bool _isExpired = true;
  String _jwt = "";
  String _pageRoute = "/";
  bool _isLoggedIn = false;

  String get listInvite => _listInvite!;
  String get listDetailVisitor => _listDetailVisitor;
  bool get isExpired => _isExpired;
  String get jwt => _jwt;
  String get pageRoute => _pageRoute;
  bool get isLoggedIn => _isLoggedIn;

  bool _shadowActive = false;
  bool _isScrolling = false;
  bool _isScrollAtEdge = false;
  double _scrollPosition = 0;
  bool _upBottonVisible = false;

  bool get shadowActive => _shadowActive;
  bool get isScrolling => _isScrolling;
  bool get isScrollAtEdge => _isScrollAtEdge;
  double get scrollPosition => _scrollPosition;
  bool get upBottonVisible => _upBottonVisible;

  void setIsScrollAtEdge(bool value) {
    _isScrollAtEdge = value;
    notifyListeners();
  }

  void setScrollPosition(double value) {
    _scrollPosition = value;
    notifyListeners();
  }

  void setIsScrolling(bool value) {
    _isScrolling = value;
    notifyListeners();
  }

  void setShadowActive(bool value) {
    _shadowActive = value;
    notifyListeners();
  }

  void setUpBotton(bool value) {
    _upBottonVisible = value;
    notifyListeners();
  }

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setPageRoute(String value) {
    _pageRoute = value;
    notifyListeners();
  }

  void setIsExpired(bool value) {
    _isExpired = value;
    notifyListeners();
  }

  void setJwt(String value) {
    _jwt = value;
    notifyListeners();
  }

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
