import 'package:daily_language/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
