import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final sample = parse(await getInput('day06.sample'));
  final data = parse(await getInput('day06'));
  group('Day 06', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals((5,4))));
      test("Data", () => expect(do1(data), equals((12841, 8038))));
    });
  });
}

(int, int) do1(List<int> input) {
  input = input.toList();
  String key() => input.map((it) => '$it,').join();
  final closed = [key()];
  for(final x in xrange(0xFFFFFFFF)) {
    final (maxIndex, maxValue) = input.indexed.whereMax((a) => a.$2).first;
    input[maxIndex] = 0;
    final n = maxValue ~/ input.length;
    final r = maxValue % input.length;
    for(var k in xrange(input.length)) {
      var l = (maxIndex + 1 + k) % input.length;
      input[l] += n + (k < r ? 1 : 0);
    }
    final closedIndex = closed.indexOf(key());
    if (closedIndex >= 0) return (x + 1, x - closedIndex + 1);
    closed.add(key());
  }
  throw Exception();
}


List<int> parse(String s) => number.allMatches(s.lines.single).toList();

