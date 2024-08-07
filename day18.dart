import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/parse_utils.dart';


Future<void> main() async {
  final sample = matcherP.onePerLine(await getInput('day18.sample'));
  final data = matcherP.onePerLine(await getInput('day18'));
  group('Day 18', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(4)));
      test("Data", () => expect(do1(data), equals(4601)));
    });
    group('Part 2', (){
    });
  });
}

int do1(List<IInstruction> instructions) {
  Registers r = {};
  int pc = 0;
  while (pc >= 0 && pc < instructions.length) {
    final instr = instructions[pc];
    if (instr case RcvInstruction rcv) {
      if (rcv.recover(r) case int i) return i;
      pc += 1;
      continue;
    }
    pc += instr.operate(r);
  }
  throw Exception();
}

// class Program {
//   final List<IInstruction> instructions;
//   final List<int> inputs;
// }

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

class AddInstruction extends IInstruction {
  final String destination;
  final RValue source;

  AddInstruction(this.destination, this.source);
  
  @override
  int operate(Registers r) {
    r[destination] = (r[destination] ?? 0) + source.resolve(r);
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

class ModInstruction extends IInstruction {
  final String destination;
  final RValue source;

  ModInstruction(this.destination, this.source);
  
  @override
  int operate(Registers r) {
    r[destination] = (r[destination] ?? 0) % source.resolve(r);
    return 1;
  }
}

class SndInstruction extends IInstruction {
  final RValue source;

  SndInstruction(this.source);
  @override
  int operate(Registers r) {
    r['snd'] = source.resolve(r);
    return 1;
  }
}

class RcvInstruction extends IInstruction {
  final RValue condition;

  int? recover(Registers r) => condition.resolve(r) != 0 ? r['snd']! : null;

  RcvInstruction(this.condition);
  @override
  int operate(Registers r) => throw UnimplementedError();
}

class JgzInstruction extends IInstruction {
  final RValue test;
  final RValue offset;

  JgzInstruction(this.test, this.offset);

  @override
  int operate(Registers r) {
    if (test.resolve(r) > 0) return offset.resolve(r);
    return 1;
  }
}

final registerP = letter().trim().map((l) => RegisterRValue(l));
final intP = number.map((n) => IntRValue(n));
final rvalueP = [registerP, intP].toChoiceParser();
final sndP = rvalueP.before('snd').map((rvalue) => SndInstruction(rvalue));
final setP = seq2(letter().trim().before('set'), rvalueP).map((m) => SetInstruction(m.$1, m.$2));
final addP = seq2(letter().trim().before('add'), rvalueP).map((m) => AddInstruction(m.$1, m.$2));
final mulP = seq2(letter().trim().before('mul'), rvalueP).map((m) => MulInstruction(m.$1, m.$2));
final modP = seq2(letter().trim().before('mod'), rvalueP).map((m) => ModInstruction(m.$1, m.$2));
final rcvP = rvalueP.before('rcv').map((rvalue) => RcvInstruction(rvalue));
final jgzP = seq2(rvalueP.before('jgz'), rvalueP).map((m) => JgzInstruction(m.$1, m.$2));
final matcherP = [sndP, setP, addP, mulP, modP, rcvP, jgzP].toChoiceParser();
