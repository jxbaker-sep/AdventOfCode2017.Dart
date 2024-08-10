
import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'utils/input.dart';
import 'utils/iterable_extensions.dart';
import 'utils/list_extensions.dart';
import 'utils/parse_utils.dart';
import 'utils/xrange.dart';


Future<void> main() async {
  final sample2 = particleP.onePerLine(await getInput('day20.sample.2'));
  final data = particleP.onePerLine(await getInput('day20'));
  group('Day 20', (){
    group('Part 1', (){
    });
    group('Part 2', (){
      // test("Sample", () => expect(do2(sample2), equals(1)));
      test("Data", () => expect(do2(data), equals(477)));
    });
  });
}


// int do2BruteForce(List<Particle> particles) {
//   var remaining = xrange(particles.length).toSet();

//   for(final _ in xrange(0xFFFF)) {
//     particles = particles.map((p) => ((p.$1.$1 + p.$2.$1 + p.$3.$1, p.$1.$2 + p.$2.$2 + p.$3.$2, p.$1.$3 + p.$2.$3 + p.$3.$3), 
//       (p.$2.$1 + p.$3.$1, p.$2.$2 + p.$3.$2, p.$2.$3 + p.$3.$3), (p.$3.$1, p.$3.$2, p.$3.$3))).toList();
    
//     final collisions = particles.indexed.groupFoldBy((p) => p.$2.$1, (List<int>? xx, c) => (xx ?? [])..add(c.$1)).values.where((e) => e.length > 1)
//       .map((e) => remaining.intersection(e.toSet()))
//       .where((e) => e.length > 1)
//       .flatmap((e) => e)
//       .toSet();
//     remaining = remaining.difference(collisions);
//   }
//   return remaining.length;
// }

int do2(List<Particle> particles) {

  final collisions = particles.indexed.toList().pairs().flatmap((pair) => listCollision3(pair[0].$2, pair[1].$2).map((c) => (time: c, p1: pair[0].$1, p2: pair[1].$1))).toList();
  final max = collisions.map((c) => c.time).max;

  var remaining = xrange(particles.length).toSet();
  collisions.sort((a, b) => a.time - b.time);
  for(final t in xrange(max + 1)) {
    final colliders = collisions.where((c) => c.time == t && remaining.containsAll([c.p1, c.p2])).flatmap((c) => [c.p1, c.p2]).toSet();
    remaining = remaining.difference(colliders);
  }

  return remaining.length;
}

List<int> listCollision3(Particle a, Particle b) {
  final c0 = listCollision1((a.$1.$1, a.$2.$1, a.$3.$1), (b.$1.$1, b.$2.$1, b.$3.$1));
  final c1 = listCollision1((a.$1.$2, a.$2.$2, a.$3.$2), (b.$1.$2, b.$2.$2, b.$3.$2));
  final c2 = listCollision1((a.$1.$3, a.$2.$3, a.$3.$3), (b.$1.$3, b.$2.$3, b.$3.$3));
  final r = combine(c0, combine(c1, c2)) ?? (throw Exception());
  // print(r);
  // print(c0);
  // print(c1);
  // print(c2);
  return r;
}

List<int>? combine(List<int>? c1, List<int>? c2) {
  if (c1 == null) return c2;
  if (c2 == null) return c1;
  return c1.toSet().intersection(c2.toSet()).toList()..sort();
}

// empty list == no collisions; null = infinite collisions
List<int>? listCollision1((int, int, int) a, (int, int, int) b)  {
  var pa = a.$1;
  var pb = b.$1;
  var va = a.$2;
  var vb = b.$2;  
  var aa = a.$3;
  var ab = b.$3;

  if (va == vb && aa == ab) {
    if (pa == pb) return null;
    return [];
  }

  var result = <int>[];
  for(final t in xrange(0xFFFF)) {
    if (pa == pb) {
      result.add(t);
    }
    va += aa;
    vb += ab;
    final t0 = pa + va;
    final t1 = pb + vb;
    if (t0 != t1 && !mightCollide((t0, va, aa), (t1, vb, ab))) return result;
    
    pa = t0;
    pb = t1;
  }
  print('$a $b $pa $pb $va $vb $aa $ab');
  throw Exception();
}

bool mightCollide((int, int, int) a, (int, int, int) b) {
  var pa = a.$1;
  var pb = b.$1;
  var va = a.$2;
  var vb = b.$2;  
  var aa = a.$3;
  var ab = b.$3;

  if (!hasInflected(a) || !hasInflected(b)) return true;
  if (pa.sign != pb.sign) return false;
  if (pa.abs() > pb.abs() ) {
    if (va.abs() > vb.abs()) {
      if (aa.abs() >= ab.abs()) {
        return false;
      }
    }
  }
  if (pa.abs() < pb.abs() ) {
    if (va.abs() < vb.abs()) {
      if (aa.abs() <= ab.abs()) {
        return false;
      }
    }
  }
  return true;
}

bool hasInflected((int, int, int) a) {
  var pa = a.$1;
  var va = a.$2;
  var aa = a.$3;

  if (aa == 0) {
    if (va == 0) return true;
    return pa.sign == va.sign;
  }
  return (va.sign == aa.sign && pa.sign == va.sign);
}


typedef Particle = ((int, int, int), (int, int, int), (int, int, int));



final tuple3P = seq3(number.between('<', ','), number.after(','), number.after('>'));
final particleP = seq3(tuple3P.between('p=', ','), tuple3P.between('v=', ','), tuple3P.before('a='));