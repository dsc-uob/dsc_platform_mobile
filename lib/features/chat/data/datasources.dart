import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';

import '../../../core/api_routes.dart' as api;
import '../../../core/contrib/data_source.dart';
import '../../../core/contrib/use_case.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/authentication_manager.dart';
import 'models.dart';

abstract class RemoteChatSessionDataSource extends RemoteDataSource {
  RemoteChatSessionDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<LimitChatMemberModel>> fetchSessions();
  Future<ChatSessionModel> createSession();
  Future<ChatSessionModel> updateSession();
  Future<ChatSessionModel> getThisSession(String id);
  Future<void> deleteSession();
}

class RemoteChatSessionDataSourceImpl extends RemoteChatSessionDataSource {
  RemoteChatSessionDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  @override
  Future<List<LimitChatMemberModel>> fetchSessions() async {
    final res = await http.get(
      api.chat_sessions_url,
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: res.data,
      );

    final data = res.data['results'] as List;

    return List<LimitChatMemberModel>.generate(
      data.length,
      (index) => LimitChatMemberModel.fromJson(data[index]),
    );
  }

  @override
  Future<ChatSessionModel> createSession() {}

  @override
  Future<void> deleteSession() {}

  @override
  Future<ChatSessionModel> updateSession() {}

  @override
  Future<ChatSessionModel> getThisSession(String id) async {
    final res = await http.get(
      api.chat_sessions_url + '$id/',
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: res.data,
      );

    return ChatSessionModel.fromJson(res.data);
  }
}

abstract class RemoteInChatSessionDataSource extends RemoteDataSource {
  RemoteInChatSessionDataSource(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  Future<List<ChatMessageModel>> fetchPastMessages(IdLimitOffsetParams params);
  Stream<ChatMessageModel> joinSessionMessage(String id);
  Stream<ChatSessionModel> joinSessionUpdate(String id);

  void sendMessage(String message);
}

class RemoteInChatSessionDataSourceImpl extends RemoteInChatSessionDataSource {
  RemoteInChatSessionDataSourceImpl(Dio http, AuthenticationManager authManager)
      : super(http, authManager);

  IOWebSocketChannel _chatSocket;
  IOWebSocketChannel _messagesSocket;

  @override
  Future<List<ChatMessageModel>> fetchPastMessages(
      IdLimitOffsetParams params) async {
    final res = await http.get(
      api.chat_messages_url,
      queryParameters: {
        if (params.id != null) 'chat_session': params.id,
        if (params.limit != null) 'limit': params.limit,
        if (params.offset != null) 'offset': params.offset,
      },
    );

    if (res.statusCode != 200)
      throw UnknownException(
        code: res.statusCode,
        details: res.data,
      );

    final data = res.data['results'] as List;

    return List.generate(
      data.length,
      (index) => ChatMessageModel.fromJson(data[index]),
    );
  }

  @override
  Stream<ChatMessageModel> joinSessionMessage(String id) {
    _messagesSocket = new IOWebSocketChannel.connect(
      api.chat_messages_ws + '$id/',
      headers: {
        'token': authManager.token,
      },
    );
    return _messagesSocket.stream.map(
      (event) {
        final res = jsonDecode(event);
        final data = jsonDecode(res['text']);
        return ChatMessageModel.fromJson(data);
      },
    );
  }

  @override
  Stream<ChatSessionModel> joinSessionUpdate(String id) {
    _chatSocket = new IOWebSocketChannel.connect(
      api.chat_session_ws + '$id/',
      headers: {
        'Authorization': authManager.token,
      },
    );
    return _chatSocket.stream.map(
      (event) {
        final res = jsonDecode(event);
        final data = jsonDecode(res['text']);
        return ChatSessionModel.fromJson(data);
      },
    );
  }

  @override
  void sendMessage(String message) {
    if (_messagesSocket != null)
      _messagesSocket.sink.add(jsonEncode(
        {
          'message': message,
        },
      ));
  }
}
