import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl({
    required this.connectionChecker
  });
  
  @override // We don't use async await because we only want to forward "hasConnection" result, not else.
  Future<bool> get isConnected => connectionChecker.hasConnection;
  
}