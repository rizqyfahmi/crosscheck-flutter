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