import 'dart:collection';

import 'package:test/test.dart';

import 'day10.dart' show knotHash;
import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/position.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final sample = 'flqrgnkx';
  final data = (await getInput('day14')).lines.single;
  group('Day 14', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(8108)));
      test("Data", () => expect(do1(data), equals(8226)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample), equals(1242)));
      test("Data", () => expect(do2(data), equals(1128)));
    });
  });
}

final patterns = {
  '0': '0000', '1': '0001', '2': '0010', '3': '0011', '4': '0100', '5': '0101', '6': '0110', '7': '0111',
  '8': '1000', '9': '1001', 'a': '1010', 'b': '1011', 'c': '1100', 'd': '1101', 'e': '1110', 'f': '1111',
};

Set<Position> gridify(String key) => xrange(128)
  .flatmap((r) => knotHash('$key-$r').split('').flatmap((c) => patterns[c]!.split('')).indexed.where((c) => c.$2 == '1').map((c) => Position(c.$1, r)))
  .toSet();

int do1(String key) => gridify(key).length;

int do2(String key) {
  final grid = gridify(key);
  var regions = 0;
  while (grid.isNotEmpty) {
    regions += 1;
    var current = grid.first;
    grid.remove(current);
    final open = Queue<Position>.from([current]);
    while (open.isNotEmpty) {
      current = open.removeFirst();
      for (final n in current.orthogonalNeighbors().where((n) => grid.contains(n))) {
        grid.remove(n);
        open.add(n);
      }
    }
  }
  return regions;
}
