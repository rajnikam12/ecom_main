part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

// Triggers theme switching (light/dark)
class SwitchThemeEvent extends ThemeEvent {}

// Loads saved theme from preferences
class LoadThemeEvent extends ThemeEvent {}