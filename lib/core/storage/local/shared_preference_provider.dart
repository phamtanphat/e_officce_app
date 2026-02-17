import 'package:e_officce_tfc/core/storage/local/shared_preference_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_preference_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferenceService storageService(Ref ref) {
  return _InMemorySharedPreferenceService();
}

class _InMemorySharedPreferenceService implements SharedPreferenceService {
  final Map<String, String> _store = {};

  @override
  Future<Object?> get(String key) async => _store[key];

  @override
  Future<bool> set(String key, String data) async {
    _store[key] = data;
    return true;
  }

  @override
  Future<bool> has(String key) async => _store.containsKey(key);

  @override
  Future<bool> remove(String key) async => _store.remove(key) != null;

  @override
  Future<void> clear() async => _store.clear();
}
