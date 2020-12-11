import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../api_routes.dart' as api;
import '../../errors/failure.dart';
import '../authentication_manager.dart';

part 'uploadtask_state.dart';

class UploadtaskCubit extends Cubit<UploadtaskState> {
  final Dio _dio;
  final AuthenticationManager _authManager;

  UploadtaskCubit({
    Dio dio,
    AuthenticationManager authManager,
  })  : assert(dio != null),
        assert(authManager != null),
        _dio = dio,
        _authManager = authManager,
        super(UploadtaskInitial()) {
    _dio.options = BaseOptions(
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Token ${authManager.token}',
      },
    );
  }

  void uploadImage(File image) async {
    final res = await _dio.post(
      api.image_url,
      data: FormData.fromMap({
        'image': MultipartFile.fromFileSync(image.path),
      }),
      onSendProgress: (int sent, int total) {
        double progress = sent / total;
        emit(UploadtaskProgress(progress * 100));
      },
    );

    if (res.statusCode != 201)
      emit(
        UploadtaskFailed(UploadImageFailure(res.data)),
      );
    else
      emit(
        UploadtaskSuccess(res.data['image']),
      );
  }
}
