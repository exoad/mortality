import 'dart:ui';

import 'package:mortality_app/shared.dart';

List<double> generateLinearStops1(int count) =>
    List<double>.generate(count, (int index) => index / (count - 1));

Offset generateRandomOffset({required Offset min, required Offset max}) => Offset(
    min.dx + sRNG.nextDouble() * (max.dx - min.dx),
    min.dy + sRNG.nextDouble() * (max.dy - min.dy));
