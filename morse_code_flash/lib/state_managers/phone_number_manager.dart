import 'package:flutter/cupertino.dart';

class PhoneNumberManager extends ChangeNotifier {
  String _phoneNumber = '';

  String get phoneNumber => _phoneNumber;

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }
}