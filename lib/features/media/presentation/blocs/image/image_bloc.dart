import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/contrib/use_case.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities.dart';
import '../../../domain/usecases.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final GetUserImage getUserImage;
  final DeleteUserImage deleteUserImage;

  ImageBloc(
    this.getUserImage,
    this.deleteUserImage,
  ) : super(ImageInitial());

  bool _hasReachedMax = false;

  @override
  Stream<ImageState> mapEventToState(
    ImageEvent event,
  ) async* {
    final currentState = state;
    if (event is FetchImages && !_hasReachedMax) {
      int offset = 0;
      List<DImage> images = [];

      if (currentState is ImagesFetchedSuccessful) {
        offset = currentState.images.length;
        images = currentState.images;
      }

      final res = await getUserImage(IdLimitOffsetParams(
        id: event.id,
        limit: 25,
        offset: offset,
      ));

      yield res.fold(
        (l) => ImageFailedFetch(l),
        (r) => ImagesFetchedSuccessful(images + r),
      );
    }

    if (event is DeleteImage && currentState is ImagesFetchedSuccessful) {
      final res = await deleteUserImage(event.id);
      yield res.fold(
        (l) => ImageFailedDeleted(currentState.images, l),
        (r) => ImageSucessfulDeleted(
            currentState.images..removeWhere((p) => p.id == event.id)),
      );
    }
  }
}
