part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

abstract class ImageFailureState extends ImageState {
  final Failure failure;

  const ImageFailureState(this.failure);

  @override
  List<Object> get props => [failure];
}

class ImageInitial extends ImageState {}

class ImagesFetchedSuccessful extends ImageState {
  final List<DImage> images;

  const ImagesFetchedSuccessful(this.images);

  @override
  List<Object> get props => images;
}

class ImageSucessfulDeleted extends ImagesFetchedSuccessful {
  const ImageSucessfulDeleted(List<DImage> images) : super(images);
}

class ImageFailedDeleted extends ImagesFetchedSuccessful
    implements ImageFailureState {
  @override
  final Failure failure;
  const ImageFailedDeleted(List<DImage> images, this.failure) : super(images);
}

class ImageFailedFetch extends ImageFailureState {
  const ImageFailedFetch(Failure failure) : super(failure);
}
