import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';

class AuthenticationModel extends AuthenticationEntity {
  
  const AuthenticationModel({required super.token});
  
  factory AuthenticationModel.fromJSON(Map<String, dynamic> response) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJSON() {
    throw UnimplementedError();
  }
}