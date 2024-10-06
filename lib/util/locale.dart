const double kLargeDouble = 10000000.0;
const int kExponentialFractionalBit = 2;
const int kFractionalBit = 2;
final RegExp trailingZeros = RegExp(r"([.]*0)(?!.*\d)");

extension LocaleDouble on double {
  String L_formatLargeDouble([double cutoff = kLargeDouble]) =>
      this >= kLargeDouble
          ? toStringAsExponential(kExponentialFractionalBit)
          : toString().replaceAll(trailingZeros, "");
}
