import 'package:flutter/material.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(true);
bool get isLight => themeNotifier.value;
set isLight(bool value) => themeNotifier.value = value;

//Accent
const Color primaryAccent = Color(0xFF14E56A);
const List<Color> secondaryAccent = [Color(0xFFE2FBEB), Color(0xFF0C4F2E)];

// Background Colors
const List<Color> appBackground = [Color(0xFFFFFFFF), Color(0xFF12241D)];

// Text Colors
const List<Color> primaryText = [Color(0xFF101820), Color(0xFFFFFFFF)];
const List<Color> secondaryText = [Color(0xFF768089), Color(0xFF8D98A0)];
