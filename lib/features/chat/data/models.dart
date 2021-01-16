import 'package:meta/meta.dart';

import '../../../core/db/models.dart';
import '../../../core/db/serializer.dart';
import '../domain/entities.dart';

//! ChatSession
class LimitChatSessionModel extends LimitChatSession implements MapSerializer {
  const LimitChatSessionModel({
    @required String id,
    @required String title,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  }) : super(
          id: id,
          title: title,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  factory LimitChatSessionModel.fromJson(Map<String, dynamic> json) =>
      LimitChatSessionModel(
        id: json['id'],
        title: json['title'],
        createdOn: DateTime.parse(json['created_date']).toLocal(),
        updatedOn: DateTime.parse(json['updated_date']).toLocal(),
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'title': title,
        'created_date': createdOn.toString(),
        'updated_date': updatedOn.toString(),
      };

  @override
  get object => this;
}

class ChatSessionModel extends ChatSession implements MapSerializer {
  @override
  final int owner;

  final List<LimitChatRoleModel> roles;

  const ChatSessionModel({
    @required String id,
    @required this.owner,
    @required String title,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    @required this.roles,
  }) : super(
          id: id,
          owner: owner,
          title: title,
          createdOn: createdOn,
          updatedOn: updatedOn,
          roles: roles,
        );

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      ChatSessionModel(
        id: json['id'],
        title: json['title'],
        owner: json['owner'],
        roles: List<LimitChatRoleModel>.generate(
          json['roles'].length,
          (index) => json['roles'][index],
        ),
        createdOn: DateTime.parse(json['created_date']),
        updatedOn: DateTime.parse(json['updated_date']),
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'owner': owner,
        'title': title,
        'roles': List.generate(
          roles.length,
          (index) => roles[index].generateMap(),
        ),
        'created_date': createdOn.toString(),
        'updated_date': updatedOn.toString(),
      };

  @override
  get object => this;
}

//! ChatRole
class LimitChatRoleModel extends LimitChatRole implements MapSerializer {
  const LimitChatRoleModel({
    @required int id,
    @required String title,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  }) : super(
          id: id,
          title: title,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  factory LimitChatRoleModel.fromJson(Map<String, dynamic> json) =>
      LimitChatRoleModel(
        id: json['id'],
        title: json['title'],
        createdOn: DateTime.parse(json['created_date']).toLocal(),
        updatedOn: DateTime.parse(json['updated_date']).toLocal(),
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'title': title,
        'created_date': createdOn.toString(),
        'updated_date': updatedOn.toString(),
      };

  @override
  get object => this;
}

class ChatRoleModel extends ChatRole implements MapSerializer {
  const ChatRoleModel({
    @required int id,
    @required String title,
    @required String chatSession,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  }) : super(
          id: id,
          title: title,
          chatSession: chatSession,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  factory ChatRoleModel.fromJson(Map<String, dynamic> json) => ChatRoleModel(
        id: json['id'],
        title: json['title'],
        chatSession: json['chat_session'],
        createdOn: DateTime.parse(json['created_date']).toLocal(),
        updatedOn: DateTime.parse(json['updated_date']).toLocal(),
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'title': title,
        'chat_session': chatSession,
        'updated_date': updatedOn.toString(),
        'created_date': createdOn.toString(),
      };

  @override
  get object => this;
}

//! ChatMember
class LimitChatMemberModel extends LimitChatMember implements MapSerializer {
  @override
  final LimitChatRoleModel role;
  @override
  final LimitChatSessionModel chatSession;

  const LimitChatMemberModel({
    @required int id,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    @required this.chatSession,
    this.role,
  }) : super(
          id: id,
          role: role,
          chatSession: chatSession,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  factory LimitChatMemberModel.fromJson(Map<String, dynamic> json) =>
      LimitChatMemberModel(
        id: json['id'],
        createdOn: DateTime.parse(json['created_date']).toLocal(),
        updatedOn: DateTime.parse(json['updated_date']).toLocal(),
        chatSession: LimitChatSessionModel.fromJson(json['chat_session']),
        role: json['role'] == null
            ? null
            : LimitChatRoleModel.fromJson(json['role']),
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'chat_session': chatSession.generateMap(),
        'role': role.generateMap(),
        'created_date': createdOn.toString(),
        'updated_date': updatedOn.toString(),
      };

  @override
  get object => this;
}

class ChatMemberModel extends ChatMember implements MapSerializer {
  @override
  final UserModel user;

  const ChatMemberModel({
    @required int id,
    @required this.user,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    int role,
  }) : super(
          id: id,
          user: user,
          createdOn: createdOn,
          updatedOn: updatedOn,
          role: role,
        );
  factory ChatMemberModel.fromJson(Map<String, dynamic> json) =>
      ChatMemberModel(
        id: json['id'],
        createdOn: DateTime.parse(json['created_date']).toLocal(),
        updatedOn: DateTime.parse(json['updated_date']).toLocal(),
        user: UserModel.fromJson(json['user']),
        role: json['role'],
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'user': user.generateMap(),
        'created_date': createdOn.toString(),
        'updated_date': updatedOn.toString(),
        'role': role,
      };

  @override
  get object => this;
}

//! ChatMessage
class ChatMessageModel extends ChatMessage implements MapSerializer {
  @override
  final UserModel user;

  const ChatMessageModel({
    @required int id,
    @required this.user,
    @required String body,
    @required String chatSession,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    int parent,
  }) : super(
          id: id,
          body: body,
          user: user,
          chatSession: chatSession,
          parent: parent,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        id: json['id'],
        body: json['body'],
        chatSession: json['chat_session'],
        user: UserModel.fromJson(json['user']),
        parent: json['parent'],
        createdOn: DateTime.parse(json['created_date']).toLocal(),
        updatedOn: DateTime.parse(json['updated_date']).toLocal(),
      );

  @override
  Map<String, dynamic> generateMap() => {
        'id': id,
        'user': user.generateMap(),
        'body': body,
        'chat_session': chatSession,
        'created_date': createdOn.toString(),
        'updated_date': updatedOn.toString(),
      };

  @override
  get object => this;
}
