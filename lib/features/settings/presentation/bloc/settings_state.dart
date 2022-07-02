import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'settings_model.dart';

abstract class SettingsState extends Equatable {
  
  final SettingsModel model;

  const SettingsState({required this.model});

  @override
  List<Object?> get props => [model];
  
}

class SettingsInit extends SettingsState {
  
  SettingsInit() : super(model: SettingsModel(themeMode: Brightness.light, themeData: SettingsModel.light));
  
}

class SettingsThemeChanged extends SettingsState {
  const SettingsThemeChanged({required super.model});
}

class SettingsNoChanged extends SettingsState {
  const SettingsNoChanged({required super.model});
}

class SettingsLoading extends SettingsState {
  const SettingsLoading({required super.model});
}

class SettingsLoadingFinished extends SettingsState {
  const SettingsLoadingFinished({required super.model});
}

class SettingsIdle extends SettingsState {
  const SettingsIdle({required super.model});
}

class SettingsGeneralError extends SettingsState {

  final String? title;
  final String message;

  const SettingsGeneralError({this.title, required this.message, required super.model});

  @override
  List<Object?> get props => [...super.props, title, message];
}
