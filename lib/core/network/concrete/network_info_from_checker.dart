import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:practise_parser/core/network/network_info.dart';

class NetworkInfoFromChecker implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  const NetworkInfoFromChecker({
    required this.connectionChecker
  });

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}