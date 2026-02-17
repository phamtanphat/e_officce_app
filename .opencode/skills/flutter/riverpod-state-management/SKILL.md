---
name: "Flutter Riverpod State Management"
description: "Reactive state management using Riverpod v3 (Generator) & Dart 3."
metadata:
  labels: ["flutter", "state-management", "riverpod", "clean-architecture"]
  triggers:
    files: ["**/*.g.dart", "**/*_provider.dart", "**/*_controller.dart"]
    keywords: ["@riverpod", "ConsumerWidget", "ref.watch", "AsyncValue", "Ref"]
---

# Riverpod State Management (v3 Standard)

## Priority: P0 (CRITICAL)
- Follow Riverpod v3 generator patterns; prefer `@riverpod` (Notifier/AsyncNotifier) over manual providers.
- Keep state immutable (Freezed/models) and side-effect free in `build`; use repos/services for IO.
- One source of truth per domain concern; avoid duplicate provider trees.

## Project Layout
```
lib/
├── core/providers        # Global infra (Dio, storage, env)
└── features/
    └── <feature>/
        ├── domain/       # Entities, abstract repos
        ├── data/         # DTOs (@freezed), repos impl
        └── presentation/
            ├── providers # Feature controllers (Notifier/AsyncNotifier)
            └── ui        # Widgets (ConsumerWidget/HookConsumerWidget)
```

## Provider Taxonomy
- Stateless: `Provider`, `FutureProvider`, `StreamProvider` (use family for params).
- Stateful simple: `StateProvider` for local, ephemeral primitives only.
- Stateful rich: `NotifierProvider` / `AsyncNotifierProvider` via generator (`@riverpod` classes/functions). Expose methods; keep state pure.
- Families: prefer `@riverpod` family params (`class MyNotifier extends _$MyNotifier` with `late final id = ref.arg;`).
- Global singletons (Dio, prefs): locate in `core/providers`, override in tests.

## WidgetRef Rules
- `ref.watch` in `build` only; use `.select` to limit rebuilds.
- `ref.read` in callbacks/handlers; never in `build` for reactive values.
- `ref.listen` for UI side-effects (snackbar, navigation) inside `build`.
- `ref.listenManual` in `initState` of `ConsumerState` for lifecycle-aware listens.
- `ref.invalidate(provider)` to force recompute; `ref.refresh(provider)` to invalidate + return new value (use sparingly).

## AsyncValue Handling
- Always exhaustively handle `AsyncValue` (`switch` or `when`).
- For refresh UX, set `skipLoadingOnRefresh: true` to keep previous data.
- Surface errors (show message, log); do not swallow.

## Notifier Patterns (Generator)
```dart
@riverpod
class Counter extends _$Counter {
  @override int build() => 0;
  void increment() => state++;
}

@riverpod
class UserController extends _$UserController {
  @override Future<User> build(String userId) => ref.watch(userRepoProvider).fetch(userId);
  Future<void> refresh() async => state = const AsyncLoading();
}
```
- Keep mutations inside notifier methods; avoid `state = state..field = x` (immutability).
- For async work, update state with `AsyncValue.guard` or set loading then assign.

## Widgets
- Prefer `ConsumerWidget`/`HookConsumerWidget` for stateless UIs.
- Use `ConsumerStatefulWidget` when local `State` or `listenManual` is needed.
- Do not call `ref.watch` in `initState`/`dispose`.

## Overrides & Testing
- Wrap app/tests in `ProviderScope` with explicit overrides (value/build/family).
- Scoped overrides via nested `ProviderScope` for subtree-specific deps.
- Widget tests: use `tester.container()` to read/write provider state; keep deterministic.

## Error & Performance
- Propagate domain errors; map to UI-friendly messages at presentation layer.
- Avoid heavy work in `build`; memoize with providers and `select`.
- No mutable singletons; use providers for shared instances.

## Anti-Patterns (reject)
- Hardcoded refs to providers without DI/override path.
- `ref.watch` inside callbacks/events.
- Mutating models in place or sharing mutable collections.
- Manual state classes when generator-based Notifier fits.
