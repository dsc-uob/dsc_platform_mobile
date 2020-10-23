part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  final LoginForm form;

  const LoginEvent(this.form);

  @override
  List<Object> get props => [form];
}
