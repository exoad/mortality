import 'dart:async';

import 'package:flutter/material.dart';

class FadeInBlob extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  const FadeInBlob(
      {super.key,
      required this.child,
      required this.delay,
      this.duration = const Duration(milliseconds: 880)});

  @override
  State<FadeInBlob> createState() => _FadeInBlobState();
}

class _FadeInBlobState extends State<FadeInBlob>
    with TickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: widget.duration);
    Timer(Duration(milliseconds: widget.delay),
        _animController.forward);
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: widget.child,
    );
  }
}
