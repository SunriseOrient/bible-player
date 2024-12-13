import 'dart:math';

import 'package:flutter/widgets.dart';

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({required double begin, required double end, required this.delay})
      : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((sin((t - delay) * 2 * pi) + 1) / 2);
  }
}
