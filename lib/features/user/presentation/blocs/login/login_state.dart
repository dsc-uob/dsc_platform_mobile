part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSuccessful extends LoginState {
  final User user;

  const LoginSuccessful(this.user);

  @override
  List<Object> get props => [user];
}

class LoginFailed extends LoginState {
  final Failure failure;

  const LoginFailed(this.failure);

  @override
  List<Object> get props => [failure];
}

class LoadLoginAccount extends LoginState {}
