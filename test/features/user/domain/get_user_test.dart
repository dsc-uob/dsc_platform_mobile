import 'package:dartz/dartz.dart';
import 'package:dsc_platform/core/db/entities.dart';
import 'package:dsc_platform/features/user/domain/repositories.dart';
import 'package:dsc_platform/features/user/domain/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  GetUser getUser;

  setUp(() {
    repository = new MockUserRepository();
    getUser = new GetUser(repository);
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
    'Test fetch user data with id.',
    () async {
      when(repository.getUser(any)).thenAnswer(
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

      final result = await getUser(3);

      expect(result, Right(user));
      verify(repository.getUser(3));
      verifyNoMoreInteractions(repository);
    },
  );
}
