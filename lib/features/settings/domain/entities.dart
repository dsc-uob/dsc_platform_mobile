import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Settings extends Equatable {
  final String langCode;
  final String fontFamily;

  const Settings({
    @required this.langCode,
    @required this.fontFamily,
  });

  @override
  List<Object> get props => [langCode, fontFamily];
}
