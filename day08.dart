import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/parse_utils.dart';
import 'utils/string_extensions.dart';

Future<void> main() async {
  final sample = parse(await getInput('day08.sample'));
  final data = parse(await getInput('day08'));
  group('Day 08', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals((1, 10))));
      test("Data", () => expect(do1(data), equals((3880, 5035))));
    });
    group('Part 2', (){
    });
  });
}

(int, int) do1(List<Instruction> instructions) {
  final registers = instructions.flatmap((i) => [i.register, i.testRegister])
    .toSet().toMap((it) => it, (_) => 0);
  var highWaterMark = 0;
  for (final i in instructions) {
    if (i.testFunction(registers[i.testRegister]!)) {
      registers[i.register] = registers[i.register]! + i.increment;
      highWaterMark = [highWaterMark, registers[i.register]!].max;
    }
  }
  return (registers.values.max, highWaterMark);
}

class Instruction {
  final String register;
  final int increment;
  final String testRegister;
  final bool Function(int) testFunction;

  Instruction(this.register, this.increment, this.testRegister, this.testFunction);
}

List<Instruction> parse(String s) => s.lines.map((line) => instructionP.allMatches(line).single).toList();

final instructionP = seq4(lexical, incrementor, lexical.before('if'), testFunctionP)
  .map((m) => Instruction(m.$1, m.$2, m.$3, m.$4));
final incrementor = seq2(oneOf(["inc", "dec"]), number).map((m) => m.$1 == "inc" ? m.$2 : -m.$2);
final testFunctionP = [lteP, gteP, ltP, gtP, eqP, neP].toChoiceParser();
final ltP = number.before("<").map((m) => (int a) => a < m);
final lteP = number.before("<=").map((m) => (int a) => a <= m);
final gtP = number.before(">").map((m) => (int a) => a > m);
final gteP = number.before(">=").map((m) => (int a) => a >= m);
final eqP = number.before("==").map((m) => (int a) => a == m);
final neP = number.before("!=").map((m) => (int a) => a != m);
