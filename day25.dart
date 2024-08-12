
import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/parse_utils.dart';
import 'utils/xrange.dart';

Future<void> main() async {
  final sample = parse(await getInput('day25.sample'));
  final data = parse(await getInput('day25'));
  group('Day 25', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(3)));
      test("Data", () => expect(do1(data), equals(4225)));
    });
  });
}

int do1(BluePrint bp) {
  Map<int, int> tape = {};
  var state = bp.states.where((s) => s.label == bp.initialState).single;
  var current = 0;
  for(final _ in xrange(bp.diagnosticChecksumAfter)) {
    final rule = state.rules[tape[current] ?? 0];
    tape[current] = rule.write;
    current += rule.move;
    state = bp.states.where((s) => s.label == rule.nextState).single;
  }
  return tape.values.sum;
}


BluePrint parse(String s) => bluePrintP.allMatches(s).single;

class Rule {
  final int write;
  final int move;
  final String nextState;

  Rule(this.write, this.move, this.nextState);
}

class State {
  final String label;
  final List<Rule> rules;

  State(this.label, Rule rule0, Rule rule1) : rules = [rule0, rule1];
}

class BluePrint {
  final String initialState;
  final int diagnosticChecksumAfter;
  final List<State> states = [];

  BluePrint(this.initialState, this.diagnosticChecksumAfter);
}

final bluePrintP = seq3(beginP, diagnosticP, statesP).map((m) {
  final bp = BluePrint(m.$1, m.$2);
  bp.states.addAll(m.$3);
  return bp;
});

final beginP = letter().trim().between('Begin in state', '.');
final diagnosticP = number.between('Perform a diagnostic checksum after', 'steps.');
final statesP = stateP.plus();
final stateP = seq3(stateNameP, ruleP, ruleP).map((m) => State(m.$1, m.$2, m.$3));
final stateNameP = letter().trim().between('In state', ':');
final ruleP = seq4(currentValueP, writeP, moveP, continueP).map((m) => Rule(m.$2, m.$3 == 'left' ? -1 : 1, m.$4));
final currentValueP = number.between('If the current value is', ':');
final writeP = number.between('- Write the value', '.');
final moveP = oneOf(['right', 'left']).between('- Move one slot to the', '.');
final continueP = letter().trim().between('- Continue with state', '.');