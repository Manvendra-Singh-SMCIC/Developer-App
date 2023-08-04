import 'package:flutter/material.dart';

class PageRebuilder extends ChangeNotifier {
  bool shouldRebuild = false;

  void rebuildPage() {
    shouldRebuild = true;
    notifyListeners();
  }
}
