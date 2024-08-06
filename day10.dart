import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final data = (await getInput('day10')).lines.single.split(',').map(int.parse).toList();
  final data2 = (await getInput('day10')).lines.single;
  group('Day 10', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(5, [3, 4, 1, 5]), equals(12)));
      test("Data", () => expect(do1(256, data), equals(40132)));
    });
    group('Part 2', (){
      test("Sample 1", () => expect(knotHash(''), equals('a2582a3a0e66e6e86e3812dcb672a272')));
      test("Sample 2", () => expect(knotHash('AoC 2017'), equals('33efeb34ea91902bb2f59c9920caa6cd')));
      test("Sample 3", () => expect(knotHash('1,2,3'), equals('3efbe78a8d82f29979031a4aa0b16a9d')));
      test("Sample 4", () => expect(knotHash('1,2,4'), equals('63960835bcdc130f0b66d7ff4f6a5a8e')));
      test("Sample 4", () => expect(knotHash(data2), equals('35b028fe2c958793f7d5a61d07a008c8')));
    });
  });
}

List<int> parse2(String s) => (s.lines.firstOrNull ?? '').codeUnits + [17, 31, 73, 47, 23];

String knotHash(String key) {
  final lengths = key.codeUnits + [17, 31, 73, 47, 23];
  return do2(256, lengths);
}

String do2(int knots, List<int> lengths) {
  var result = xrange(knots).toList();
  var first = 0;
  for(final i in xrange(64)) {
    (result, first) = do_(result, lengths, lengths.length * i, first, i == 63);
  }

  final dense = <int>[];
  for(final i in xrange(16)) {
    dense.add(result.sublist(i * 16, (i+1) * 16).reduce((a,b) => a ^ b));
  }

  return dense.map((it) => it.toRadixString(16).padLeft(2, '0')).join();
}

int do1(int knots, List<int> lengths) {
  var result = xrange(knots).toList();
  result = do_(result, lengths, 0, 0, true).$1;
  return result[0] * result[1];
}

(List<int>, int) do_(List<int> input, List<int> lengths, int skipSize, int first, bool uncut) {
  input = input.toList();
  final knots = input.length;
  for(final length in lengths) {
    input.reverseRange(0, length);
    first = (first - (length + skipSize)) % knots;
    final cut = (length + skipSize++) % knots;
    input = input.sublist(cut) + input.sublist(0, cut);
  }
  if (uncut) return (input.sublist(first) + input.sublist(0, first), 0);
  return (input, first);
}