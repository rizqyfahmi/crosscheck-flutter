import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsEntity extends Equatable {
  
  final Brightness themeMode;

  const SettingsEntity({ required this.themeMode });

  @override
  List<Object?> get props => [themeMode];
  
}