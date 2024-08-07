
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/position.dart';
import 'utils/string_extensions.dart';


Future<void> main() async {
  final sample = parse(await getInput('day19.sample'));
  final data = parse(await getInput('day19'));
  group('Day 19', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(('ABCDEF', 38))));
      test("Data", () => expect(do1(data), equals(('DWNBGECOMY', 0))));
    });
    group('Part 2', (){
    });
  });
}

(String, int) do1(Map<Position, String> grid) {
  var p = grid.entries.where((e) => e.value == '|' && e.key.y == 0).single.key;
  var v = Vector.South;
  var result = '';
  int steps = 0;
  while (grid[p] != null) {
    steps += 1;
    final c = grid[p]!;
    // print('$p $c');
    if (!['+', '-', '|'].contains(c)) {
      result += c;
    } else if (c == '+') {
      if (!isLegal(v, grid[p + v])) {
        if (isLegal(v.rotateLeft(), grid[p + v.rotateLeft()])) {
          v = v.rotateLeft();
        }
        else if (isLegal(v.rotateRight(), grid[p + v.rotateRight()])) {
          v = v.rotateRight();
        }
        else {throw Exception();}
      }
    }
    p += v;
  }

  return (result, steps);
}

bool isLegal(Vector v, String? c) {
  if (c == null) return false;
  if (v == Vector.East || v == Vector.West) return c != '|';
  return c != '-';
}

Map<Position, String> parse(String s) =>
  s.split('\n').indexed.flatmap((r) => r.$2.split('').indexed.map((c) => (c.$1, r.$1, c.$2)))
  .where((it) => it.$3 != ' ')
  .toMap((it) => Position(it.$1, it.$2), (it) => it.$3);