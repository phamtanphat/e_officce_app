import 'package:e_officce_tfc/core/storage/local/shared_preference_provider.dart';
import 'package:e_officce_tfc/core/storage/local/shared_preference_service.dart';
import 'package:e_officce_tfc/features/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FakeStorageService implements SharedPreferenceService {
  @override
  Future<void> clear() async {}

  @override
  Future<Object?> get(String key) async => null;

  @override
  Future<bool> has(String key) async => false;

  @override
  Future<bool> remove(String key) async => true;

  @override
  Future<bool> set(String key, String data) async => true;
}

void main() {
  testWidgets('MyApp bootstraps with Riverpod overrides',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(_FakeStorageService()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
