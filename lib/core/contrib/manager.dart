abstract class Manager {
  bool prepared;

  Manager() {
    prepared = false;
  }

  Future<void> setup() async {
    prepared = true;
  }

  Future<void> dispose() async {}
}
