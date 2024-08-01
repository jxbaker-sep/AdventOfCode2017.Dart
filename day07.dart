import 'package:collection/collection.dart';
import 'package:memoized/memoized.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final sample = parse(await getInput('day07.sample'));
  final data = parse(await getInput('day07'));
  group('Day 06', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals('tknk')));
      test("Data", () => expect(do1(data), equals('gmcrj')));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample), equals(60)));
      test("Data", () => expect(do2(data), equals(391)));
    });
  });
}

int do2(Map<String, Tower> towers) {
  final bottom = bottomTower(towers);
  Map<String, int> weights = {};
  getWeight(bottom, towers, weights);
  return findUnbalanced(bottom, towers, weights)!;
}

int? findUnbalanced(String tname, Map<String, Tower> towers, Map<String, int> weights) {
  final tower = towers[tname]!;
  if (tower.children.isEmpty) return null;
  if (tower.children.length == 1) return null;
  final ws = tower.children.map((c) => weights[c]!).toList();
  if (ws.every((it) => it == ws[0])) return null;
  if (tower.children.length == 2) {
    return findUnbalanced(tower.children[0], towers, weights) 
      ?? findUnbalanced(tower.children[1], towers, weights)
      ?? (throw Exception());
  }
  final temp = ws.groupFoldBy((it) => it, (int? p, _) => (p ?? 0) + 1);
  final single = temp.entries.where((it) => it.value == 1).single.key;
  final goalWeight = temp.entries.where((it) => it.value != 1).first.key;
  final unbalanced = tower.children.where((c) => weights[c] == single).single;
  final childUnbalanced = findUnbalanced(unbalanced, towers, weights);
  if (childUnbalanced != null) return childUnbalanced;
  return towers[unbalanced]!.weight - (weights[unbalanced]! - goalWeight);
}

class WeightFactory {
  final Map<String, Tower> towers;

  WeightFactory(this.towers);

  late final getWeight = Memoized1(_getWeightImpl);

  int _getWeightImpl(String c) {
    final t = towers[c]!;
    final result = t.weight + t.children.map((c2) => getWeight(c2)).sum;
    return result;
  }
}

int getWeight_old(String c, Map<String, Tower> towers, Map<String, int> weights) {
  if (weights[c] case int i) return i;
  final t = towers[c]!;
  final result = t.weight + t.children.map((c2) => getWeight(c2, towers, weights)).sum;
  weights[c] = result;
  return result;
}

Map<String, Tower> parse(String s) => s.lines.map((line) => towerP.allMatches(line).single).toMap((t) => t.name, (t) => t);

String do1(Map<String, Tower> towers) {
  return bottomTower(towers);
}

String bottomTower(Map<String, Tower> towers) {
  final ts = towers.keys.toSet();
  final supported = towers.values.flatmap((t) => t.children).toSet();
  return ts.difference(supported).single;
}

class Tower {
  final String name;
  final int weight;
  final List<String> children;

  Tower(this.name, this.weight, this.children);
}

final towerP = seq3(lexical, number.between('(', ')'), childrenP)
  .map((m) => Tower(m.$1, m.$2, m.$3));
final childrenP = seq2(lexical.before('->'), lexical.before(',').star()).optional()
  .map((m) => m == null ? <String>[] : ([m.$1] + m.$2));