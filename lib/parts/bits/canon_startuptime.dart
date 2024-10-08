import 'package:flutter/material.dart';

class CanonicalStartupTimeNotifier extends ChangeNotifier {
  DateTime _startTime = DateTime.now();

  Duration get uptime => DateTime.now().difference(_startTime);

  void reset() {
    _startTime = DateTime.now();
    notifyListeners();
  }

  static final CanonicalStartupTimeNotifier instance =
      CanonicalStartupTimeNotifier();

  CanonicalStartupTimeNotifier._();

  factory CanonicalStartupTimeNotifier() => instance;
}
