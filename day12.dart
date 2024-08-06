import 'dart:collection';

import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/string_extensions.dart';

Future<void> main() async {
  final sample = parse(await getInput('day12.sample'));
  final data = parse(await getInput('day12'));
  group('Day 12', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(6)));
      test("Data", () => expect(do1(data), equals(134)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample), equals(2)));
      test("Data", () => expect(do2(data), equals(193)));
    });
  });
}

int do1(Map<int, List<int>> items) => findGroup(0, items).length;

int do2(Map<int, List<int>> items) {
  final allItems = items.entries.flatmap((it) => [it.key] + it.value).toSet();
  var count = 0;
  while (allItems.isNotEmpty) {
    count += 1;
    final current = allItems.first;
    final group = findGroup(current, items);
    allItems.removeAll(group);
  }
  return count;
} 


Set<int> findGroup(int including, Map<int, List<int>> items) {
  final open = Queue<int>()..add(including);
  final closed = <int>{including};
  while (open.isNotEmpty) {
    final current = open.removeFirst();
    for(final next in items[current] ?? <int>{}) {
      if (!closed.add(next)) continue;
      open.add(next);
    }
  }
  return closed;
}

Map<int, List<int>> parse(String s) => s.lines.map((line) {
  final x = line.split('<->');
  final key = int.parse(x[0]);
  final values = x[1].split(',').map(int.parse).toList();
  return (key, values);
}).toMap((it) => it.$1, (it) => it.$2);