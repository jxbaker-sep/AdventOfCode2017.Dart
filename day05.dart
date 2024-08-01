import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final sample = parse(await getInput('day05.sample'));
  final data = parse(await getInput('day05'));
  group('Day 05', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(5)));
      test("Data", () => expect(do1(data), equals(359348)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample), equals(10)));
      test("Data", () => expect(do2(data), equals(27688760)));
    });
  });
}

int do2(List<int> input) {
  input = input.toList();
  var index = 0;
  for(final steps in xrange(0xFFFFFFFF)) {
    if (index < 0 || index >= input.length) return steps;
    final offset = input[index];
    final next = index + offset;
    input[index] += offset >= 3 ? -1 : 1;
    index = next;
  }
  throw Exception();
}

int do1(List<int> input) {
  input = input.toList();
  var index = 0;
  for(final steps in xrange(0xFFFFFFFF)) {
    if (index < 0 || index >= input.length) return steps;
    final next = index + input[index];
    input[index] += 1;
    index = next;
  }
  throw Exception();
}

List<int> parse(String s) => s.lines.map(int.parse).toList();