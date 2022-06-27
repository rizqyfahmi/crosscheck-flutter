import 'dart:convert';
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationResponseModel> registration({
    required String name,
    required String email,
    required String password,
    required String confirmPassword
  });

  Future<AuthenticationResponseModel> login({
    required String username,
    required String password
  });
  
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {

  final http.Client client;

  AuthenticationRemoteDataSourceImpl({
    required this.client
  });
  
  @override
  Future<AuthenticationResponseModel> registration({
    required String name,
    required String email,
    required String password,
    required String confirmPassword
  }) async {
    final response = await client.post(
      Uri.parse("http://localhost:8080"),
      headers: {
        "Content-Type": "application/json"
      }, 
      body: {
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword
      }
    );

    final body = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return AuthenticationResponseModel.fromJSON(body);
    }

    if (body["data"] != null) {
      final errors = (body["data"]["errors"] as List).map((error) {
        return {
          "field": error["field"],
          "message":  error["message"]
        };
      }).toList();
      throw ServerException(message: body["message"], errors: errors);  
    }

    throw ServerException(message: body["message"]);
  }
  
  @override
  Future<AuthenticationResponseModel> login({
    required String username,
    required String password
  }) async {
    final response = await client.post(
      Uri.parse("http://localhost:8080/auth/login"),
      headers: {
        "Content-Type": "application/json"
      },
      body: {
        "username": username,
        "password": password,
      }
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthenticationResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
}