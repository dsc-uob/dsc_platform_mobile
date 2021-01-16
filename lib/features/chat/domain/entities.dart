import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/db/entities.dart';

abstract class TrackableDateModel extends Equatable {
  final DateTime createdOn;
  final DateTime updatedOn;

  const TrackableDateModel({
    this.createdOn,
    this.updatedOn,
  })  : assert(createdOn != null),
        assert(updatedOn != null);

  @override
  List<Object> get props => [
        createdOn,
        updatedOn,
      ];
}

//! ChatSession
class LimitChatSession extends TrackableDateModel {
  final String id;
  final String title;

  const LimitChatSession({
    @required this.id,
    @required this.title,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  })  : assert(id != null),
        assert(title != null),
        assert(createdOn != null),
        assert(updatedOn != null),
        super(
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  @override
  List<Object> get props => super.props
    ..addAll([
      id,
      title,
    ]);
}

class ChatSession extends LimitChatSession {
  final int owner;
  final List<LimitChatRole> roles;

  const ChatSession({
    @required String id,
    @required String title,
    @required this.owner,
    @required this.roles,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  }) : super(
          id: id,
          title: title,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );
  @override
  List<Object> get props => props
    ..addAll([
      owner,
      ...roles,
    ]);
}

//! ChatRole
class LimitChatRole extends TrackableDateModel {
  final int id;
  final String title;

  const LimitChatRole({
    @required this.id,
    @required this.title,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  })  : assert(id != null),
        assert(title != null),
        assert(createdOn != null),
        assert(updatedOn != null),
        super(
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  @override
  List<Object> get props => super.props
    ..addAll([
      id,
      title,
    ]);
}

class ChatRole extends LimitChatRole {
  final String chatSession;

  const ChatRole({
    @required int id,
    @required String title,
    @required this.chatSession,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  })  : assert(id != null),
        assert(title != null),
        assert(chatSession != null),
        assert(createdOn != null),
        assert(updatedOn != null),
        super(
          id: id,
          title: title,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  @override
  List<Object> get props => super.props
    ..addAll([
      chatSession,
    ]);
}

//! ChatMember
abstract class BaseChatMember extends TrackableDateModel {
  final int id;

  const BaseChatMember({
    @required this.id,
    @required DateTime createdOn,
    @required DateTime updatedOn,
  })  : assert(id != null),
        assert(createdOn != null),
        assert(updatedOn != null),
        super(
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  @override
  List<Object> get props => super.props
    ..addAll([
      id,
    ]);
}

class LimitChatMember extends BaseChatMember {
  final LimitChatRole role;
  final LimitChatSession chatSession;

  const LimitChatMember({
    @required this.chatSession,
    @required int id,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    this.role,
  })  : assert(chatSession != null),
        super(
          id: id,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  bool get hasRole => role != null;

  @override
  List<Object> get props => super.props
    ..addAll([
      chatSession,
    ]);
}

class ChatMember extends BaseChatMember {
  final User user;
  final int role;

  const ChatMember({
    @required int id,
    @required this.user,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    this.role,
  })  : assert(id != null),
        assert(user != null),
        assert(createdOn != null),
        assert(updatedOn != null),
        super(
          id: id,
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  bool get hasRole => role != null;

  @override
  List<Object> get props => super.props
    ..addAll([
      id,
      user,
    ]);
}

//! ChatMessage
class ChatMessage extends TrackableDateModel {
  final int id;
  final User user;
  final String body;
  final String chatSession;
  final int parent;

  const ChatMessage({
    @required this.id,
    @required this.user,
    @required this.body,
    @required this.chatSession,
    @required DateTime createdOn,
    @required DateTime updatedOn,
    this.parent,
  })  : assert(id != null),
        assert(user != null),
        assert(body != null),
        assert(chatSession != null),
        assert(createdOn != null),
        assert(updatedOn != null),
        super(
          createdOn: createdOn,
          updatedOn: updatedOn,
        );

  @override
  List<Object> get props => [
        ...super.props,
        id,
        user,
        body,
        chatSession,
        parent,
      ];
}
