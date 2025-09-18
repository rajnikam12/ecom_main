import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

// Manages theme switching and persistence
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.system)) {
    on<SwitchThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      ThemeMode newThemeMode;
      if (state.themeMode == ThemeMode.light) {
        newThemeMode = ThemeMode.dark;
      } else {
        newThemeMode = ThemeMode.light;
      }
      await prefs.setString('theme', newThemeMode.toString());
      emit(ThemeState(themeMode: newThemeMode));
    });

    on<LoadThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString('theme') ?? 'ThemeMode.system';
      ThemeMode themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
      emit(ThemeState(themeMode: themeMode));
    });
  }
}
