import 'package:crosscheck/core/response/response.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';

class AuthenticationResponseModel extends Response {
  @override
  final String message;
  @override
  final AuthenticationModel data;

  const AuthenticationResponseModel({
    required this.message,
    required this.data
  }) : super(message: message, data: data);

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