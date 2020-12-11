import 'package:meta/meta.dart';

import '../../../core/db/models.dart';
import '../../../core/db/serializer.dart';
import '../domain/entities.dart';

class DImageModel extends DImage implements MapSerializer {
  @override
  final UserModel user;

  const DImageModel({
    @required int id,
    @required this.user,
    @required String url,
    @required DateTime createdOn,
  }) : super(
          id: id,
          url: url,
          user: user,
          createdOn: createdOn,
        );

  factory DImageModel.fromJson(Map<String, dynamic> data) {
    return DImageModel(
      id: data['id'],
      user: UserModel.fromJson(data['user']),
      url: data['image'],
      createdOn: DateTime.parse(data['created_on']),
    );
  }

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'image': url,
        'user': user.generateMap(),
        'createdOn': createdOn.toString(),
      };

  @override
  get object => this;
}
