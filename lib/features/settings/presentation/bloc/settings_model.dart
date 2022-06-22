import 'package:crosscheck/assets/colors/custom_colors.dart';
import 'package:crosscheck/assets/fonts/fonts.dart';
import 'package:crosscheck/core/widgets/styles/text_styles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsModel extends Equatable {

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    shadowColor: Colors.black.withOpacity(0.5),
    backgroundColor: CustomColors.secondary,
    fontFamily: FontFamily.poppins,
    colorScheme: const ColorScheme(
      brightness: Brightness.light, 
      primary: CustomColors.primary, 
      onPrimary: Colors.white, 
      secondary: CustomColors.secondary, 
      onSecondary: Colors.white, 
      error: CustomColors.primary, 
      onError: CustomColors.secondary, 
      background: Colors.white, 
      onBackground: CustomColors.secondary, 
      surface: Colors.white, 
      onSurface: Colors.white,
      surfaceTint: CustomColors.placeholderText
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyles.poppinsBold34,
      headline1: TextStyles.poppinsBold24,
      headline2: TextStyles.poppinsBold20,
      subtitle1: TextStyles.poppinsBold16,
      subtitle2: TextStyles.poppinsRegular16,
      bodyText1: TextStyles.poppinsRegular14,
      bodyText2: TextStyles.poppinsRegular12,
      button: TextStyles.poppinsRegular16
    )
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    shadowColor: Colors.black.withOpacity(0.5),
    backgroundColor: CustomColors.secondary,
    fontFamily: FontFamily.poppins,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark, 
      primary: CustomColors.primary, 
      onPrimary: Colors.white, 
      secondary: CustomColors.secondary, 
      onSecondary: Colors.white, 
      error: CustomColors.primary, 
      onError: CustomColors.secondary, 
      background: CustomColors.secondary, 
      onBackground: Colors.white, 
      surface: Colors.white, 
      onSurface: Colors.white,
      surfaceTint: CustomColors.placeholderText
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyles.poppinsBold34,
      headline1: TextStyles.poppinsBold24,
      headline2: TextStyles.poppinsBold20,
      subtitle1: TextStyles.poppinsBold16,
      subtitle2: TextStyles.poppinsRegular16,
      bodyText1: TextStyles.poppinsRegular14,
      bodyText2: TextStyles.poppinsRegular12,
      button: TextStyles.poppinsRegular16
    )
  );

  final Brightness themeMode;
  final ThemeData themeData;

  const SettingsModel({
    required this.themeMode,
    required this.themeData
  });

  @override
  List<Object?> get props => [themeMode, themeData];
  
}