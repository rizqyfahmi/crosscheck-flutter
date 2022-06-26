import 'dart:convert';
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationResponseModel> registration(RegistrationParams params);

  Future<AuthenticationResponseModel> login(LoginParams params);
  
}

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {

  final http.Client client;

  AuthenticationRemoteDataSourceImpl({
    required this.client
  });
  
  @override
  Future<AuthenticationResponseModel> registration(RegistrationParams params) async {
    final response = await client.get(
      Uri.parse("http://localhost:8080"),
      headers: {
        "Content-Type": "application/json"
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
  Future<AuthenticationResponseModel> login(LoginParams params) async {
    final response = await client.get(
      Uri.parse("http://localhost:8080/auth/login"),
      headers: {
        "Content-Type": "application/json"
      }
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthenticationResponseModel.fromJSON(body);
    }

    throw ServerException(message: body["message"]);
  }
  
}