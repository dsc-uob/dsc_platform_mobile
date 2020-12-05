
import 'package:data_connection_checker/data_connection_checker.dart';

import '../contrib/manager.dart';

abstract class NetworkInfo extends Manager {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<void> setup() {
    // connectionChecker.addresses = [
    //   AddressCheckOptions(
    //     InternetAddress(server_ip),
    //      port: server_port,
    //   ),
    // ];
    return super.setup();
  }

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
