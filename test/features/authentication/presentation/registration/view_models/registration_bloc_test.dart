import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'registration_bloc_test.mocks.dart';

@GenerateMocks([
  RegistrationUsecase
])
void main() {
  late MockRegistrationUsecase mockUsecase;
  late RegistrationBloc bloc;

  setUp(() {
    mockUsecase = MockRegistrationUsecase();
    bloc = RegistrationBloc(registrationUsecase: mockUsecase);
  });

  test("Should return Initial() at first time", () {
    expect(bloc.state, const RegistrationState());
  });

  group("Field Testing", () {
    setUp(() {
      mockUsecase = MockRegistrationUsecase();
      bloc = RegistrationBloc(registrationUsecase: mockUsecase);
    });
    test("Should keep value when each field is entered in separately", () {
      final expected = [
        const RegistrationState(name: "F"),
        const RegistrationState(name: "Fu"),
        const RegistrationState(name: "Ful"),
        const RegistrationState(name: "Fula"),
        const RegistrationState(name: "Fulan"),
        const RegistrationState(name: "Fulan", email: "f"),
        const RegistrationState(name: "Fulan", email: "fu"),
        const RegistrationState(name: "Fulan", email: "ful"),
        const RegistrationState(name: "Fulan", email: "fula"),
        const RegistrationState(name: "Fulan", email: "fulan"),
        const RegistrationState(name: "Fulan", email: "fulan@"),
        const RegistrationState(name: "Fulan", email: "fulan@e"),
        const RegistrationState(name: "Fulan", email: "fulan@em"),
        const RegistrationState(name: "Fulan", email: "fulan@ema"),
        const RegistrationState(name: "Fulan", email: "fulan@emai"),
        const RegistrationState(name: "Fulan", email: "fulan@email"),
        const RegistrationState(name: "Fulan", email: "fulan@email."),
        const RegistrationState(name: "Fulan", email: "fulan@email.c"),
        const RegistrationState(name: "Fulan", email: "fulan@email.co"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "P"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Pa"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Pas"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Pass"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Passw"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Passwo"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Passwor"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "P"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Pa"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Pas"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Pass"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Passw"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Passwo"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Passwor"),
        const RegistrationState(name: "Fulan", email: "fulan@email.com", password: "Password", confirmPassword: "Password")
      ];

      expectLater(bloc.stream, emitsInOrder(expected));

      bloc.add(const RegistrationSetName("F"));
      bloc.add(const RegistrationSetName("Fu"));
      bloc.add(const RegistrationSetName("Ful"));
      bloc.add(const RegistrationSetName("Fula"));
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("f"));
      bloc.add(const RegistrationSetEmail("fu"));
      bloc.add(const RegistrationSetEmail("ful"));
      bloc.add(const RegistrationSetEmail("fula"));
      bloc.add(const RegistrationSetEmail("fulan"));
      bloc.add(const RegistrationSetEmail("fulan@"));
      bloc.add(const RegistrationSetEmail("fulan@e"));
      bloc.add(const RegistrationSetEmail("fulan@em"));
      bloc.add(const RegistrationSetEmail("fulan@ema"));
      bloc.add(const RegistrationSetEmail("fulan@emai"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetEmail("fulan@email."));
      bloc.add(const RegistrationSetEmail("fulan@email.c"));
      bloc.add(const RegistrationSetEmail("fulan@email.co"));
      bloc.add(const RegistrationSetEmail("fulan@email.com"));
      bloc.add(const RegistrationSetPassword("P"));
      bloc.add(const RegistrationSetPassword("Pa"));
      bloc.add(const RegistrationSetPassword("Pas"));
      bloc.add(const RegistrationSetPassword("Pass"));
      bloc.add(const RegistrationSetPassword("Passw"));
      bloc.add(const RegistrationSetPassword("Passwo"));
      bloc.add(const RegistrationSetPassword("Passwor"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("P"));
      bloc.add(const RegistrationSetConfirmPassword("Pa"));
      bloc.add(const RegistrationSetConfirmPassword("Pas"));
      bloc.add(const RegistrationSetConfirmPassword("Pass"));
      bloc.add(const RegistrationSetConfirmPassword("Passw"));
      bloc.add(const RegistrationSetConfirmPassword("Passwo"));
      bloc.add(const RegistrationSetConfirmPassword("Passwor"));
      bloc.add(const RegistrationSetConfirmPassword("Password"));
    });

    test("Should keep value even though return error fields", () {
      final expected = [
        const RegistrationState(name: "Fulan"),
        const RegistrationState(name: "Fulan", email: "fulan@email"),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password"),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password", confirmPassword: "Password123"),
        const RegistrationState(
          name: "Fulan", errorName: "Your name should contain at least 8 characters", 
          email: "fulan@email", errorEmail: "Please enter a valid email address", 
          password: "Password", errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
          confirmPassword: "Password123", errorConfirmPassword: "Your password and confirmation password do not match"
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(const RegistrationSetErrorFields(
          errorName: "Your name should contain at least 8 characters",
          errorEmail: "Please enter a valid email address", 
          errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
          errorConfirmPassword: "Your password and confirmation password do not match"
        )
      );
    });

    test("Should reset error fields", () {
      final expected = [
        const RegistrationState(name: "Fulan"),
        const RegistrationState(name: "Fulan", email: "fulan@email"),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password"),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password", confirmPassword: "Password123"),
        const RegistrationState(
          name: "Fulan", errorName: "Your name should contain at least 8 characters", 
          email: "fulan@email", errorEmail: "Please enter a valid email address", 
          password: "Password", errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
          confirmPassword: "Password123", errorConfirmPassword: "Your password and confirmation password do not match"
        ),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password", confirmPassword: "Password123"),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(const RegistrationSetErrorFields(
          errorName: "Your name should contain at least 8 characters",
          errorEmail: "Please enter a valid email address", 
          errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
          errorConfirmPassword: "Your password and confirmation password do not match"
        )
      );
      bloc.add(RegistrationResetErrorFields());
    });

    test("Should reset all fields", () {
      final expected = [
        const RegistrationState(name: "Fulan"),
        const RegistrationState(name: "Fulan", email: "fulan@email"),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password"),
        const RegistrationState(name: "Fulan", email: "fulan@email", password: "Password", confirmPassword: "Password123"),
        const RegistrationState(
          name: "Fulan", errorName: "Your name should contain at least 8 characters", 
          email: "fulan@email", errorEmail: "Please enter a valid email address", 
          password: "Password", errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
          confirmPassword: "Password123", errorConfirmPassword: "Your password and confirmation password do not match"
        ),
        const RegistrationState(),
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(const RegistrationSetErrorFields(
          errorName: "Your name should contain at least 8 characters",
          errorEmail: "Please enter a valid email address", 
          errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.",
          errorConfirmPassword: "Your password and confirmation password do not match"
        )
      );
      bloc.add(RegistrationResetFields());
    });
  });

  
}