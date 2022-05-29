import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';

class AuthenticationResponseModel implements Response {
  @override
  final String message;
  @override
  final AuthenticationModel data;

  AuthenticationResponseModel({
    required this.message,
    required this.data
  });

  factory AuthenticationResponseModel.fromJSON(Map<String, dynamic> response) {
    return AuthenticationResponseModel(
      message: response["message"],
      data: AuthenticationModel.fromJSON(response["data"])
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "message": message,
      "data": data
    };
  }
}