part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class FetchImages extends ImageEvent {
  final int id;

  const FetchImages(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteImage extends ImageEvent {
  final int id;

  const DeleteImage(this.id);

  @override
  List<Object> get props => [id];
}
