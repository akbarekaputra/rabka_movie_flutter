import 'package:flutter/foundation.dart';

class IsVidPlayProvider extends ChangeNotifier {
  bool _isVidPlay = false;

  bool get isVidPlay => _isVidPlay;

  void setIsVidPlay(bool value) {
    _isVidPlay = !value;
    notifyListeners();
  }
}
