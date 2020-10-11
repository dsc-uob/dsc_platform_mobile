import 'package:dartz/dartz.dart';
import 'package:dsc_platform/core/bases/entities.dart';
import 'package:dsc_platform/features/user/domain/repositories.dart';
import 'package:dsc_platform/features/user/domain/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  CurrentUser currentUser;

  setUp(() {
    repository = new MockUserRepository();
    currentUser = new CurrentUser(repository);
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

  test(
    'Test fetch the current user data.',
    () async {
      when(repository.currentUser()).thenAnswer(
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

      final result = await currentUser();

      expect(result, Right(user));
      verify(repository.currentUser());
      verifyNoMoreInteractions(repository);
    },
  );
}
