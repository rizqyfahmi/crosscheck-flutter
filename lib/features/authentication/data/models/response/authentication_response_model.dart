import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';

class AuthenticationResponseModel extends Response {
  
  const AuthenticationResponseModel({
    required super.message,
    super.data
  });

  factory AuthenticationResponseModel.fromJSON(Map<String, dynamic> response) {
    return AuthenticationResponseModel(
      message: response["message"],
      data: AuthenticationModel.fromJSON(response["data"])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "message":  message,
      "data": data
    };
  }

  String get token => (super.data as AuthenticationModel).token;
}