import 'package:meta/meta.dart';

abstract class DSCPlatFormException implements Exception {
  final int _code;
  final String _details;

  const DSCPlatFormException({
    @required int code,
    @required String details,
  })  : _code = code,
        _details = details;

  int get code => _code;
  String get details => _details;

  @override
  String toString() {
    return '${this.runtimeType}($code): $details';
  }
}

class CacheManagerException extends DSCPlatFormException {
  CacheManagerException([String details])
      : super(
          code: 601,
          details: details ?? 'Unknown error in cahce!',
        );
}

class NoKeyToCacheException extends DSCPlatFormException {
  NoKeyToCacheException()
      : super(
          code: 602,
          details: 'No key providing in cahced data!',
        );
}

class NoValueToCacheException extends DSCPlatFormException {
  NoValueToCacheException()
      : super(
          code: 603,
          details: 'No value providing in cahced data!',
        );
}

class ValueNotFountInCacheException extends DSCPlatFormException {
  ValueNotFountInCacheException()
      : super(
          code: 604,
          details: 'No value founded in cahce!',
        );
}

class NoUserLoginException extends DSCPlatFormException {
  NoUserLoginException()
      : super(
          code: 700,
          details: 'No user login.',
        );
}

class UnknownException extends DSCPlatFormException {
  UnknownException({
    @required int code,
    @required String details,
  })  : assert(code != null),
        assert(details != null),
        super(
          code: code,
          details: details,
        );
}
