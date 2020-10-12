import 'dart:io';

String fixture(String name) =>
    File('${Directory.current.path}/test/fixtures/$name').readAsStringSync();
