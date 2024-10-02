import 'package:flutter/material.dart';

class GradientTextBlob extends StatelessWidget {
  const GradientTextBlob(
    this.text, {
    this.blendMode = BlendMode.srcIn,
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final BlendMode blendMode;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: blendMode,
      shaderCallback: (Rect bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class GradientBlob extends StatelessWidget {
  const GradientBlob({
    required this.child,
    this.blendMode = BlendMode.srcIn,
    super.key,
    required this.gradient,
  });

  final Widget child;
  final BlendMode blendMode;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: blendMode,
      shaderCallback: (Rect bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}