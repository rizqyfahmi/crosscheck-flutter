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