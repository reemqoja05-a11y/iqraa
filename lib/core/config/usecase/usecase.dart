import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

/// Contract for every use case: one action, typed params, typed result.
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Use this as [P] when a use case needs no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
