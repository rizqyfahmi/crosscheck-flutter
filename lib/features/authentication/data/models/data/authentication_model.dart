import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';

class AuthenticationModel extends AuthenticationEntity {
  
  const AuthenticationModel({required super.token});
  
  factory AuthenticationModel.fromJSON(Map<String, dynamic> response) => AuthenticationModel(token: response["token"]);

  Map<String, dynamic> toJSON() => {"token": token};
}