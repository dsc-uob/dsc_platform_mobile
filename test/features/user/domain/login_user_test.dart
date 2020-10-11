import 'package:dartz/dartz.dart';
import 'package:dsc_platform/core/bases/entities.dart';
import 'package:dsc_platform/features/user/domain/forms.dart';
import 'package:dsc_platform/features/user/domain/repositories.dart';
import 'package:dsc_platform/features/user/domain/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  LoginUser loginUser;

  setUp(() {
    repository = new MockUserRepository();
    loginUser = new LoginUser(repository);
  });

  test(
    'Test login user.',
    () async {
      final user = User(
        id: 3,
        username: 'Test',
        email: 'user@test.com',
        firstName: 'Test',
        isActive: true,
        isStaff: false,
        isSuperUser: false,
      );
      final loginForm = LoginForm('Test', 'test1234');

      when(repository.login(loginForm)).thenAnswer(
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

      final result = await loginUser(loginForm);

      expect(result, Right(user));
      verify(repository.login(loginForm));
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'Test login user.',
    () async {
      final user = User(
        id: 3,
        username: 'Test',
        email: 'user@test.com',
        firstName: 'Test',
        isActive: true,
        isStaff: false,
        isSuperUser: false,
      );
      final loginForm = LoginForm('Test', 'test1234');

      when(repository.login(loginForm)).thenAnswer(
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

      final result = await loginUser(loginForm);

      expect(result, Right(user));
      verify(repository.login(loginForm));
      verifyNoMoreInteractions(repository);
    },
  );
}
