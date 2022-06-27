import 'package:crosscheck/core/param/param.dart';
import 'package:flutter/material.dart';

class SettingsParams extends Param {

  final Brightness themeMode;
  
  SettingsParams({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];

}