import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  
  @override
  List<Object?> get props => [];

}

class SettingsLoad extends SettingsEvent {}
class SettingsChangeTheme extends SettingsEvent {
  
  final Brightness themeMode;

  SettingsChangeTheme({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];

}

class SettingsSetLoading extends SettingsEvent {}
class SettingsFinishLoading extends SettingsEvent {}
class SettingsResetGeneralError extends SettingsEvent {}
class SettingsSetGeneralError extends SettingsEvent {
  final String? title;
  final String message;

  SettingsSetGeneralError({this.title, required this.message});

  @override
  List<Object?> get props => [title, message];
}