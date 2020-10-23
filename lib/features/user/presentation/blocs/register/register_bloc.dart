import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/db/entities.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/forms.dart';
import '../../../domain/usecases.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ReigsterUser reigsterUser;

  RegisterBloc(this.reigsterUser) : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    yield LoadRegisterAccount();
    final result = await reigsterUser(event.form);
    yield result.fold(
      (l) => RegisterFailed(l),
      (r) => RegisterSuccessfuly(r),
    );
  }
}
