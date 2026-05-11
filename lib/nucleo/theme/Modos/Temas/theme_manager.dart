import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reciclando/nucleo/theme/Modos/Temas/predeterminado.dart';
import 'package:reciclando/nucleo/theme/Modos/Temas/modo_oscuro.dart';
import 'package:reciclando/nucleo/utils/app_logger.dart';

/// Gestor de temas singleton para Reciclando.
/// Usa SharedPreferences en lugar de Drift para persistir el tema.
class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  int _currentThemeId = 0; // 0 = claro, 1 = oscuro

  int get currentThemeId => _currentThemeId;

  ThemeData get currentTheme {
    switch (_currentThemeId) {
      case 0:
        return temaPredeterminado();
      case 1:
        return modoOscuro();
      default:
        return temaPredeterminado();
    }
  }

  /// Carga el tema inicial desde SharedPreferences
  Future<void> loadInitialTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentThemeId = prefs.getInt('themeId') ?? 0;
      notifyListeners();
      AppLogger.info('Tema inicial cargado: $_currentThemeId',
          tag: 'ThemeManager');
    } catch (e) {
      AppLogger.error('Error cargando tema inicial',
          tag: 'ThemeManager', error: e);
    }
  }

  /// Cambia el tema y persiste en SharedPreferences
  Future<void> setTheme(int themeId) async {
    if (_currentThemeId != themeId) {
      _currentThemeId = themeId;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeId', themeId);
      AppLogger.info('Tema cambiado a: $themeId', tag: 'ThemeManager');
    }
  }

  /// Alterna entre tema claro y oscuro
  Future<void> toggleTheme() async {
    await setTheme(_currentThemeId == 0 ? 1 : 0);
  }
}
