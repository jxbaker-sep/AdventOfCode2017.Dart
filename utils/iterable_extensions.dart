import 'dart:collection';

import 'package:collection/collection.dart';

extension MyIterableExtensions<T> on Iterable<T> {
  // int maxBy(int Function(T t) callback) => map(callback).max;
  T findByMin(int Function(T t) callback) {
    var first = true;
    T? found;
    int value = 0;
    for(final f in this) {
      if (first) {
        found = f;
        value = callback(f);
        first = false;
      } else {
        final temp = callback(f);
        if (temp < value) {
          found = f;
          value = temp;
        }
      }
    }
    return found ?? (throw Exception());
  }

  Iterable<T2> flatmap<T2>(Iterable<T2> Function(T t) callback) {
    return map(callback).expand((i)=>i);
  }

  Map<T2, T3> toMap<T2, T3>(T2 Function(T t) asKey, T3 Function(T t) asValue) {
    final result = <T2, T3>{};
    for(final item in this) {
      result[asKey(item)] = asValue(item);
    }
    return result;
  }

  Iterable<List<T>> windows(int length) sync* {
    if (length < 1) throw Exception();
    final accum = Queue<T>();
    for(final item in this) {
      accum.add(item);
      if (accum.length > length) accum.removeFirst();
      if (accum.length == length) yield accum.toList();
    }
  }
}

extension MyIterableNumericExtension on Iterable<int> {
  int get product => reduce((a,b) => a*b);
}