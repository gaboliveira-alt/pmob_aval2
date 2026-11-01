# Stage 3 — State management (RF04)

> **Related issue:** #3
> **Depends on:** Stage 2
> **Blocks:** stages 4, 5

## Goal

Centralize the listing state and form submission state in a single
`ChangeNotifier` (chosen approach: **ChangeNotifier + Provider**), covering:
the object list, loading/success/error states, the form submission state, and
UI refresh after registration (RF04).

## File to create: `lib/presentation/controllers/items_controller.dart`

```dart
import 'package:flutter/foundation.dart';

import '../../domain/models/found_item.dart';
import '../../domain/models/item_situation.dart';
import '../../domain/repositories/item_repository.dart';

enum ItemsStatus { initial, loading, loaded, error }

enum SubmitStatus { idle, submitting, success, error }

class ItemsController extends ChangeNotifier {
  ItemsController({required ItemRepository repository}) : _repository = repository;

  final ItemRepository _repository;

  ItemsStatus status = ItemsStatus.initial;
  SubmitStatus submitStatus = SubmitStatus.idle;
  List<FoundItem> items = const [];
  String? errorMessage;
  String? submitErrorMessage;

  bool get isSubmitting => submitStatus == SubmitStatus.submitting;
  bool get isLoading => status == ItemsStatus.loading;

  Future<void> loadItems() async {
    status = ItemsStatus.loading;
    notifyListeners();
    try {
      items = await _repository.fetchItems();
      errorMessage = null;
      status = ItemsStatus.loaded;
    } catch (_) {
      status = items.isEmpty ? ItemsStatus.error : ItemsStatus.loaded;
      errorMessage =
          'Não foi possível carregar os registros. Verifique sua conexão e tente novamente.';
    }
    notifyListeners();
  }

  Future<bool> submitItem({
    required String name,
    required String description,
    required String location,
    required ItemSituation situation,
  }) async {
    if (isSubmitting) return false;

    submitStatus = SubmitStatus.submitting;
    submitErrorMessage = null;
    notifyListeners();

    try {
      final item = FoundItem(
        name: name.trim(),
        description: description.trim(),
        location: location.trim(),
        situation: situation,
        createdAt: DateTime.now(),
      );
      await _repository.addItem(item);
      submitStatus = SubmitStatus.success;
      notifyListeners();
      await loadItems();
      return true;
    } catch (_) {
      submitStatus = SubmitStatus.error;
      submitErrorMessage =
          'Não foi possível salvar o registro. Verifique sua conexão e tente novamente.';
      notifyListeners();
      return false;
    }
  }

  void resetSubmitStatus() {
    if (submitStatus != SubmitStatus.submitting) {
      submitStatus = SubmitStatus.idle;
      notifyListeners();
    }
  }
}
```

## Provider wiring (`lib/presentation/app.dart`)

Wrap the `MaterialApp` of `App` with the provider at the root widget level
(decide in `app.dart` to keep `main.dart` lean):

```dart
return ChangeNotifierProvider<ItemsController>(
  create: (_) => ItemsController(
    repository: SupabaseItemRepository(),
  )..loadItems(),
  child: MaterialApp(...),
);
```

- `..loadItems()` triggers the initial load automatically.
- Screens read via `context.watch<ItemsController>()` / `Consumer<ItemsController>`.
- Cloud data state must **not** live in ephemeral widget variables
  (local `setState`).

## Acceptance criteria

- [ ] `ItemsController` covers list + submission with the exact enums above.
- [ ] Repeated submission is ignored while `isSubmitting` (RF03).
- [ ] Network failures become Portuguese messages + retry possibility (RF03).
- [ ] After a successful registration the list is reloaded (RF02).
- [ ] The provider is registered at the top and loads data on startup.
- [ ] `flutter analyze` clean; `dart format .` applied.
