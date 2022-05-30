import 'dart:convert';
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  
  Future<AuthenticationResponseModel> registration(RegistrationParams params);
  
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

    if (response.statusCode != 200) {
      throw ServerException(message: response.body);
    }

    final body = jsonDecode(response.body);
    return AuthenticationResponseModel.fromJSON(body);
  }
  
}