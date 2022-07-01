import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:crosscheck/features/profile/presentation/bloc/profile_event.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_state.dart';
import 'package:crosscheck/features/settings/presentation/view/settings_view.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'settings_view_test.mocks.dart';

@GenerateMocks([
  SetThemeUsecase,
  GetThemeUsecase,
  GetProfileUsecase
])
void main() {
  late MockSetThemeUsecase mockSetThemeUsecase;
  late MockGetThemeUsecase mockGetThemeUsecase;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late SettingsBloc settingsBloc;
  late ProfileBloc profileBloc;
  late Widget testWidget;

  setUp((){
    mockSetThemeUsecase = MockSetThemeUsecase();
    mockGetThemeUsecase = MockGetThemeUsecase();
    mockGetProfileUsecase = MockGetProfileUsecase();
    settingsBloc = SettingsBloc(setThemeUsecase: mockSetThemeUsecase, getThemeUsecase: mockGetThemeUsecase);
    profileBloc = ProfileBloc(getProfileUsecase: mockGetProfileUsecase);
    testWidget = buildWidget(settingsBloc: settingsBloc, profileBloc: profileBloc);
  });

  testWidgets("Should get theme properly", (WidgetTester tester) async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => Right(ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      
      expect(find.byType(Scaffold), findsOneWidget);
      Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

      await tester.pumpAndSettle();

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);

    });

  });

  testWidgets("Should not change the theme when get theme is failed", (WidgetTester tester) async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => Right(ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      
      expect(find.byType(Scaffold), findsOneWidget);
      Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

      await tester.pumpAndSettle();

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

    });

  });

  testWidgets("Should set theme properly", (WidgetTester tester) async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockSetThemeUsecase(any)).thenAnswer((_) async => const Right(null));
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => Right(ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      
      expect(find.byType(Scaffold), findsOneWidget);
      Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

      await tester.pumpAndSettle();

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);

      expect(find.byKey(const Key("switchDarkMode")), findsOneWidget);
      await tester.tap(find.byKey(const Key("switchDarkMode")));
      await tester.pumpAndSettle();

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });

  });

  testWidgets("Should not change the theme when set theme is failed", (WidgetTester tester) async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));
    when(mockSetThemeUsecase(any)).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));
    when(mockGetProfileUsecase(any)).thenAnswer((_) async => Right(ProfileEntity(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60")));

    await tester.runAsync(() async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testWidget));
      
      expect(find.byType(Scaffold), findsOneWidget);
      Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);

      await tester.pumpAndSettle();

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);

      expect(find.byKey(const Key("switchDarkMode")), findsOneWidget);
      await tester.tap(find.byKey(const Key("switchDarkMode")));
      await tester.pumpAndSettle();

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, CustomColors.secondary);
    });

  });
}

Widget buildWidget({
  required SettingsBloc settingsBloc,
  required ProfileBloc profileBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(
        create: (_) => settingsBloc..add(SettingsLoad())
      ),
      BlocProvider<ProfileBloc>(
        create: (_) => profileBloc..add(ProfileGetData())
      ),
    ], 
    child: BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          theme: state.model.themeData,
          home: const SettingsView(),
        );
      }
    )
  );
}