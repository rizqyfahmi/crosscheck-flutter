import 'package:equatable/equatable.dart';

// This model is used to manage view/IU only
class LoginModel extends Equatable {
  final String username;
  final String password;
  final double contentHeight;
  final double opacity;

  const LoginModel({
    this.username = "",
    this.password = "",
    this.contentHeight = 0,
    this.opacity = 0
  });

  @override
  List<Object?> get props => [username, password, contentHeight, opacity];
  
}