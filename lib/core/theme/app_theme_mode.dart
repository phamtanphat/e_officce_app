import 'package:e_officce_tfc/core/constants/constant.dart';
import 'package:e_officce_tfc/core/storage/local/shared_preference_provider.dart';
import 'package:e_officce_tfc/core/theme/app_color.dart';
import 'package:e_officce_tfc/core/theme/app_text_styles.dart';
import 'package:e_officce_tfc/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme_mode.g.dart';

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  Future<ThemeMode> build() async {
    final storage = ref.watch(storageServiceProvider);
    final themeName = await storage.get(Constant.themeModeKey) as String?;
    return ThemeMode.values.firstWhere(
      (value) => themeName == value.name,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> updateMode(ThemeMode mode) async {
    final previousMode = state.asData?.value ?? ThemeMode.system;
    state = AsyncValue.data(mode);

    final storage = ref.read(storageServiceProvider);
    final result = await AsyncValue.guard(() async {
      final saved = await storage.set(Constant.themeModeKey, mode.name);
      if (!saved) {
        throw StateError('Failed to persist theme mode');
      }
    });

    if (result.hasError) {
      state = AsyncValue.data(previousMode);
      result.whenOrNull(
        error: (error, stackTrace) {
          Error.throwWithStackTrace(error, stackTrace);
        },
      );
    }
  }
}

class AppTheme {
  /// Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AppTextStyles.fontFamily,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.black,

      // M3 ColorScheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.lightGrey,
        error: AppColors.error,
        surface: AppColors.black, // Replaces obsolete 'background'
      ),

      textTheme: TextThemes.darkTextTheme,
      primaryTextTheme: TextThemes.primaryTextTheme,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.black,
        titleTextStyle: AppTextStyles.h2,
        centerTitle: true,
      ),
    );
  }

  /// Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      fontFamily: AppTextStyles.fontFamily,

      // M3 ColorScheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.lightGrey,
        error: AppColors.error,
        surface: Colors.white,
      ),

      textTheme: TextThemes.textTheme,
      primaryTextTheme: TextThemes.primaryTextTheme,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
    );
  }
}
