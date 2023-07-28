import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/DarkTheme/mytheme_preference.dart';

abstract class ThemeEvent {}

class ThemeChanged extends ThemeEvent {}

class InitTheme extends ThemeEvent {}

class ThemeState {
  final bool isDark;

  const ThemeState({this.isDark = false});
}

class ThemeBloc extends Bloc<ThemeEvent, bool> {
  late final mythemePrefrences = MyThemePreferences();
  ThemeBloc() : super(false) {
    on<ThemeChanged>(
      (ThemeChanged event, Emitter<bool> emit) async {
        emit(await mythemePrefrences.toggleTheme());
      },
    );

    on<InitTheme>((InitTheme event, Emitter<bool> emit) async {
      emit(await mythemePrefrences.getTheme());
    });
  }
}
