export declare function zipIterators<T, U>(xs: IterableIterator<T>, ys: IterableIterator<U>): Generator<[T | undefined, U | undefined]>;
export declare function lastWhere<P>(xs: Iterable<P>, predicate: (x: P) => boolean): P | undefined;
export declare function iteratorNext<P>(xs: IterableIterator<P>): P | undefined;
