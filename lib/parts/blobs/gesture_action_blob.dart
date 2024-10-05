import 'package:flutter/material.dart';
import 'package:mortality_app/parts/blobs/gradient_blob.dart';
import 'package:mortality_app/shared.dart';

class SPECIFIC_GradientIntrinsicButtonBlob extends StatelessWidget {
  final String text;
  final IconData icon;
  final List<double> stops;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final void Function() onPressed;

  const SPECIFIC_GradientIntrinsicButtonBlob(
      {super.key,
      required this.text,
      required this.icon,
      this.begin = Alignment.topLeft,
      this.end = Alignment.bottomRight,
      this.stops = const <double>[0.25, 0.75],
      this.colors = const <Color>[kPoprockPrimary_2, kPoprockPrimary_1],
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GradientBlob(
      gradient:
          LinearGradient(begin: begin, end: end, stops: stops, colors: colors),
      child: IconButtonBlob(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Icon(icon, size: 44),
            ],
          ),
          onPressed: onPressed),
    );
  }
}

class IconButtonBlob extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final bool isDense;

  const IconButtonBlob(
      {super.key,
      required this.icon,
      this.isDense = true,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          foregroundColor: kForeground,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: kTertiary,
          visualDensity:
              isDense ? VisualDensity.compact : VisualDensity.standard,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRRectArc))),
      onPressed: onPressed,
      icon: icon,
    );
  }
}

class TextButtonBlob extends StatelessWidget {
  final String text;
  final TextStyle style;
  final void Function() onPressed;
  final Color bgColor;
  final bool isDense;
  final EdgeInsetsGeometry? padding;

  const TextButtonBlob(this.text,
      {super.key,
      this.style = const TextStyle(color: kBackground),
      this.isDense = true,
      this.padding,
      required this.onPressed})
      : bgColor = kForeground;

  const TextButtonBlob.primary(this.text,
      {super.key,
      this.style = const TextStyle(color: kBackground),
      this.isDense = false,
      this.padding,
      required this.onPressed})
      : bgColor = kPoprockPrimary_1;

  const TextButtonBlob.secondary(this.text,
      {super.key,
      this.isDense = false,
      this.padding,
      this.style = const TextStyle(color: kBackground),
      required this.onPressed})
      : bgColor = kPoprockPrimary_2;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          foregroundColor: kBackground,
          backgroundColor: bgColor,
          disabledBackgroundColor: kTertiary,
          disabledForegroundColor: kBackground,
          padding: padding,
          visualDensity:
              isDense ? VisualDensity.compact : VisualDensity.standard,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRRectArc))),
      onPressed: onPressed,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}
