abstract class Failure {
  final String details;

  const Failure(this.details);

  @override
  String toString() => "$runtimeType: $details";
}

class CacheFailure extends Failure {
  const CacheFailure([String details]) : super(details);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure([String details]) : super(details);
}

class NoUserLoginFailure extends Failure {
  const NoUserLoginFailure(String details) : super(details);
}

class InternetConnectionFailure extends Failure {
  const InternetConnectionFailure(String details) : super(details);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String details) : super(details);
}
