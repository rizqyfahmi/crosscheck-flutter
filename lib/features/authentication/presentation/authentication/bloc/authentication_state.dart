import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  final String token;

  const AuthenticationState({required this.token});

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated() : super(token: "");
}
class Authenticated extends AuthenticationState {
  const Authenticated({required super.token});
}
