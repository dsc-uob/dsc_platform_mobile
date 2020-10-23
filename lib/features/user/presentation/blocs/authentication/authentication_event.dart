part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthentication extends AuthenticationEvent {}

class NowLogin extends AuthenticationEvent {
  final User user;

  const NowLogin(this.user);

  @override
  List<Object> get props => [user];
}

class NowLogout extends AuthenticationEvent {}
