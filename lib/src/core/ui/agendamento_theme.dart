import 'package:flutter/material.dart';

import 'constants.dart';

sealed class AgendamentoTheme {
  static const OutlineInputBorder _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(color: ColorsConstants.grey),
  );
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorsConstants.pink),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: Colors.black,
          fontFamily: FontConstants.fontFamily,
        )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: ColorsConstants.grey),
      border: _defaultInputBorder,
      enabledBorder: _defaultInputBorder,
      focusedBorder: _defaultInputBorder,
      errorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(
          color: ColorsConstants.red,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: ColorsConstants.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: ColorsConstants.pink,
          width: 1,
        ),
        foregroundColor: ColorsConstants.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    fontFamily: FontConstants.fontFamily,
  );
}
