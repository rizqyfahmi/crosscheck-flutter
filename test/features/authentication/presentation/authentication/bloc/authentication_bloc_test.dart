import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthenticationBloc bloc;
  
  // Mock Result
  
  setUp(() {
    bloc = AuthenticationBloc();
  });

  test("Should return Unauthenticated() at first time ", () {
    expect(bloc.state, Unauthenticated());
  });

  test("Should return Authenticated() when token is set", () {
    final expected = [
      Authenticated()
    ];

    bloc.add(AuthenticationSetAuthenticated());

    // expect stream value
    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test("Should return UnAuthenticated() when token is reset", () {
    final expected = [
      Unauthenticated()
    ];

    bloc.add(AuthenticationSetUnauthenticated());

    // expect stream value
    expectLater(bloc.stream, emitsInOrder(expected));
  });
}