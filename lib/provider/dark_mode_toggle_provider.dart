import 'package:flutter/foundation.dart';

class DarkModeToggleProvider extends ChangeNotifier {
  bool _darkModeToggleValue = false;

  bool get toggleValue => _darkModeToggleValue;

  void setToggleValue(bool value) {
    _darkModeToggleValue = value;
    notifyListeners();
  }
}
