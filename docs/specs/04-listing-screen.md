# Stage 4 — Listing screen (RF01, RF03)

> **Related issue:** #4
> **Depends on:** stages 2 and 3
> **Blocks:** stage 6

## Goal

Display records loaded from the cloud with visual identification of the
situation, ordering already guaranteed by the repository, a loading indicator,
error handling with retry, and access to the registration form.

## Files to create

```
lib/presentation/screens/items_list_screen.dart
lib/presentation/widgets/item_card.dart
lib/presentation/widgets/situation_badge.dart
```

Also replace `_HomePlaceholder` in `lib/presentation/app.dart` with
`home: const ItemsListScreen()`.

## 1. `lib/presentation/widgets/situation_badge.dart`

`final class SituationBadge extends StatelessWidget` receiving
`final ItemSituation situation`, rendering a `Container`/`Chip` with:

- Text: `situation.label` («Perdido» / «Encontrado»).
- `ItemSituation.lost` → `Colors.red.shade100` background, `Colors.red.shade900` text.
- `ItemSituation.found` → `Colors.green.shade100` background, `Colors.green.shade900` text.

## 2. `lib/presentation/widgets/item_card.dart`

`final class ItemCard extends StatelessWidget` receiving `final FoundItem item`,
rendering a Material 3 `Card` containing:

- Row 1: `Text(item.name)` with `Theme.of(context).textTheme.titleMedium` +
  `SituationBadge(situation: item.situation)` aligned to the end.
- Row 2: `Row` with `Icon(Icons.place_outlined, size: 16)` + `Text(item.location)`
  in small body text.
- Row 3: `Text(item.description)` with `Theme.of(context).textTheme.bodyMedium`.
- Row 4: date/time formatted in pt-BR (see Formatting below), color
  `Theme.of(context).colorScheme.outline`.

### Date/time formatting (no extra dependency)

Private to the `item_card.dart` file:

```dart
String _formatDateTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
```

## 3. `lib/presentation/screens/items_list_screen.dart`

`final class ItemsListScreen extends StatelessWidget`:

```dart
@override
Widget build(BuildContext context) {
  final controller = context.watch<ItemsController>();
  return Scaffold(
    appBar: AppBar(
      title: const Text('Achados e Perdidos'),
      actions: [
        IconButton(
          onPressed: controller.isLoading ? null : controller.loadItems,
          tooltip: 'Atualizar',
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: _buildBody(context, controller),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const RegisterItemScreen()),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Cadastrar'),
    ),
  );
}
```

### `_buildBody` — state machine (RF01/RF03)

| State | Widget |
|---|---|
| `ItemsStatus.initial` or `ItemsStatus.loading` | `Center(child: CircularProgressIndicator())` |
| `ItemsStatus.error` | `Center` with `Column`: `Icon(Icons.cloud_off)`, `Text(controller.errorMessage ?? '...')` and `ElevatedButton.icon(onPressed: controller.loadItems, icon: Icon(Icons.refresh), label: Text('Tentar novamente'))` |
| `ItemsStatus.loaded` and `items.isEmpty` | `Center` with `Icon(Icons.inbox_outlined)` + `Text('Nenhum registro ainda.')` + `Text('Cadastre um objeto perdido ou encontrado.')` |
| `ItemsStatus.loaded` with items | `ListView.separated` |

### `ListView.separated`

```dart
ListView.separated(
  padding: const EdgeInsets.all(16),
  itemCount: controller.items.length,
  separatorBuilder: (_, __) => const SizedBox(height: 12),
  itemBuilder: (context, index) => ItemCard(item: controller.items[index]),
)
```

### Refresh failure while items are already loaded

When `loadItems` fails with items in memory, the controller keeps
`ItemsStatus.loaded` and fills `errorMessage`. In `ItemsListScreen`, watch
`controller.errorMessage` and show a `SnackBar`. Simple and deterministic
solution — do it in the refresh button callback:

```dart
onPressed: controller.isLoading
    ? null
    : () async {
        await controller.loadItems();
        final message = controller.errorMessage;
        if (message != null && context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
```

> When the failure happens on the initial load (empty list), `status` becomes
> `error` and the retry screen is shown — do not duplicate the message.

## Acceptance criteria

- [ ] Name, location, situation and description visible on every item (RF01).
- [ ] Lost/Found visually distinguished (RF01).
- [ ] Newest first (guaranteed by `fetchItems`; the list is rendered directly).
- [ ] Refresh reloads and shows a `CircularProgressIndicator` during the operation (RF03).
- [ ] Initial error state has a "Tentar novamente" button (RF03).
- [ ] Access to registration via `FloatingActionButton`.
- [ ] No overflow on small screens (RNF01) — wrap in `SingleChildScrollView`/constraints when needed.
- [ ] `flutter analyze` clean; `dart format .` applied.
