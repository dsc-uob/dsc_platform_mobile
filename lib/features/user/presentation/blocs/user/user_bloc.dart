import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/db/entities.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/forms.dart';
import '../../../domain/usecases.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateUser updateUser;
  final CurrentUser currentUser;
  final GetUser getUser;

  UserBloc({
    @required this.getUser,
    @required this.updateUser,
    @required this.currentUser,
  })  : assert(getUser != null),
        assert(updateUser != null),
        assert(currentUser != null),
        super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    yield LoadFetchAccount();
    if (event is FetchMyAccount) {
      final result = await currentUser();
      yield result.fold(
        (l) => FieldFetchAccount(l),
        (r) => SuccessFetchAccount(r),
      );
    }
    if (event is FetchMemberAccount) {
      // yield LoadFetchAccount();
      // final result = await getUser(event.id);
      // yield result.fold(
      //   (l) => FieldFetchAccount(l),
      //   (r) => SuccessFetchAccount(r),
      // );
      yield SuccessFetchAccount(event.user);
    }
    if (event is UpdateMyAccount) {
      yield LoadUpdateAccount();
      final result = await updateUser(event.form);
      yield result.fold(
        (l) => FieldUpdateAccount(l),
        (r) => SuccessUpdateAccount(r),
      );
    }
  }
}
