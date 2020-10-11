import 'package:dartz/dartz.dart';
import 'package:dsc_platform/core/bases/entities.dart';
import 'package:dsc_platform/features/user/domain/repositories.dart';
import 'package:dsc_platform/features/user/domain/usecases.dart';
import 'package:dsc_platform/features/user/domain/forms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  ReigsterUser reigsterUser;

  setUp(() {
    repository = new MockUserRepository();
    reigsterUser = new ReigsterUser(repository);
  });

  final user = User(
    id: 3,
    username: 'Test',
    email: 'user@test.com',
    firstName: 'Test',
    isActive: true,
    isStaff: false,
    isSuperUser: false,
  );
  final registerForm = RegisterForm(
    username: 'Test',
    email: 'user@test.com',
    firstName: 'Test',
    password: 'test1234',
  );

  test(
    'Test fetch the current user data.',
    () async {
      when(repository.register(registerForm)).thenAnswer(
        (_) async => Right(User(
          id: 3,
          username: 'Test',
          email: 'user@test.com',
          firstName: 'Test',
          isActive: true,
          isStaff: false,
          isSuperUser: false,
        )),
      );

      final result = await reigsterUser(registerForm);

      expect(result, Right(user));
      verify(repository.register(registerForm));
      verifyNoMoreInteractions(repository);
    },
  );
}
