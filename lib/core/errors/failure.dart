abstract class Failure {
  final String details;

  const Failure(this.details);
}

class CacheFailure extends Failure {
  const CacheFailure([String details]) : super(details);
}

class NoUserLogin extends Failure {
  const NoUserLogin(String details) : super(details);
}
