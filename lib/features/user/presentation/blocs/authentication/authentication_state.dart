part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticateUser extends AuthenticationState {
  final User user;

  const AuthenticateUser(this.user);

  @override
  List<Object> get props => [user];
}

class UnauthenticatedUser extends AuthenticationState {}
