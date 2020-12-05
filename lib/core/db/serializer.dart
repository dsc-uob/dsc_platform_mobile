abstract class BaseSerializer<Obj> {
  final Obj object;

  const BaseSerializer(this.object);

  dynamic generateMap();
}

abstract class MapSerializer<Obj> extends BaseSerializer {
  final Obj object;

  const MapSerializer(this.object) : super(object);

  Map<String, dynamic> generateMap();
}

class ListSerializer<T extends MapSerializer> extends BaseSerializer<List<T>> {
  final dynamic key;
  ListSerializer(
    List<T> object, {
    this.key,
  }) : super(object);

  @override
  List generateMap() => List<Map<String, dynamic>>.generate(
        object.length,
        (index) => object[index].generateMap(),
      );
}
