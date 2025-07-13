import 'package:equatable/equatable.dart';

class SessionExpiredException extends Equatable {
  const SessionExpiredException(this.error);

  final String? error;

  @override
  List<Object?> get props => [error];
}
