
import 'package:crosscheck/features/settings/domain/usecase/get_theme_usecase.dart';
import 'package:crosscheck/features/settings/domain/usecase/set_theme_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  final SetThemeUsecase setThemeUsecase;
  final GetThemeUsecase getThemeUsecase;

  SettingsBloc(super.initialState, this.setThemeUsecase, this.getThemeUsecase);
  
}