import 'package:equatable/equatable.dart';

// This model is used to manage view/IU only
class LoginModel extends Equatable {
  final String username;
  final String password;

  const LoginModel({
    this.username = "",
    this.password = "",
  });

  LoginModel copyWith({
    String? username,
    String? password,
    double? contentHeight,
    double? contentOpacity
  }) {
    return LoginModel(
      username: username ?? this.username, 
      password: password ?? this.password
    );
  }

  @override
  List<Object?> get props => [username, password];
  
}