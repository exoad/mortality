import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazySlideInBlob extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final Curve curve;
  final Offset startOffset;

  const LazySlideInBlob(
      {super.key,
      required this.child,
      required this.delay,
      this.startOffset = const Offset(0, 0.4),
      this.curve = Curves.easeInOut,
      this.duration = const Duration(milliseconds: 880)});

  @override
  State<LazySlideInBlob> createState() => _LazySlideInBlobState();
}

class _LazySlideInBlobState extends State<LazySlideInBlob>
    with TickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(hashCode.toRadixString(16)),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          Future<void>.delayed(Duration(milliseconds: widget.delay),
              () {
            if (mounted) {
              _animController.forward();
            }
          });
        }
      },
      child: FadeTransition(
        opacity: _animController,
        child: SlideTransition(
          position: _animOffset,
          child: widget.child,
        ),
      ),
    );
  }
}
