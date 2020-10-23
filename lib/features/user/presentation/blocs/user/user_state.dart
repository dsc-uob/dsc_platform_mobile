part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class SuccessFetchAccount extends UserState {
  final User user;

  const SuccessFetchAccount(this.user);

  @override
  List<Object> get props => [user];
}

class SuccessUpdateAccount extends SuccessFetchAccount {
  const SuccessUpdateAccount(User user) : super(user);
}

class FieldFetchAccount extends UserState {
  final Failure failure;

  const FieldFetchAccount(this.failure);

  @override
  List<Object> get props => [failure];
}

class FieldUpdateAccount extends FieldFetchAccount {
  const FieldUpdateAccount(Failure failure) : super(failure);
}

class LoadFetchAccount extends UserState {}

class LoadUpdateAccount extends UserState {}
