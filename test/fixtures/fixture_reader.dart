import 'dart:io';

String fixture(String name) =>
    File('${Directory.current.path}/fixtures/$name').readAsStringSync();
