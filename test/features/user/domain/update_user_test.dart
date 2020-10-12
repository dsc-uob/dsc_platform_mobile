import 'package:dartz/dartz.dart';
import 'package:dsc_platform/core/db/entities.dart';
import 'package:dsc_platform/features/user/domain/forms.dart';
import 'package:dsc_platform/features/user/domain/repositories.dart';
import 'package:dsc_platform/features/user/domain/usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository repository;
  UpdateUser updateUser;

  setUp(() {
    repository = new MockUserRepository();
    updateUser = new UpdateUser(repository);
  });

  final user = User(
    id: 3,
    username: 'Test',
    email: 'user@test.com',
    firstName: 'Ali',
    isActive: true,
    isStaff: false,
    isSuperUser: false,
  );
  final updateForm = UpdateForm(
    firstName: 'Ali',
  );

  test(
    'Test fetch the current user data.',
    () async {
      when(repository.update(updateForm)).thenAnswer(
        (_) async => Right(User(
          id: 3,
          username: 'Test',
          email: 'user@test.com',
          firstName: 'Ali',
          isActive: true,
          isStaff: false,
          isSuperUser: false,
        )),
      );

      final result = await updateUser(updateForm);

      expect(result, Right(user));
      verify(repository.update(updateForm));
      verifyNoMoreInteractions(repository);
    },
  );
}
