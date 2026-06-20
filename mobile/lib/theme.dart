import 'package:flutter/material.dart';

const kBrand    = Color(0xFFF97316);
const kBg       = Color(0xFF0C0A09);
const kSurface  = Color(0xFF1C1917);
const kBorder   = Color(0xFF292524);
const kTextMute = Color(0xFF78716C);

ThemeData appTheme() => ThemeData(
  scaffoldBackgroundColor: kBg,
  colorScheme: ColorScheme.dark(
    primary:   kBrand,
    surface:   kSurface,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBg,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kBrand, width: 1.5),
    ),
    labelStyle: const TextStyle(color: kTextMute, fontSize: 13),
    hintStyle: const TextStyle(color: kTextMute, fontSize: 13),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kBrand,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
);
