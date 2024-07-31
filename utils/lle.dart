import 'dart:collection';

final class LLE<T> extends LinkedListEntry<LLE<T>> {
  T value;
  LLE(this.value);
}

extension LLExtension<T> on LLE<T> {
  LLE<T> advance(int n) => Iterable.generate(n).fold(this, (p, _) => p.next!);
  LLE<T> advanceWrap(int n) => Iterable.generate(n).fold(this, (p, _) => p.next ?? list!.first);
}