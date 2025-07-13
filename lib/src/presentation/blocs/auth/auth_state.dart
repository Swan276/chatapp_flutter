part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthInitialLoadingState extends AuthState {}

class AuthLoggedInState extends AuthState {
  AuthLoggedInState(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class AuthLoginLoadingState extends AuthState {}

class AuthLoginErrorState extends AuthState {
  AuthLoginErrorState(this.error);

  final String? error;

  @override
  List<Object?> get props => [error];
}

class AuthSignUpLoadingState extends AuthState {}

class AuthSignUpErrorState extends AuthState {
  AuthSignUpErrorState(this.error);

  final String? error;

  @override
  List<Object?> get props => [error];
}

class AuthLoggedOutState extends AuthState {}

class AuthSessionExpiredState extends AuthState {}
