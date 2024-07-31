import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';

Future<void> main() async {
  final data = parse(await getInput('day04'));
  group('Day 03', (){
    group('Part 1', (){
      test("Data", () => expect(do1(data), equals(386)));
    });
    group('Part 2', (){
      test("Data", () => expect(do2(data), equals(208)));
    });
  });
}

bool isValidPassphrase(List<String> s) => s.toSet().length == s.length;

int do1(List<List<String>> data) => data.where(isValidPassphrase).length;

int do2(List<List<String>> data) => data.map((pf) => pf.map((s) => (s.split('')..sort()).join('')).toList()).where(isValidPassphrase).length;


List<List<String>> parse(String s) => s.lines.map((line) => lexical.allMatches(line).toList()).toList();