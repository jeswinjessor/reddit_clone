import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';

/// with typedef we can create our own types
/// we are creating a typedef of Either(fpdart)
/// T means we can give any type tot he error

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
