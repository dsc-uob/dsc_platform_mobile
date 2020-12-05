import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dsc_platform/features/post/presentation/blocs/comment/comment_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/authentication_manager.dart';
import 'core/utils/cache_manager.dart';
import 'core/utils/network_info.dart';
import 'features/post/data/data_sources.dart';
import 'features/post/data/repositories_impl.dart';
import 'features/post/domain/usecases.dart';
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
    () => PostBloc(
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
}
