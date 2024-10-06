import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mortality_app/parts/blobs/blobs_helper.dart';
import 'package:mortality_app/shared.dart';
import 'package:mortality_app/util/extern/extern_time.dart';
import 'package:mortality_app/util/locale.dart';

import '../core/mortality_core.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(children: <Widget>[_SimpleInfoStats()]))),
    );
  }
}

class _SimpleInfoStats_StatField extends StatefulWidget {
  final List<({String Function() title, String subtitle})> items;

  _SimpleInfoStats_StatField({required this.items}) : assert(items.isNotEmpty);

  @override
  State<_SimpleInfoStats_StatField> createState() =>
      _SimpleInfoStats_StatFieldState();
}

class _SimpleInfoStats_StatFieldState
    extends State<_SimpleInfoStats_StatField> {
  // assume that the first and second index are as follows: minutes, and hours
  static const int _minutesIndex = 0;
  late Timer _minutesTimer;

  int _i = 2;

  @override
  void initState() {
    super.initState();
    _minutesTimer = Timer(const Duration(minutes: 1), () {
      if (_i == _minutesIndex && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _minutesTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int newI = _i + 1 >= widget.items.length ? 0 : _i + 1;
        setState(() => _i = newI);
      },
      child: Text.rich(
        TextSpan(children: <InlineSpan>[
          TextSpan(
              text: widget.items[_i].title(),
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: kStylizedFontFamily)),
          const NLSpan(),
          TextSpan(
              text: widget.items[_i].subtitle,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: kTertiary,
                  fontFamily: kDefaultFontFamily))
        ]),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SimpleInfoStats extends StatelessWidget {
  const _SimpleInfoStats();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      const SizedBox(width: 12),
      _SimpleInfoStats_StatField(items: <({
        String Function() title,
        String subtitle
      })>[
        (
          title: () => kMC_MockBirthDate.toDuration.inMinutes
              .toDouble()
              .L_formatLargeDouble(),
          subtitle: "Minutes alive"
        ),
        (
          title: () => kMC_MockBirthDate.toDuration.inHours
              .toDouble()
              .L_formatLargeDouble(),
          subtitle: "Hours alive"
        ),
        (
          title: () => kMC_MockBirthDate.toDuration.inDays
              .toDouble()
              .L_formatLargeDouble(),
          subtitle: "Days alive"
        ),
        (
          title: () => kMC_MockBirthDate.toDuration.inWeeks.toStringAsFixed(1),
          subtitle: "Weeks alive"
        ),
        (
          title: () => kMC_MockBirthDate.toDuration.inMonths.toStringAsFixed(1),
          subtitle: "Months alive"
        ),
        (
          title: () => kMC_MockBirthDate.toDuration.inYears.toStringAsFixed(1),
          subtitle: "Years alive"
        ),
      ]),
      const SizedBox(width: 12),
      Expanded(child: _TotalCountdown()),
      const SizedBox(width: 12),
      _SimpleInfoStats_StatField(
          items: <({String Function() title, String subtitle})>[
            (
              title: () =>
                  (kMC_DefaultLifeExpectancy - kMC_MockBirthDate.toDuration)
                      .inMinutes
                      .toDouble()
                      .L_formatLargeDouble(),
              subtitle: "Minutes left"
            ),
            (
              title: () =>
                  (kMC_DefaultLifeExpectancy - kMC_MockBirthDate.toDuration)
                      .inHours
                      .toDouble()
                      .L_formatLargeDouble(),
              subtitle: "Hours left"
            ),
            (
              title: () =>
                  (kMC_DefaultLifeExpectancy - kMC_MockBirthDate.toDuration)
                      .inDays
                      .toDouble()
                      .L_formatLargeDouble(),
              subtitle: "Days left"
            ),
            (
              title: () =>
                  (kMC_DefaultLifeExpectancy - kMC_MockBirthDate.toDuration)
                      .inWeeks
                      .toStringAsFixed(1),
              subtitle: "Weeks left"
            ),
            (
              title: () =>
                  (kMC_DefaultLifeExpectancy - kMC_MockBirthDate.toDuration)
                      .inMonths
                      .toStringAsFixed(1),
              subtitle: "Months left"
            ),
            (
              title: () =>
                  (kMC_DefaultLifeExpectancy - kMC_MockBirthDate.toDuration)
                      .inYears
                      .toStringAsFixed(1),
              subtitle: "Years left"
            ),
          ]),
      const SizedBox(width: 12),
    ]);
  }
}

class _TotalCountdown extends StatefulWidget {
  @override
  State<_TotalCountdown> createState() => _TotalCountdownState();
}

class _TotalCountdownState extends State<_TotalCountdown> {
  late Duration _whatsLeft;

  @override
  void initState() {
    super.initState();
    _whatsLeft =
        MC_RawExpectedDeath(kMC_MockBirthDate).difference(DateTime.now());
    Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() => _whatsLeft =
            MC_RawExpectedDeath(kMC_MockBirthDate).difference(DateTime.now())));
  }

  @override
  Widget build(BuildContext context) {
    int s = _whatsLeft.inSeconds;
    int h = s ~/ 3600;
    s %= 3600;
    int m = s ~/ 60;
    s %= 60;
    return Text.rich(
        TextSpan(children: <InlineSpan>[
          TextSpan(
              text: h.toString().padLeft(2, "0"),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ":"),
          TextSpan(
              text: m.toString().padLeft(2, "0"),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: ":"),
          TextSpan(
              text: s.toString().padLeft(2, "0"),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24));
  }
}
