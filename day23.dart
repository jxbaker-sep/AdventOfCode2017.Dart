import 'dart:collection';

import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/parse_utils.dart';


Future<void> main() async {
  final data = matcherP.onePerLine(await getInput('day23'));
  group('Day 23', (){
    group('Part 1', (){
      test("Data", () => expect(do1(data), equals(8281)));
    });
    group('Part 2', (){
      // see input repo for part 2 solution
    });
  });
}

int do1(List<IInstruction> instructions) {
  Registers r = {};
  int pc = 0;
  var result = 0;
  while (pc >= 0 && pc < instructions.length) {
    final instr = instructions[pc];
    pc += instr.operate(r);
    if (instr is MulInstruction) result += 1;
  }
  return result;
}

typedef Registers = Map<String, int>;


abstract class RValue {
  int resolve(Registers r);
}

class IntRValue extends RValue {
  final int _value;

  @override
  int resolve(Registers _) => _value;

  IntRValue(this._value);
}

class RegisterRValue extends RValue {
  final String _r;

  @override
  int resolve(Registers r) => r[_r] ?? 0;

  RegisterRValue(this._r);
}

abstract class IInstruction {
  int operate(Registers r);
}

class SetInstruction extends IInstruction {
  final String destination;
  final RValue source;

  SetInstruction(this.destination, this.source);
  
  @override
  int operate(Registers r) {
    r[destination] = source.resolve(r);
    return 1;
  }
}

class SubInstruction extends IInstruction {
  final String destination;
  final RValue source;

  SubInstruction(this.destination, this.source);
  
  @override
  int operate(Registers r) {
    r[destination] = (r[destination] ?? 0) - source.resolve(r);
    return 1;
  }
}

class MulInstruction extends IInstruction {
  final String destination;
  final RValue source;

  MulInstruction(this.destination, this.source);
  
  @override
  int operate(Registers r) {
    r[destination] = (r[destination] ?? 0) * source.resolve(r);
    return 1;
  }
}

class JnzInstruction extends IInstruction {
  final RValue test;
  final RValue offset;

  JnzInstruction(this.test, this.offset);

  @override
  int operate(Registers r) {
    if (test.resolve(r) != 0) return offset.resolve(r);
    return 1;
  }
}

final registerP = letter().trim().map((l) => RegisterRValue(l));
final intP = number.map((n) => IntRValue(n));
final rvalueP = [registerP, intP].toChoiceParser();
final setP = seq2(letter().trim().before('set'), rvalueP).map((m) => SetInstruction(m.$1, m.$2));
final subP = seq2(letter().trim().before('sub'), rvalueP).map((m) => SubInstruction(m.$1, m.$2));
final mulP = seq2(letter().trim().before('mul'), rvalueP).map((m) => MulInstruction(m.$1, m.$2));
final jnzP = seq2(rvalueP.before('jnz'), rvalueP).map((m) => JnzInstruction(m.$1, m.$2));
final matcherP = [setP, subP, mulP, jnzP].toChoiceParser();
