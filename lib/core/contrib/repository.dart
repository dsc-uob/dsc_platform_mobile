abstract class Repository {
  bool prepared;

  Repository() {
    prepared = false;
  }

  Future<void> setup() async {
    prepared = true;
  }

  Future<void> dispose() async {}
}
