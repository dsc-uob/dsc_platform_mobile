part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterSuccessfuly extends RegisterState {
  final User user;

  const RegisterSuccessfuly(this.user);

  @override
  List<Object> get props => [user];
}

class RegisterFailed extends RegisterState {
  final Failure failure;

  const RegisterFailed(this.failure);

  @override
  List<Object> get props => [failure];
}

class LoadRegisterAccount extends RegisterState {}
