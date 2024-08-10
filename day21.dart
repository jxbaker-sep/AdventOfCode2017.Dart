
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/list_extensions.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';


Future<void> main() async {
  final sample = parse(await getInput('day21.sample'));
  final data = parse(await getInput('day21'));
  final grid = '''.#.
..#
###'''.split('\n').toList();
  group('Day 21', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample, grid.toList(), 2), equals(12)));
      test("Data", () => expect(do1(data, grid.toList(), 5), equals(179)));
    });
    group('Part 2', (){
      test("Data", () => expect(do1(data, grid.toList(), 18), equals(2766750)));
    });
  });
}

int do1(Map<String, String> tileMap, List<String> grid, final int iterations) {
  for (final _ in xrange(iterations)) {
    final tiles = segmentize(grid).toList();
    final mapped = mapTiles(tileMap, tiles).toList();
    grid = joinTiles(mapped);
  }
  return grid.map((s) => s.split('').where((it) => it == '#').length).sum;
}

Map<String, String> parse(String s) {
  Map<String, String> result = {};
  for (final line in s.lines) {
    final [pattern, enhancement] = line.split("=>").map((it) => it.trim()).toList();
    for(final a in [ pattern, verticalFlip(pattern) ]) {
      for (final b in [ a, rotate(a), rotate(rotate(a)), rotate(rotate(rotate(a))) ]) {
        result[b] = enhancement;
      }
    }
  }
  return result;
}

String verticalFlip(String s) {
  final split = s.split('/').toList();
  return split.reversed.join("/");
}

String rotate(String s) {
  final split = s.split('/').map((line) => line.split('')).toList();
  return split.rotateRight().map((line) => line.join()).join("/");
}

Iterable<String> mapTiles(Map<String, String> tileMap, Iterable<String> tiles) =>
  tiles.map((tile) => tileMap[tile]!);

Iterable<String> segmentize(List<String> grid) sync* {
  final size = grid.length.isEven ? 2 : 3;

  for(var y = 0; y < grid.length; y += size) {
    for(var x = 0; x < grid.length; x += size) {
      yield grid.skip(y).take(size).map((line) => line.substring(x, x + size)).join('/');
    }
  }
}

List<String> joinTiles(List<String> tiles) {
  final split = tiles.map((s) => s.split('/')).toList();
  final tileSize = split[0].length;

  final sq = sqrt(tiles.length).ceil();
  final gridSize = sq * tileSize;
  final result = Iterable.generate(gridSize, (_) => "").toList();

  // if (sqrt(tiles.length) != sqrt(tiles.length).ceil()) throw Exception("Not a perfect square! + ${tiles..length}");
  for (final (index, tile) in split.indexed) {
    final y = index ~/ sq;
    for(final f in xrange(tileSize)) {
      result[y * tileSize + f] += tile[f];
    }
  }

  return result;
}