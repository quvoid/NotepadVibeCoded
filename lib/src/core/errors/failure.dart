import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// 
/// We use [Equatable] to allow easy comparison of failures in tests.
abstract class Failure extends Equatable {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, error, stackTrace];
}

/// Represents a failure in the Database layer (Isar).
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}

/// Represents an unexpected error.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.error,
    super.stackTrace,
  });
}
