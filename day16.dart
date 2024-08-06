
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/function_extensions.dart';
import 'utils/input.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';
import 'utils/xrange.dart';


Future<void> main() async {
  final sample = parse(await getInput('day16.sample'));
  final data = parse(await getInput('day16'));
  group('Day 16', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample, 'abcde', 1), equals('baedc')));
      test("Data", () => expect(do1(data, 'abcdefghijklmnop', 1), equals('iabmedjhclofgknp')));
    });
    group('Part 2', (){
      test("Data", () => expect(do1(data, 'abcdefghijklmnop', 1000000000), equals('oildcmfeajhbpngk')));
      // alopgdjeibhmfcnk -- wrong
    });
  });
}

String do1(List<ListManipFunction> functions, String initial, int count) {
  Map<String, int> cache = {};
  var current = initial.split('');
  for(final i in xrange(count)) {
    final key = current.join();
    if (cache[key] case int index) {
      var runLength = i - index;
      var remainder = (count - i) % runLength;
      return cache.entries.where((e) => e.value == index + remainder).first.key;
    }
    cache[key] = i;
    current = functions.fold(current, (p, fct) => fct(p));
  }
  return current.join();
}

typedef ListManipFunction = List<String> Function(List<String>);

List<ListManipFunction> parse(String s) => s.lines.single.split(',').map((it) => matcherP.allMatches(it).single).toList();

List<String> spin(int n, List<String> input) => input.sublist(input.length - n) + input.sublist(0, input.length - n);
List<String> swapIndex(int a, int b, List<String> input) {
  final result = input.toList();
  result[a] = input[b];
  result[b] = input[a];
  return result;
}
List<String> swapLabel(String a, String b, List<String> input) {
  final x = input.indexOf(a);
  final y = input.indexOf(b);
  return swapIndex(x, y, input);
}

final matcherP = [spinP, swapIndexP, swapLabelP].toChoiceParser();
final spinP = number.before('s').map((n) => apply1(spin, n));
final swapIndexP = seq2(number.before('x'), number.before('/')).map((a) => apply2(swapIndex, a.$1, a.$2));
final swapLabelP = seq2(letter().before('p'), letter().before('/')).map((a) => apply2(swapLabel, a.$1, a.$2));