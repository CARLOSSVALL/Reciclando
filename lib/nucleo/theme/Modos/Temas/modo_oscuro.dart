import 'package:flutter/material.dart';

/// Tema oscuro de Reciclando - Verde reciclaje en modo noche
ThemeData modoOscuro() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.dark,
      primary: const Color(0xFF66BB6A), // Verde medio para botones
      onPrimary: const Color(0xFF1B5E20), // Texto sobre verde
      secondary: const Color(0xFF81C784),
      onSecondary: const Color(0xFF1B5E20),
      surface: const Color(0xFF1A2E1A), // Verde muy oscuro para cards
      onSurface: const Color(0xFFC8E6C9), // Verde claro para texto
      tertiary: const Color(0xFF4CAF50),
    ),
    scaffoldBackgroundColor: const Color(0xFF0D1F0D), // Fondo muy oscuro verde
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1F0D),
      foregroundColor: Color(0xFF66BB6A),
      iconTheme: IconThemeData(color: Color(0xFF66BB6A)),
      titleTextStyle: TextStyle(
        color: Color(0xFF66BB6A),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A2E1A),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF66BB6A),
        foregroundColor: const Color(0xFF0D1F0D),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF66BB6A),
      foregroundColor: Color(0xFF0D1F0D),
      elevation: 4,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A2E1A),
      selectedColor: const Color(0xFF4CAF50),
      labelStyle: const TextStyle(color: Color(0xFFC8E6C9)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF66BB6A).withValues(alpha: 0.12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1A2E1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: const Color(0xFFC8E6C9),
      ),
    ),
  );
}
