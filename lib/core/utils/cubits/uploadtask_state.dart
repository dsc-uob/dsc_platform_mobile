part of 'uploadtask_cubit.dart';

abstract class UploadtaskState extends Equatable {
  const UploadtaskState();

  @override
  List<Object> get props => [];
}

class UploadtaskInitial extends UploadtaskState {}

class UploadtaskProgress extends UploadtaskState {
  final double progress;

  const UploadtaskProgress(this.progress);

  @override
  List<Object> get props => [progress];
}

class UploadtaskFailed extends UploadtaskState {
  final Failure failure;

  const UploadtaskFailed(this.failure);

  @override
  List<Object> get props => [failure];
}

class UploadtaskSuccess extends UploadtaskState {
  final String url;

  const UploadtaskSuccess(this.url);

  @override
  List<Object> get props => [url];
}
