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

class UploadTaskFailure extends Failure {
  UploadTaskFailure({String details})
      : super(details ?? 'Error with upload file.');
}

class UploadImageFailure extends UploadTaskFailure {
  UploadImageFailure([String details])
      : super(details: details ?? 'Error with upload image.');
}

class UnknownFailure extends Failure {
  const UnknownFailure(String details) : super(details);
}
