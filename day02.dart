import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/list_extensions.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';

Future<void> main() async {
  final data = parse(await getInput('day02'));
  group('Day 02', (){
    group('Part 1', (){
      test('Data', () => expect(do1(data), equals(53460)));
    });
    group('Part 2', (){
      test('Data', () => expect(do2(data), equals(282)));
    });
  });
}

int do2(List<List<int>> data) => 
  data.map((row) => row.pairs()
    .where((p) => p.max % p.min == 0)
    .map((p) => p.max ~/ p.min)
    .first
  ).sum;

int do1(List<List<int>> data) => data.map((row) => row.max -row.min).sum;

List<List<int>> parse(String s) => s.lines.map((line) => number.allMatches(line).toList()).toList();