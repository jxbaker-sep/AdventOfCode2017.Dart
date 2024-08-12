import 'dart:math';

import 'utils/xrange.dart';

void main() {
  var rng = Random();
  final samples = 100000;
  final purchases = 12;
  var hits = xrange(13).map((_) => 0).toList();
  for (final _ in xrange(samples)) {
    final l = xrange(purchases).map((_) => rng.nextInt(12)).toSet();
    hits[l.length] += 1;
  }
  print(hits.map((h) => h / samples).toList());
}