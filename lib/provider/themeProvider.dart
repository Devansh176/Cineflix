import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isDarkMode = true;
  bool getTheme() => _isDarkMode;

  void updateTheme({required bool value}) {
    _isDarkMode = value;
    notifyListeners();
  }
}