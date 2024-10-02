import 'dart:math';

import 'package:flutter/material.dart';

const String kCanonicalAppIdentifier = "net.exoad:mortality_app";
const String kLoggerName = "net.exoad";

const double kRRectArc = 6;
const Color kBackground = Colors.black;
const Color kForeground = Colors.white;
const Color kTertiary = Color.fromARGB(255, 172, 172, 172);
const Color kPoprockPrimary_1 = Color.fromARGB(255, 255, 38, 103);
const Color kPoprockPrimary_2 = Color.fromARGB(255, 250, 185, 22);
const Color kError = Color.fromRGBO(255, 0, 0, 1);
const String kStylizedFontFamily = "Playfair Display";
const String kDefaultFontFamily = "Montserrat";
const int kMaxCharsUserName = 20;
final Random sRNG = Random();

final class SharedLocaleChar {
  SharedLocaleChar._();

  static const String diamondOutlinedCenteredDot = "⟐";
}
