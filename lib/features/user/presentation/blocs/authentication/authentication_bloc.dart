import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/db/entities.dart';
import '../../../domain/usecases.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticatedUser authenticatedUser;
  final LogoutUser logoutUser;

  AuthenticationBloc(
    this.authenticatedUser,
    this.logoutUser,
  ) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is CheckAuthentication) {
      final result = await authenticatedUser();
      yield result.fold(
        (l) => UnauthenticatedUser(),
        (r) => AuthenticateUser(r),
      );
    }

    if (event is NowLogin) {
      yield AuthenticateUser(event.user);
    }

    if (event is NowLogout) {
      yield AuthenticationInitial();
      final result = await logoutUser();
      yield result.fold(
        (l) => UnauthenticatedUser(),
        (r) => UnauthenticatedUser(),
      );
    }
  }
}
