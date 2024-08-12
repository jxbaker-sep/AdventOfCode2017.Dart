import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';

typedef Component = ({int left, int right});

Future<void> main() async {
  final sample = parse(await getInput('day24.sample'));
  final data = parse(await getInput('day24'));
  group('Day 24', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(31)));
      test("Data", () => expect(do1(data), equals(1940)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample), equals(19)));
      test("Data", () => expect(do2(data), equals(1928)));
    });
  });
}

int do1(List<Component> cs) {
  return chains(0, cs.toSet()).map((lc) => lc.map((c) => c.left + c.right).sum ).max;
}

int do2(List<Component> cs) {
  final set = chains(0, cs.toSet()).toList();
  final longest = set.map((it) => it.length).max;
  return set.where((it) => it.length == longest).map((lc) => lc.map((c) => c.left + c.right).sum ).max;
}

// note: as a partial optimization, does not return chains that could be longer.
Iterable<List<Component>> chains(int lhs, Set<Component> cs) sync* {
  bool any = false;
  for(final rhs in cs) {
    if (match(lhs, rhs) case int value) {
      any = true;
      yield* chains(value, cs.toSet()..remove(rhs)).map((chain) => chain..add(rhs));
    }
  }
  if (!any) yield [];
}

int? match(int lhs, Component rhs) {
  if (rhs.left == lhs) return rhs.right;
  if (rhs.right == lhs) return rhs.left;
  return null;
}

List<Component> parse(String s) => s.lines
  .map((line) => (left: int.parse(line.split('/')[0]), right: int.parse(line.split('/')[1])))
  .toList();