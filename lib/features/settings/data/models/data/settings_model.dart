import 'package:crosscheck/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter/material.dart';

class SettingsModel extends SettingsEntity {
  
  const SettingsModel({required super.themeMode});

  factory SettingsModel.fromJSON(Map<String, dynamic> response) => SettingsModel(themeMode: Brightness.values[response["themeMode"]]);

  Map<String, dynamic> toJSON() => {"themeMode": super.themeMode.index};
  
}