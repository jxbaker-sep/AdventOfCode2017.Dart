

import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/position.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

typedef Grid = Map<Position, NodeState>;

enum NodeState {
  clean,
  weakened,
  infected,
  flagged
}

Future<void> main() async {
  final sample = parse(await getInput('day22.sample'));
  final data = parse(await getInput('day22'));
  group('Day 22', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample, 10000), equals(5587)));
      test("Data", () => expect(do1(data, 10000), equals(5552)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample, 10000000), equals(2511944)));
      test("Data", () => expect(do2(data, 10000000), equals(2511527))); // 2512521 too high
    });
  });
}

int do1(Grid grid, int bursts) {
  grid = grid.entries.toMap((it) => it.key, (it) => it.value);
  var current = grid.keys.map((k) => k.y).max == 2 ? Position(1,1) : Position(12,12);
  var v = Vector.North;
  var count = 0;
  for(final _ in xrange(bursts)) {
    final state = grid[current] ?? NodeState.clean;
    v = switch (state) {
      NodeState.clean => v.rotateLeft(),
      NodeState.infected => v.rotateRight(),
      _ => throw Exception()
    };
    if (state == NodeState.infected) {
      grid[current] = NodeState.clean;
    } else {
      grid[current] = NodeState.infected;
      count += 1;
    }
    current += v;
  }
  return count;
}

int do2(Grid grid, int bursts) {
  grid = grid.entries.toMap((it) => it.key, (it) => it.value);
  var current = grid.keys.map((k) => k.y).max == 2 ? Position(1,1) : Position(12,12);
  var v = Vector.North;
  var count = 0;
  for(final _ in xrange(bursts)) {
    final state = grid[current] ?? NodeState.clean;
    v = switch (state) {
      NodeState.clean => v.rotateLeft(),
      NodeState.infected => v.rotateRight(),
      NodeState.weakened => v,
      NodeState.flagged => v.rotateLeft().rotateLeft()
    };
    grid[current] = switch (state) {
      NodeState.clean => NodeState.weakened,
      NodeState.weakened => NodeState.infected,
      NodeState.infected => NodeState.flagged,
      NodeState.flagged => NodeState.clean
    };
    if (grid[current]! == NodeState.infected) count += 1;
    current += v;
  }
  return count;
}

Grid parse(String s) => s.lines.indexed
  .flatmap((row) => row.$2.split('').indexed.map((col) => (col.$1, row.$1, col.$2)))
  .toMap((it) => Position(it.$1, it.$2), (it) => it.$3 == '#' ? NodeState.infected : NodeState.clean);