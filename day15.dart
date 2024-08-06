
import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';


Future<void> main() async {
  final sample = [65, 8921];
  final data = (await getInput('day15')).lines.single.split(',').map(int.parse).toList();
  group('Day 15', (){
    group('Part 1', (){
      test("Sample 1", () => expect(do1(sample, 5), equals(1)));
      test("Sample 2", () => expect(do1(sample, 40 * 1000 * 1000), equals(588)));
      test("Data", () => expect(do1(data, 40 * 1000 * 1000), equals(567)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample, 5 * 1000 * 1000), equals(309)));
      test("Data", () => expect(do2(data, 5 * 1000 * 1000), equals(323)));
    });
  });
}

int do1(List<int> generators, int runs) {
  generators = generators.toList();
  var count = 0;
  for(final _ in xrange(runs)) {
    generators[0] = (generators[0] * 16807) % 2147483647;
    generators[1] = (generators[1] * 48271) % 2147483647;
    if (generators[0] & 0xFFFF == generators[1] & 0xFFFF) count += 1;
  }
  return count;
}

Iterable<int> createGenerator(int initial, int mul, int mod) sync* {
  var current = initial;
  for(final _ in xrange(0xFFFFFFFF)) {
    current = (current * mul) % 2147483647;
    if (current % mod == 0) yield current;
  }
}

int do2(List<int> input, int runs) {
  var count = 0;
  for(final result in IterableZip([createGenerator(input[0], 16807, 4), createGenerator(input[1], 48271, 8)]).take(runs)) {
    if (result[0] & 0xFFFF == result[1] & 0xFFFF) count += 1;
  }
  return count;
}