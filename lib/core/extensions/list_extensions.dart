import 'package:flutter/material.dart';

extension ListExtensions<T> on List<T> {
  int get max3 => length > 3 ? 3 : length;

  Column toColumn({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: map((e) => e as Widget).toList(),
    );
  }
}
