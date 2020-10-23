part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchMyAccount extends UserEvent {}

class FetchMemberAccount extends UserEvent {
  final int id;

  const FetchMemberAccount(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateMyAccount extends UserEvent {
  final UpdateForm form;

  const UpdateMyAccount(this.form);

  @override
  List<Object> get props => [form];
}
