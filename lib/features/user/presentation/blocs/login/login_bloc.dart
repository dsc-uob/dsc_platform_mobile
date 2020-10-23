import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/db/entities.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/forms.dart';
import '../../../domain/usecases.dart';
import '../authentication/authentication_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  final LoginUser loginUser;

  LoginBloc(
    this.loginUser,
    this.authenticationBloc,
  ) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    yield LoadLoginAccount();
    final result = await loginUser(event.form);
    yield result.fold<LoginState>(
      (l) => LoginFailed(l),
      (r) {
        authenticationBloc.add(NowLogin(r));
        return LoginSuccessful(r);
      },
    );
  }
}
