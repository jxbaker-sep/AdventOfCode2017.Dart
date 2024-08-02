import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/position.dart';
import 'utils/string_extensions.dart';

Future<void> main() async {
  final data = parse(await getInput('day11'));
  group('Day 11', (){
    group('Part 1', (){
      test("Sample 1", () => expect(do1(parse('ne,ne,ne')), equals(3)));
      test("Sample 2", () => expect(do1(parse('ne,ne,sw,sw')), equals(0)));
      test("Sample 3", () => expect(do1(parse('ne,ne,s,s')), equals(2)));
      test("Sample 4", () => expect(do1(parse('se,sw,se,sw,sw')), equals(3)));
      test("Data", () => expect(do1(data), equals(675)));
    });
    group('Part 2', (){
      test("Data", () => expect(do2(data), equals(1424)));
    });
  });
}

int do1(List<Vector> input) => hexattanDistance(input.fold(Position.Zero, (p, c) => p + c));
int do2(List<Vector> input) => input.fold((Position.Zero, 0), (p, c) => (p.$1 + c, [p.$2, hexattanDistance(p.$1 + c)].max)).$2;

List<Vector> parse(String s) => s.lines.single.split(',')
  .map((item) => switch (item) {
    'n' => Hex.north,
    's' => Hex.south,
    'ne' => Hex.northEast,
    'nw' => Hex.northWest,
    'se' => Hex.southEast,
    'sw' => Hex.southWest,
    _ => throw Exception()
  }).toList();

class Hex {
  static final north = Vector(0, -2);
  static final south = Vector(0, 2);
  static final northWest = Vector(-1, -1);
  static final northEast = Vector(1, -1);
  static final southWest = Vector(-1, 1);
  static final southEast = Vector(1, 1);
}

int hexattanDistance(Position p) {
  final x = p.x.abs();
  final y = (p.y.abs() - x) ~/ 2;
  return x + y;
}