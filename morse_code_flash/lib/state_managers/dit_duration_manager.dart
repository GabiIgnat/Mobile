import 'package:flutter/cupertino.dart';

class DitDurationManager extends ChangeNotifier {
  int _ditDurationMs = 500;

  int get ditDurationMs => _ditDurationMs;

  void setDitDurationMs(int value) {
    _ditDurationMs = value;
    notifyListeners();
  }
}