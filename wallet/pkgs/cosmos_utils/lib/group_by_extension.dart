extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
        <K, List<E>>{},
        (map, element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
      );
}
