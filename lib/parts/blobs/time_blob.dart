import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mortality_app/parts/blobs/blobs_helper.dart';
import 'package:mortality_app/shared.dart';
import 'package:mortality_app/util/chronos.dart';

enum DateSimplificationMethod { firstThreeLetters, monthNum, fullMonthName }

class TimeBlob extends StatefulWidget {
  final TextStyle timeStyle;
  final TextStyle dateStyle;
  final bool showSeconds;
  final bool showDate;
  final TextAlign vertAlign;
  final DateSimplificationMethod dateSimplificationMethod;

  const TimeBlob(
      {super.key,
      this.showSeconds = true,
      this.showDate = true,
      this.vertAlign = TextAlign.left,
      this.dateSimplificationMethod = DateSimplificationMethod.fullMonthName,
      this.dateStyle = const TextStyle(color: kForeground, fontSize: 12),
      this.timeStyle = const TextStyle(
          color: kForeground,
          fontSize: 24,
          textBaseline: TextBaseline.alphabetic,
          fontWeight: FontWeight.w900)});

  @override
  State<TimeBlob> createState() => _TimeBlobState();
}

class _TimeBlobState extends State<TimeBlob> {
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    Timer.periodic(
        widget.showSeconds
            ? const Duration(seconds: 1)
            : const Duration(minutes: 1),
        (_) => setState(() => _now = DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: <InlineSpan>[
        TextSpan(
            text:
                "${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}",
            style: widget.timeStyle),
        if (widget.showSeconds)
          TextSpan(
              text: ":${_now.second.toString().padLeft(2, '0')}",
              style: widget.timeStyle),
        const NLSpan(),
        if (widget.showDate)
          TextSpan(
              text: """${switch (widget.dateSimplificationMethod) {
            DateSimplificationMethod.firstThreeLetters =>
              CanonicalMonths.values[_now.month].monthName.substring(0, 4),
            DateSimplificationMethod.monthNum =>
              _now.month.toString().padLeft(2, '0'),
            DateSimplificationMethod.fullMonthName =>
              CanonicalMonths.values[_now.month].monthName
          }}${widget.dateSimplificationMethod == DateSimplificationMethod.monthNum ? "/" : " "}${_now.day}${widget.dateSimplificationMethod == DateSimplificationMethod.monthNum ? "/" : ", "}${_now.year}""",
              style: widget.dateStyle),
      ]),
      textAlign: widget.vertAlign,
    );
  }
}