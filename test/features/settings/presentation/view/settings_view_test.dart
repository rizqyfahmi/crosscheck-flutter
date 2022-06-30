import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/core/error/failure.dart';
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

import 'settings_view_test.mocks.dart';

@GenerateMocks([
  SetThemeUsecase,
  GetThemeUsecase
])
void main() {
  late MockSetThemeUsecase mockSetThemeUsecase;
  late MockGetThemeUsecase mockGetThemeUsecase;
  late SettingsBloc settingsBloc;
  late Widget testWidget;

  setUp((){
    mockSetThemeUsecase = MockSetThemeUsecase();
    mockGetThemeUsecase = MockGetThemeUsecase();
    settingsBloc = SettingsBloc(setThemeUsecase: mockSetThemeUsecase, getThemeUsecase: mockGetThemeUsecase);
    testWidget = buildWidget(settingsBloc: settingsBloc);
  });

  testWidgets("Should get theme properly", (WidgetTester tester) async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      
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

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      
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

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      
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

    await tester.runAsync(() async {
      await tester.pumpWidget(testWidget);
      
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
  required SettingsBloc settingsBloc
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(
        create: (_) => settingsBloc..add(SettingsLoad())
      )
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