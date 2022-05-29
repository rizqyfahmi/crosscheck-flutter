import 'package:crosscheck/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfo networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  final hasConnectionFuture = Future.value(true);
  
  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockInternetConnectionChecker);
  });

  test("Should forward the call to InternetConnectionChecker.hasConnection", () {
    when(mockInternetConnectionChecker.hasConnection).thenAnswer((_) => hasConnectionFuture);

    // We don't use async await because we only want to forward "hasConnection" result, not else.
    final result = networkInfo.isConnected;
    // Utilizing Dart's default referential equality.
    // Only references to the same object are equal.
    expect(result, hasConnectionFuture);
    // Check that mockInternetConnectionChecker.hasConnection is called
    verify(mockInternetConnectionChecker.hasConnection);
  });
}