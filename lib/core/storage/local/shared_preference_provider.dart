import 'package:e_officce_tfc/core/storage/local/shared_preference_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_preference_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferenceService storageService(Ref ref) {
  throw UnimplementedError(
      'StorageService must be initialized and overridden in main.dart');
}
