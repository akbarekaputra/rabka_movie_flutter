import 'package:flutter/foundation.dart';

class IsVideoPlayProvider extends ChangeNotifier {
  bool _isVideoPlay = false;

  bool get isVideoPlay => _isVideoPlay;

  void setIsVideoPlay(bool value) {
    _isVideoPlay = !value;
    notifyListeners();
  }
}
