import 'dart:math';

extension NumExtension on num {
  double get toPi => (this * pi / 180);
}
