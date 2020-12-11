import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/db/entities.dart';

class DImage extends Equatable {
  final int id;
  final String url;
  final User user;
  final DateTime createdOn;

  const DImage({
    @required this.id,
    @required this.url,
    @required this.user,
    @required this.createdOn,
  })  : assert(id != null),
        assert(url != null),
        assert(user != null),
        assert(createdOn != null);

  @override
  List<Object> get props => [id, url, user, createdOn];
}
