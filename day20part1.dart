
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/parse_utils.dart';


Future<void> main() async {
  final sample = particleP.onePerLine(await getInput('day20.sample'));
  final data = particleP.onePerLine(await getInput('day20'));
  group('Day 20', (){
    group('Part 1', (){
      test("Sample", () => expect(do1(sample), equals(0)));
      test("Data", () => expect(do1(data), equals(144)));
    });
    group('Part 2', (){
    });
  });
}

int do1(List<Particle> particles) {
  final temp = particles.map((p) => p.positionAfter(bigtime)).map((p) => manhattanDistance3D(p)).toList();
  final min = temp.reduce((a,b) => a < b ? a : b);
  return temp.indexOf(min);
}

typedef Particle = ((BigInt, BigInt, BigInt), (BigInt, BigInt, BigInt), (BigInt, BigInt, BigInt));

final bigtime = BigInt.from(0xFFFFFFFF);

BigInt manhattanDistance3D((BigInt, BigInt, BigInt) p) => p.$1.abs() + p.$2.abs() + p.$3.abs();

extension on Particle {
  (BigInt,BigInt,BigInt) positionAfter(BigInt t) => (
      fct($1.$1, $2.$1, $3.$1, t),
      fct($1.$2, $2.$2, $3.$2, t),
      fct($1.$3, $2.$3, $3.$3, t)
  );
}

BigInt fct(BigInt p, BigInt v, BigInt a, BigInt t) => p + v * t + a * t * t ~/ BigInt.two;

final tuple3P = seq3(number.between('<', ','), number.after(','), number.after('>')).map((m) => (BigInt.from(m.$1), BigInt.from(m.$2), BigInt.from(m.$3)));
final particleP = seq3(tuple3P.between('p=', ','), tuple3P.between('v=', ','), tuple3P.before('a='));