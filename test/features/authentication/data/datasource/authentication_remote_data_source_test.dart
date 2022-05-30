import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../utils/stringify.dart';
import 'authentication_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late AuthenticationRemoteDataSource remoteDataSource;
  late RegistrationParams registrationParams;

  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  AuthenticationResponseModel responseModel = AuthenticationResponseModel(message: "The request has succeeded", data: const AuthenticationModel(token: token));

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client: mockClient);
    registrationParams = const RegistrationParams(name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123");
  });

  test("Should return AuthenticationResponseModel", () async {
    final String filepath = stringify("test/features/authentication/data/models/response/authentication_response.json");
    when(mockClient.get(any, headers: {"Content-Type": "application/json"})).thenAnswer((_) async => http.Response(filepath, 200));

    final result = await remoteDataSource.registration(registrationParams);

    expect(result, equals(responseModel));
  });

  test("Should throw a ServerException when the response is 404", () async {
    when(mockClient.get(any, headers: {"Content-Type": "application/json"})).thenAnswer((_) async => http.Response("Something went wrong", 400));
    
    final call = remoteDataSource.registration(registrationParams);

    expect(() => call, throwsA(const TypeMatcher<ServerException>()));
  });
}