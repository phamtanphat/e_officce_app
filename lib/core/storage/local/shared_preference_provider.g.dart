// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preference_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storageService)
const storageServiceProvider = StorageServiceProvider._();

final class StorageServiceProvider extends $FunctionalProvider<
    SharedPreferenceService,
    SharedPreferenceService,
    SharedPreferenceService> with $Provider<SharedPreferenceService> {
  const StorageServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'storageServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$storageServiceHash();

  @$internal
  @override
  $ProviderElement<SharedPreferenceService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SharedPreferenceService create(Ref ref) {
    return storageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferenceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferenceService>(value),
    );
  }
}

String _$storageServiceHash() => r'cdcbd3c24af85c6dcb612e8180eeaac92a6c26ad';
