import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferenceService {
  /// Retrieve a value by key.
  Future<Object?> get(String key);

  /// Save a string value.
  Future<bool> set(String key, String data);

  /// Check if a key exists.
  Future<bool> has(String key);

  /// Remove a specific key.
  Future<bool> remove(String key);

  /// Clear all stored data.
  Future<void> clear();
}

class SharedPreferenceServiceImpl implements SharedPreferenceService {
  final SharedPreferences _prefs;

  /// Constructor receives an initialized instance.
  SharedPreferenceServiceImpl(this._prefs);

  @override
  Future<Object?> get(String key) async {
    // Return the raw value (String, bool, int, etc.)
    return _prefs.get(key);
  }

  @override
  Future<bool> set(String key, String data) async {
    // Persist the string data
    return await _prefs.setString(key, data);
  }

  @override
  Future<bool> has(String key) async {
    // Check for key existence
    return _prefs.containsKey(key);
  }

  @override
  Future<bool> remove(String key) async {
    // Delete the key-value pair
    return await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    // Wipe all data from storage
    await _prefs.clear();
  }
}
