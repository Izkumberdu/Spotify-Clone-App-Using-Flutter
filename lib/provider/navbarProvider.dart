import 'package:flutter/material.dart';

class NavbarProvider extends ChangeNotifier {
  int currentIndex;

  NavbarProvider({this.currentIndex = 0});

  void changeIndex({required int newIndex}) async {
    currentIndex = newIndex;
    notifyListeners();
  }
}
