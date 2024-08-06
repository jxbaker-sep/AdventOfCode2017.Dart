
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/lle.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';


Future<void> main() async {
  final data = int.parse((await getInput('day17')).lines.single);
  group('Day 17', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(3, 2017), equals(638)));
      test("Data", () => expect(do1(data, 2017), equals(1506)));
    });
    group('Part 2', (){
      test("Data", () => expect(do2(data, 50000000), equals(39479736)));
    });
  });
}

int do2(final int steps, final int iterations) {
  int afterZero = 0;
  var currentLength = 1;
  var current = 0;
  while (currentLength <= iterations) {
    final remaining = currentLength - current;
    if (remaining > steps) {
      final n = (remaining ~/ steps) - (remaining % steps == 0 ? 1 : 0);
      currentLength += n;
      current += n * steps + n;
      continue;
    }
    current = (current + steps) % currentLength;
    if (current == 0) {
      afterZero = currentLength;
    }
    currentLength += 1;
    current += 1;
  }
  return afterZero;
}

int do1(int steps, int iterations) {
  final ll = LinkedList<LLE<int>>();
  ll.add(LLE<int>(0));
  var current = ll.first;
  for(final i in xrange(iterations)) {    
    current = current.advanceWrap(steps);
    current.insertAfter(LLE<int>(i+1));
    current = current.next!;
  }
  return current.advanceWrap(1).value;
}