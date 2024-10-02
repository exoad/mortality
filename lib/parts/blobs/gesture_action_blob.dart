import 'package:flutter/material.dart';
import 'package:mortality_app/shared.dart';

class TextButtonBlob extends StatelessWidget {
  final String text;
  final TextStyle style;
  final void Function() onPressed;
  final Color bgColor;

  const TextButtonBlob(this.text,
      {super.key,
      this.style = const TextStyle(color: kBackground),
      required this.onPressed})
      : bgColor = kForeground;

  const TextButtonBlob.primary(this.text,
      {super.key,
      this.style = const TextStyle(color: kBackground),
      required this.onPressed})
      : bgColor = kPoprockPrimary_1;

  const TextButtonBlob.secondary(this.text,
      {super.key,
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
          visualDensity: VisualDensity.compact,
          splashFactory: NoSplash.splashFactory,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kRRectArc))),
      onPressed: onPressed,
      child: Text(text, style: style),
    );
  }
}
