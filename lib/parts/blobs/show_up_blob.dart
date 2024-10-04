import 'dart:async';

import 'package:flutter/material.dart';

class PopInBlob extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final double startOpacity;
  final double endOpacity;
  const PopInBlob(
      {super.key,
      this.startOpacity = 0,
      this.endOpacity = 1,
      required this.delay,
      this.duration = const Duration(milliseconds: 880),
      required this.child});

  @override
  State<PopInBlob> createState() => _PopInBlobState();
}

class _PopInBlobState extends State<PopInBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animScale;
  late Animation<double> _animOpacity;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: widget.duration);
    _animScale =
        Tween<double>(begin: 0, end: 1).animate(_animController);
    _animOpacity = Tween<double>(
            begin: widget.startOpacity, end: widget.endOpacity)
        .animate(_animController);
    Future<void>.delayed(Duration(milliseconds: widget.delay),
        () => _animController.forward());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animOpacity,
      child: ScaleTransition(
        filterQuality: FilterQuality.high,
        scale: _animScale,
        child: widget.child,
      ),
    );
  }
}

class SlideInBlob extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final Curve curve;
  final Offset startOffset;

  const SlideInBlob(
      {super.key,
      required this.child,
      required this.delay,
      this.startOffset = const Offset(0, 0.4),
      this.curve = Curves.easeInOut,
      this.duration = const Duration(milliseconds: 880)});

  @override
  State<SlideInBlob> createState() => _SlideInBlobState();
}

class _SlideInBlobState extends State<SlideInBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: widget.duration);
    final CurvedAnimation curve =
        CurvedAnimation(curve: widget.curve, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: widget.startOffset, end: Offset.zero)
            .animate(curve);
    Future<void>.delayed(Duration(milliseconds: widget.delay),
        () => _animController.forward());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
