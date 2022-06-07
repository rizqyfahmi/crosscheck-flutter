import 'package:equatable/equatable.dart';

// This model is used to manage view/IU only
class LoginModel extends Equatable {
  final String username;
  final String password;
  final double contentHeight;
  final double contentOpacity;

  const LoginModel({
    this.username = "",
    this.password = "",
    this.contentHeight = 0,
    this.contentOpacity = 0
  });

  LoginModel copyWith({
    String? username,
    String? password,
    double? contentHeight,
    double? contentOpacity
  }) {
    return LoginModel(
      username: username ?? this.username, 
      password: password ?? this.password, 
      contentHeight: contentHeight ?? this.contentHeight, 
      contentOpacity: contentOpacity ?? this.contentOpacity
    );
  }

  @override
  List<Object?> get props => [username, password, contentHeight, contentOpacity];
  
}