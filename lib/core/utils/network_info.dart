import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';

import '../constant.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker) {
    connectionChecker.addresses = [
      AddressCheckOptions(
        InternetAddress(server_ip),
        port: server_port,
      ),
    ];
  }

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
