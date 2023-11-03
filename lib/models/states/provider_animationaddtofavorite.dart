import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProviderAnimationAddToFavorite with ChangeNotifier {
  bool _hideAnimation = false;

  bool get getStateAnimation => _hideAnimation;

  set stateAnimation(bool value) {
    _hideAnimation = value;
  }

  void changeStateAnimation() {
    _hideAnimation = !_hideAnimation;
    notifyListeners();
  }
}