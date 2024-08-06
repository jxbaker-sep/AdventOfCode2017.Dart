import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final sample = parse(await getInput('day13.sample'));
  final data = parse(await getInput('day13'));
  group('Day 13', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(24)));
      test("Data", () => expect(do1(data), equals(2688)));
    });
    group('Part 2', (){
      test("Sample", () => expect(do2(sample), equals(10)));
      test("Sample", () => expect(do2(data), equals(3876272)));
    });
  });
}

// Returns all
Iterable<int> combineOrdered(Iterable<int> a, Iterable<int> b) sync* {
  final ait = a.iterator;
  final bit = b.iterator;
  if (!ait.moveNext() || !bit.moveNext()) return;
  var av = ait.current;
  var bv = bit.current;
  while (true) {
    if (av == bv) {
      yield av;
      if (!ait.moveNext() || !bit.moveNext()) return;
      av = ait.current;
      bv = bit.current;
    } else if (av < bv) {
      if (!ait.moveNext()) return;
      av = ait.current;
    } else {
      if (!bit.moveNext()) return;
      bv = bit.current;
    }
  }
}

Iterable<int> iterate(Scanner s) => xrange(0xFFFFFFFF)
  .where((n) => (s.index + n) % ((s.range-1)*2) != 0);

int do2(List<Scanner> ss) => ss.skip(1).fold(
  iterate(ss[0]),
  (p, c) => combineOrdered(p, iterate(c))
).first;

int do1(List<Scanner> ss) => ss.where((s) => s.index % ((s.range-1)*2) == 0)
  .map((s) => s.index * s.range).sum;

typedef Scanner = ({int index, int range});

List<Scanner> parse(String s) => s.lines.map((m) { 
  final t = m.split(':');
  return (index: int.parse(t[0]), range: int.parse(t[1]));
}).toList();