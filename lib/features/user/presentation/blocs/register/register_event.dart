part of 'register_bloc.dart';

class RegisterEvent extends Equatable {
  final RegisterForm form;

  const RegisterEvent(this.form);

  @override
  List<Object> get props => [form];
}
