import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
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
  
  // Mock Result
  const String generalError = "{\"message\": \"Something went wrong\"}";
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  AuthenticationResponseModel responseModel = const AuthenticationResponseModel(message: "The request has succeeded", data: AuthenticationModel(token: token));

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client: mockClient);
  });

  test("Should return AuthenticationResponseModel", () async {
    final String filepath = stringify("test/features/authentication/data/models/response/authentication_response.json");
    when(
      mockClient.post(
        any, 
        headers: {"Content-Type": "application/json"},
        body: {
          "name": "Fulan", "email": "fulan@email.com", "password": "fulan123", "confirmPassword": "fulan123"
        }
      )
    ).thenAnswer((_) async => http.Response(filepath, 200));

    final result = await remoteDataSource.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    );

    expect(result, equals(responseModel));
  });

  test("Should throw a ServerException when the response is 500", () async {
    when(
      mockClient.post(
        any,
        headers: {"Content-Type": "application/json"},
        body: {
          "name": "Fulan", "email": "fulan@email.com", "password": "fulan123", "confirmPassword": "fulan123"
        }
      )
    ).thenAnswer((_) async => http.Response(generalError, 500));
    
    final call = remoteDataSource.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    );

    expect(() => call, throwsA(const TypeMatcher<ServerException>()));
  });

  test("Should throw a ServerException with error fields when registration is faild because of validation error", () async {
    final String filepath = stringify("test/features/authentication/data/models/response/authentication_validation_error.json");
    final ServerException expected = ServerException(message: "Bad request", errors: const [
        {
          "field": "name",
          "message":  "Your name should contain at least 8 characters"
        },
        {"field": "email", "message":  "Please enter a valid email address"},
        {
          "field": "password",
          "message": "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required."
        },
        {
          "field": "confirmPassword",
          "message":  "Your password and confirmation password do not match"
        }
      ]
    );

    when(
      mockClient.post(
        any,
        headers: {"Content-Type": "application/json"},
        body: {
          "name": "Fulan", "email": "fulan@email.com", "password": "fulan123", "confirmPassword": "fulan123"
        }
      )
    ).thenAnswer((_) async => http.Response(filepath, 400));
    
    final call = remoteDataSource.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    );

    expect(
      () => call, 
      throwsA(predicate((e) => e is ServerException && e == expected))
    );
  });

  test("Should return AuthenticationResponseModel when login is success", () async {
    final String filepath = stringify("test/features/authentication/data/models/response/authentication_response.json");
    when(
      mockClient.post(
        any,
        headers: {"Content-Type": "application/json"},
        body: {
          "username": "fulan@email.com",
          "password": "fulan123"
        }
      )
    ).thenAnswer((_) async => http.Response(filepath, 200));

    final result = await remoteDataSource.login(
      username: "fulan@email.com",password: "fulan123"
    );

    expect(result, equals(responseModel));
  });

  test("Should throw a ServerException when login is failed because of 500", () async {
    when(
      mockClient.post(
        any,
        headers: {"Content-Type": "application/json"},
        body: {
          "username": "fulan@email.com",
          "password": "fulan123"
        }
      )
    ).thenAnswer((_) async => http.Response(generalError, 500));
    
    final call = remoteDataSource.login(
      username: "fulan@email.com", password: "fulan123"
    );

    expect(() => call, throwsA(const TypeMatcher<ServerException>()));
  });
}