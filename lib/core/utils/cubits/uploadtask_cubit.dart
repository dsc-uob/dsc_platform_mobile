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

  UploadtaskCubit({
    Dio dio,
    AuthenticationManager authManager,
  })  : assert(dio != null),
        assert(authManager != null),
        _dio = dio,
        super(UploadtaskInitial()) {
    _dio.options = BaseOptions(
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Token ${authManager.token}',
      },
    );
  }

  void uploadImage(File image, {bool isUserImage = false}) async {
    Response res;
    if (isUserImage) {
      res = await _dio.patch(
        api.user_photo_url,
        data: FormData.fromMap({
          'photo': MultipartFile.fromFileSync(image.path),
        }),
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          emit(UploadtaskProgress(progress));
        },
      );
    } else {
      res = await _dio.post(
        api.image_url,
        data: FormData.fromMap({
          'image': MultipartFile.fromFileSync(image.path),
        }),
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          emit(UploadtaskProgress(progress));
        },
      );
    }
    if ((isUserImage && res.statusCode != 200) ||
        (!isUserImage && res.statusCode != 201))
      emit(
        UploadtaskFailed(UploadImageFailure('${res.data}')),
      );
    else
      emit(
        UploadtaskSuccess(res.data[isUserImage ? 'photo' : 'image']),
      );
  }
}
