
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/settings/data/models/params/settings_params.dart';
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:crosscheck/features/settings/presentation/bloc/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final SetThemeUsecase setThemeUsecase;
  final GetThemeUsecase getThemeUsecase;

  SettingsBloc({
    required this.setThemeUsecase,
    required this.getThemeUsecase
  }) : super(SettingsInit()) {
    on<SettingsLoad>((event, emit) async {
      final response = await getThemeUsecase(NoParam());
      response.fold(
        (_) {
          emit(SettingsNoChanged(model: state.model));
        }, 
        (result) {
          ThemeData themeData = SettingsModel.light;

          if (result.themeMode == Brightness.dark) {
            themeData = SettingsModel.dark;
          }

          emit(SettingsThemeChanged(model: SettingsModel(themeMode: themeData.brightness, themeData: themeData)));
        }
      );
    });
    on<SettingsChangeTheme>((event, emit) async {
      ThemeData themeData = state.model.themeData;

      switch (event.themeMode) {
        case Brightness.dark:
          themeData = SettingsModel.dark;
          break;
        default: 
          themeData = SettingsModel.light;
      }

      final response = await setThemeUsecase(SettingsParams(themeMode: themeData.brightness));
      response.fold(
        (_) {
          emit(SettingsNoChanged(model: state.model));
        }, 
        (_) {
          emit(SettingsThemeChanged(model: SettingsModel(themeMode: themeData.brightness, themeData: themeData)));
        } 
      );
    });
  }
  
}