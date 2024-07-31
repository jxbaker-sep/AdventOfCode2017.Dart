Iterable<int> xrange(int n) => Iterable.generate(n, (i) => i);
Iterable<int> xrange2(int first, int last) => Iterable.generate(last - first + 1, (i) => i + first);
Iterable<int> xrange3(int first, int count, int step) => Iterable.generate(count, (i) => i * step + first);
