part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchMyAccount extends UserEvent {}

class FetchMemberAccount extends UserEvent {
  final User user;

  const FetchMemberAccount(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateMyAccount extends UserEvent {
  final UpdateForm form;

  const UpdateMyAccount(this.form);

  @override
  List<Object> get props => [form];
}

class UserImageUpdated extends UserEvent{
  final String photo;

  const UserImageUpdated(this.photo);

  @override
  List<Object> get props => [photo];
}
