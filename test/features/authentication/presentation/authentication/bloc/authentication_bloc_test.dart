import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthenticationBloc bloc;
  
  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    bloc = AuthenticationBloc();
  });

  test("Should return Unauthenticated() at first time ", () {
    expect(bloc.state, const Unauthenticated());
  });

  test("Should return Authenticated() when token is set", () {
    final expected = [
      const Authenticated(token: token)
    ];

    bloc.add(const AuthenticationSetToken(token: token));

    // expect stream value
    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test("Should return UnAuthenticated() when token is reset", () {
    final expected = [
      const Unauthenticated()
    ];

    bloc.add(AuthenticationResetToken());

    // expect stream value
    expectLater(bloc.stream, emitsInOrder(expected));
  });
}