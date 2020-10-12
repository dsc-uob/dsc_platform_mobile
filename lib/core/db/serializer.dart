abstract class Serializer<Obj> {
  final Obj object;

  const Serializer(this.object);

  Map<String, dynamic> generateMap();
}
