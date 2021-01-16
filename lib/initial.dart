import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/authentication_manager.dart';
import 'core/utils/cache_manager.dart';
import 'core/utils/cubits/uploadtask_cubit.dart';
import 'core/utils/network_info.dart';
import 'features/chat/data/datasources.dart';
import 'features/chat/data/repositories_impl.dart';
import 'features/chat/domain/usecases.dart';
import 'features/chat/presentation/blocs/chat_message/chat_message_bloc.dart';
import 'features/chat/presentation/blocs/chat_session/chat_session_bloc.dart';
import 'features/media/data/data_sources.dart';
import 'features/media/data/repositories_impl.dart';
import 'features/media/domain/usecases.dart';
import 'features/media/presentation/blocs/image/image_bloc.dart';
import 'features/post/data/data_sources.dart';
import 'features/post/data/repositories_impl.dart';
import 'features/post/domain/usecases.dart';
import 'features/post/presentation/blocs/comment/comment_bloc.dart';
import 'features/post/presentation/blocs/post/post_bloc.dart';
import 'features/settings/data/datasources.dart';
import 'features/settings/data/repositories_impl.dart';
import 'features/settings/domain/usecases.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/user/data/data_sources.dart';
import 'features/user/data/repositories_impl.dart';
import 'features/user/domain/usecases.dart';
import 'features/user/presentation/blocs/authentication/authentication_bloc.dart';
import 'features/user/presentation/blocs/register/register_bloc.dart';
import 'features/user/presentation/blocs/user/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Components - Dependent
  final pref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => pref,
  );
  sl.registerLazySingleton(
    () => FlutterSecureStorage(),
  );
  sl.registerLazySingleton(
    () => DataConnectionChecker(),
  );
  sl.registerLazySingleton(
    () => Dio(),
  );

  //! Components - Created
  sl.registerLazySingleton(
    () => CacheManager(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => AuthenticationManager(sl()),
  );
  sl.registerLazySingleton(
    () => NetworkInfoImpl(sl()),
  );

  //! Data Sources
  sl.registerLazySingleton(
    () => LocalUserDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => RemoteUserDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => LocalSettingsDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => PostLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => PostRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => CommentRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => CommentLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => ImageLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => ImageRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => RemoteChatSessionDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton(
    () => RemoteInChatSessionDataSourceImpl(sl(), sl()),
  );

  //! Repositories
  sl.registerLazySingleton(
    () => UserRepositoryImpl(
      localDS: sl<LocalUserDataSourceImpl>(),
      remoteDS: sl<RemoteUserDataSourceImpl>(),
      networkInfo: sl<NetworkInfoImpl>(),
    )..setup(),
  );
  sl.registerLazySingleton(
    () => SettingsRepositoryImpl(sl<LocalSettingsDataSourceImpl>())..setup(),
  );
  sl.registerLazySingleton(
    () => PostRepositoryImpl(
      networkInfo: sl<NetworkInfoImpl>(),
      localDataSource: sl<PostLocalDataSourceImpl>(),
      remoteDataSource: sl<PostRemoteDataSourceImpl>(),
    ),
  );

  sl.registerLazySingleton(
    () => CommentRepositoryImpl(
      networkInfo: sl<NetworkInfoImpl>(),
      localDataSource: sl<CommentLocalDataSourceImpl>(),
      remoteDataSource: sl<CommentRemoteDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => ImageRepositoryImpl(
      networkInfo: sl<NetworkInfoImpl>(),
      localDataSource: sl<ImageLocalDataSourceImpl>(),
      remoteDataSource: sl<ImageRemoteDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => InChatSessionRepositoryImpl(
      networkInfo: sl<NetworkInfoImpl>(),
      remoteDataSource: sl<RemoteInChatSessionDataSourceImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => ChatSessionRepositoryImpl(
      networkInfo: sl<NetworkInfoImpl>(),
      remoteDataSource: sl<RemoteChatSessionDataSourceImpl>(),
    ),
  );

  //! UseCases
  sl.registerLazySingleton(
    () => LoginUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => ReigsterUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => CurrentUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => LogoutUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => UpdateUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => AuthenticatedUser(sl<UserRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetSettings(sl<SettingsRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => SaveSettings(sl<SettingsRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => CreatePost(sl<PostRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetPosts(sl<PostRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetUserPosts(sl<PostRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => UpdatePost(sl<PostRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => DeletePost(sl<PostRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetComments(sl<CommentRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => CreateComment(sl<CommentRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => UpdateComment(sl<CommentRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => DeleteComment(sl<CommentRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetUserImage(sl<ImageRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => DeleteUserImage(sl<ImageRepositoryImpl>()),
  );
  sl.registerLazySingleton(
    () => GetSessions(
      sl<ChatSessionRepositoryImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => ListenToSessionMessages(
      sl<InChatSessionRepositoryImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => SendMessage(
      sl<InChatSessionRepositoryImpl>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetMessages(sl<InChatSessionRepositoryImpl>()),
  );

  //! Blocs
  sl.registerFactory(
    () => AuthenticationBloc(sl(), sl()),
  );
  sl.registerFactory(
    () => UserBloc(
      getUser: sl(),
      updateUser: sl(),
      currentUser: sl(),
    ),
  );
  sl.registerFactory(
    () => RegisterBloc(sl()),
  );
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      saveSettings: sl(),
    ),
  );
  sl.registerFactory(
    () => GeneralPostBloc(
      getPosts: sl(),
      getUserPosts: sl(),
      createPost: sl(),
      updatePost: sl(),
      deletePost: sl(),
    ),
  );
  sl.registerFactory(
    () => UserPostBloc(
      getPosts: sl(),
      getUserPosts: sl(),
      createPost: sl(),
      updatePost: sl(),
      deletePost: sl(),
    ),
  );

  sl.registerFactory(
    () => CommentBloc(
      getComments: sl(),
      createComment: sl(),
      updateComment: sl(),
      deleteComment: sl(),
    ),
  );
  sl.registerFactory(
    () => ImageBloc(sl(), sl()),
  );
  sl.registerFactory(
    () => ChatMessageBloc(
      sendMessage: sl(),
      getMessages: sl(),
      listenToSessionMessages: sl(),
    ),
  );
  sl.registerFactory(
    () => ChatSessionBloc(
      getSessions: sl(),
    ),
  );

  //! Cubit
  sl.registerFactory(
    () => UploadtaskCubit(
      dio: sl(),
      authManager: sl(),
    ),
  );
}
