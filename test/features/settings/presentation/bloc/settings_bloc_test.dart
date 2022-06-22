import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart';
import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_event.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_model.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_bloc_test.mocks.dart';

@GenerateMocks([
  SetThemeUsecase,
  GetThemeUsecase
])
void main() {
  late MockSetThemeUsecase mockSetThemeUsecase;
  late MockGetThemeUsecase mockGetThemeUsecase;
  late SettingsBloc settingsBloc;

  setUp(() {
    mockSetThemeUsecase = MockSetThemeUsecase();
    mockGetThemeUsecase = MockGetThemeUsecase();

    settingsBloc = SettingsBloc(setThemeUsecase: mockSetThemeUsecase, getThemeUsecase: mockGetThemeUsecase);
  });

  test("Should return SettingsInit at first time", () {
    expect(settingsBloc.state, SettingsInit());
  });

  test("Should get theme properly", () async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => const Right(SettingsEntity(themeMode: Brightness.dark)));

    settingsBloc.add(SettingsLoad());

    expectLater(settingsBloc.stream, emitsInOrder([
      SettingsThemeChanged(model: SettingsModel(themeMode: Brightness.dark, themeData: SettingsModel.dark))
    ]));
    
    await untilCalled(mockGetThemeUsecase(NoParam()));
    verify(mockGetThemeUsecase(NoParam()));
  });

  test("Should return SettingsNoChange when get theme is failed", () async {
    when(mockGetThemeUsecase(any)).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));

    settingsBloc.add(SettingsLoad());

    expectLater(settingsBloc.stream, emitsInOrder([
      SettingsNoChanged(model: SettingsModel(themeMode: Brightness.light, themeData: SettingsModel.light))
    ]));
    
    await untilCalled(mockGetThemeUsecase(NoParam()));
    verify(mockGetThemeUsecase(NoParam()));
  });

  test("Should set theme properly", () async {
    const params = SettingsParams(themeMode: Brightness.dark);
    when(mockSetThemeUsecase(any)).thenAnswer((_) async => const Right(null));

    settingsBloc.add(SettingsChangeTheme(themeMode: Brightness.dark));

    expectLater(settingsBloc.stream, emitsInOrder([
      SettingsThemeChanged(model: SettingsModel(themeMode: Brightness.dark, themeData: SettingsModel.dark))
    ]));

    await untilCalled(mockSetThemeUsecase(params));
    verify(mockSetThemeUsecase(params));
  });

  test("Should set theme properly", () async {
    const params = SettingsParams(themeMode: Brightness.dark);
    when(mockSetThemeUsecase(any)).thenAnswer((_) async => Left(CachedFailure(message: Failure.cacheError)));

    settingsBloc.add(SettingsChangeTheme(themeMode: Brightness.dark));

    expectLater(settingsBloc.stream, emitsInOrder([
      SettingsNoChanged(model: SettingsModel(themeMode: Brightness.light, themeData: SettingsModel.light))
    ]));

    await untilCalled(mockSetThemeUsecase(params));
    verify(mockSetThemeUsecase(params));
  });
}