import 'package:flutter/material.dart';

abstract class Versioned {
  int get version;
}

abstract class TestView extends StatelessWidget {
  final String testViewName;

  const TestView({super.key, required this.testViewName});

  @override
  Widget build(BuildContext context);
}
