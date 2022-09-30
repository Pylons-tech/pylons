import 'package:dartz/dartz.dart';

extension FutureEither<L, R> on Future<Either<L, R>> {
  Future<Either<L, R2>> flatMap<R2>(Function1<R, Future<Either<L, R2>>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        f,
      ),
    );
  }

  Future<Either<L, Tuple2<R, R2>>> zipWith<R2>(Future<Either<L, R2>> withThis) => flatMap(
        (r) async => withThis.flatMap(
          (r2) async => right(Tuple2(r, r2)),
        ),
      );

  Future<Either<L2, R>> leftMap<L2>(Function1<L, Either<L2, R>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(f(l)),
        (r) => Future.value(right<L2, R>(r)),
      ),
    );
  }

  Future<Either<L, R2>> map<R2>(Function1<R, Either<L, R2>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) => Future.value(f(r)),
      ),
    );
  }
}
