import 'package:e_officce_tfc/core/routing/app_router.dart';
import 'package:e_officce_tfc/core/theme/app_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(appThemeModeProvider);
    final router = ref.watch(routerProvider);
    return themeModeAsync.when(
      data: (ThemeMode themeMode) {
        return MaterialApp.router(
          title: 'Flutter TDD',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Lỗi: $err'))),
      ),
    );
  }
}
