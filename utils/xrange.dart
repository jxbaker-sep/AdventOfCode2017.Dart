Iterable<int> xrange(int n) => Iterable.generate(n, (i) => i);
Iterable<int> xrange2(int first, int last) => Iterable.generate(last - first + 1, (i) => i + first);