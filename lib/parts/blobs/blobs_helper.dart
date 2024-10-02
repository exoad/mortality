import 'package:flutter/material.dart';
import 'package:mortality_app/shared.dart';

final class BlobsHelper {
  BlobsHelper._();

  static Alignment get randomAlignment =>
      Alignment(sRNG.nextDouble() * 2 - 1, sRNG.nextDouble() * 2 - 1);
}
