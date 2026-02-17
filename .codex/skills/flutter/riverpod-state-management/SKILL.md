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

## **Priority: P0 (CRITICAL)**

Strict adherence to **Riverpod Generator** syntax, **Immutability**, and **Functional Programming** patterns.

## Structure

```text
lib/
├── core/
│   └── providers/ # Global providers (Dio, SharedPreferences)
└── features/
    └── [feature_name]/
        ├── data/
        │   ├── models/    # @freezed classes
        │   └── repos/     # Repository implementations
        ├── presentation/
        │   ├── providers/ # Feature-specific State (Controllers)
        │   └── ui/        # Widgets (ConsumerWidget/HookConsumerWidget)
        └── domain/        # Entities & Abstract Repos