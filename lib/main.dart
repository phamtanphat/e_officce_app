import 'package:e_officce_tfc/core/storage/local/shared_preference_provider.dart';
import 'package:e_officce_tfc/core/storage/local/shared_preference_service.dart';
import 'package:e_officce_tfc/features/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/environment/env.dart';

void main() => mainCommon(AppEnvironment.PROD);

Future<void> mainCommon(AppEnvironment environment) async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize SharedPreferences asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();

  // 3. Create the concrete service instance
  final storageService = SharedPreferenceServiceImpl(sharedPreferences);

  WidgetsFlutterBinding.ensureInitialized();
  EnvInfo.initialize(environment);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(ProviderScope(
    overrides: [
      // Override the StorageService provider with the initialized instance
      storageServiceProvider.overrideWithValue(storageService),
    ],
    child: MyApp(),
  ));
}
