import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/parse_utils.dart';

Future<void> main() async {
  final data = parse(await getInput('day09'));
  group('Day 09', (){
    group('Part 1', (){
      test("Sample", () => expect(parse('{}').score(), equals(1)));
      test("Sample", () => expect(parse('{{{}}}').score(), equals(6)));
      test("Sample", () => expect(parse('{{},{}}').score(), equals(5)));
      test("Sample", () => expect(parse('{{{},{},{{}}}}').score(), equals(16)));
      test("Sample", () => expect(parse('{<a>,<a>,<a>,<a>}').score(), equals(1)));
      test("Sample", () => expect(parse('{{<ab>},{<ab>},{<ab>},{<ab>}}').score(), equals(9)));
      test("Sample", () => expect(parse('{{<!!>},{<!!>},{<!!>},{<!!>}}').score(), equals(9)));
      test("Sample", () => expect(parse('{{<a!>},{<a!>},{<a!>},{<ab>}}').score(), equals(3)));
      test("Data", () => expect(data.score(), equals(17390)));
    });
    group('Part 2', (){
      test("Sample 1", () => expect(parse('{<>}').countGarbage(), equals(0)));
      test("Sample 2", () => expect(parse('{<random characters>}').countGarbage(), equals(17)));
      test("Sample 3", () => expect(parse('{<<<<>}').countGarbage(), equals(3)));
      test("Sample 4", () => expect(parse('{<{!>}>}').countGarbage(), equals(2)));
      test("Sample 5", () => expect(parse('{<!!>}').countGarbage(), equals(0)));
      test("Sample 6", () => expect(parse('{<!!!>>}').countGarbage(), equals(0)));
      test("Sample 7", () => expect(parse('{<{o"i!a,<{i<a>}').countGarbage(), equals(10)));
      test("Data", () => expect(data.countGarbage(), equals(7825)));
    });
  });
}

Group parse(String s) {
  final m = ExpressionDefinition();
  final x = m.build();
  return x.allMatches(s).single as Group;
}

class Group {
  final List<Group> subgroups;
  final List<String> garbage;

  Group(this.subgroups, this.garbage);

  int score([int base = 0]) => (base + 1) + subgroups.map((sg) => sg.score(base + 1)).sum;
  int countGarbage() => garbage.map((m) => m.length).sum + subgroups.map((m) => m.countGarbage()).sum;
}

class ExpressionDefinition extends GrammarDefinition {
  @override
  Parser<Group> start() => ref0(groupP).end();
  Parser<Group> groupP() => ref0(groupContentsP).between('{', '}').map((m) => Group(m.whereType<Group>().toList(), m.whereType<String>().toList()));
  Parser<List<Object>> groupContentsP() => seq2(groupOrGarbage(), groupOrGarbage().before(',').star()).optional()
    .map((m) => m == null ? [] : ([m.$1] + m.$2));
  Parser<Object> groupOrGarbage() => choice2(groupP(), garbageP());
  Parser<String> garbageP() => garbageContentsP().between('<', '>').map((m) => m);
  Parser<String> garbageContentsP() => choice2(any().before("!").map((_) => ''), seq2(string(">").not(), any()).map((m) => m.$2)).star()
    .map((m) => m.join());
}
