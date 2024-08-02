import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/position.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final data = int.parse(await getInput('day03'));
  group('Day 03', (){
    group('Part 1', (){
      test("Sample 1", () => expect(do1(1), equals(0)));
      test("Sample 2", () => expect(do1(2), equals(1)));
      test("Sample 3", () => expect(do1(3), equals(2)));
      test("Sample 4", () => expect(do1(4), equals(1)));
      test("Sample 5", () => expect(do1(5), equals(2)));
      test("Sample 6", () => expect(do1(6), equals(1)));
      test("Sample 7", () => expect(do1(7), equals(2)));
      test("Sample 8", () => expect(do1(8), equals(1)));
      test("Sample 9", () => expect(do1(9), equals(2)));
      test("Sample 10", () => expect(do1(10), equals(3)));
      test("Sample 11", () => expect(do1(11), equals(2)));
      test("Sample 12", () => expect(do1(12), equals(3)));
      test("Sample 13", () => expect(do1(13), equals(4)));
      test("Sample 14", () => expect(do1(14), equals(3)));
      test("Sample 15", () => expect(do1(15), equals(2)));
      test("Sample 16", () => expect(do1(16), equals(3)));
      test("Sample 17", () => expect(do1(17), equals(4)));
      test("Sample 18", () => expect(do1(18), equals(3)));
      test("Sample 19", () => expect(do1(19), equals(2)));
      test("Sample 20", () => expect(do1(20), equals(3)));
      test("Sample 21", () => expect(do1(21), equals(4)));
      test("Sample 22", () => expect(do1(22), equals(3)));
      test("Sample 23", () => expect(do1(23), equals(2)));
      test("Sample 24", () => expect(do1(24), equals(3)));
      test("Sample 25", () => expect(do1(25), equals(4)));
      test("Sample 1024", () => expect(do1(1024), equals(31)));
      test("Data", () => expect(do1(data), equals(430)));
    });
    group('Part 2', (){
      test('Data', () => expect(do2(data), equals(312453)));
    });
  });
}

int do2(int input) {
  final grid = <Position, int>{Position.Zero: 1};
  for(final (temp) in squareSpiral().skip(1)) {
    final p = temp.p;
    final value = p.neighbors().map((n) => grid[n]).whereType<int>().sum;
    if (value > input) return value;
    grid[p] = value;
  }
  throw Exception();
}

Iterable<({Position p, int value})> squareSpiral() sync* {
  var current = Position.Zero;
  var value = 1;
  yield (p: current, value: value++);
  current += Vector.East;
  for(final shell in xrange(0xFFFF).skip(1)) {
    for(final (v, delta) in [(Vector.North, -1), (Vector.West, 0), (Vector.South, 0), (Vector.East, 1)]) {
      for(final _ in xrange(2 * shell + delta)) {
        yield (p: current, value: value++);
        current += v;
      }
    }
  }
}

// Position findGridPosition(int input) {
//   final sqrtCiel = sqrt(input).ceil();
//   final shellWidth = sqrtCiel.isEven ? sqrtCiel + 1 : sqrtCiel;
//   final n = (shellWidth-1) ~/ 2;
//   final previousShellWidth = (shellWidth-2) * (shellWidth-2);
//   final x = shellWidth == 1 ? 0 : (input - previousShellWidth) % (shellWidth - 1);
//   final shellMax = shellWidth * shellWidth;

//   if (input == shellMax) return Position(n, n);
//   if (input >= shellMax - n * 2) return Position(n - n * 2 + x, n);
//   if (input >= shellMax - n * 4) return Position(n - n * 2, n - n * 2 + x);
//   if (input >= shellMax - n * 6) return Position(n - x, n - n * 2);
//   return Position(n, n - x);
// }

// int do1(int value) => findGridPosition(value).manhattanDistance();
int do1(int value) => squareSpiral().skip(value-1).first.p.manhattanDistance();
