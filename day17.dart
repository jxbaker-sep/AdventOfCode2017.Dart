
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

int do2(int steps, int iterations) {
  int afterZero = 0;
  var currentLength = 1;
  var current = 0;
  // while (currentLength <= iterations) {
  //   final wrapInNSteps = [((currentLength - current) / steps).ceil(), iterations - currentLength + 1].min;
  //   final insertDex = (current + steps * wrapInNSteps) % (currentLength + wrapInNSteps - 1);
  //   if (insertDex == 0) {
  //     afterZero = currentLength + wrapInNSteps - 1;
  //     print(afterZero);
  //   }
  //   currentLength += wrapInNSteps;
  //   current = (insertDex + 1) % currentLength;
  // }
  // return afterZero;
  for(final value in xrange(iterations)) {
    current = (current + steps) % currentLength;
    if (current == 0) {
      afterZero = value + 1;
    }
    current += 1;
    currentLength += 1;
  }
  
  return afterZero;
}

int do1(int steps, int iterations) {
  final ll = LinkedList<LLE<int>>();
  ll.add(LLE<int>(0));
  var xx = -1;
  var current = ll.first;
  for(final i in xrange(iterations)) {    
    current = current.advanceWrap(steps);
    current.insertAfter(LLE<int>(i+1));
    current = current.next!;
    if (xx != ll.first.next!.value) {xx = ll.first.next!.value; print(xx);}
  }
  return current.advanceWrap(1).value;
}