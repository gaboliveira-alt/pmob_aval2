# Stage 5 — Registration form (RF02, RF03)

> **Related issue:** #5
> **Depends on:** stages 2 and 3
> **Blocks:** stage 6

## Goal

A form with full validation, asynchronous submission blocked against repeat
submits, a processing indicator and error handling with a retry option.

## File to create: `lib/presentation/screens/register_item_screen.dart`

`final class RegisterItemScreen extends StatefulWidget` with
`GlobalKey<FormState> _formKey`, submitting through `ItemsController`.

### Fields and validation (RF02)

| Field | Widget | Rule |
|---|---|---|
| Name | `TextFormField` | Required; `maxLength: 60`; `validator` rejects empty/whitespace |
| Description | `TextFormField` (`maxLength: 200`, `maxLines: 3`) | Required |
| Location | `TextFormField` | Required |
| Situation | `DropdownButtonFormField<ItemSituation>` | Required; items `ItemSituation.lost` and `.found` with `label` captions; initial value `null` |

Validator pattern (applied to all):

```dart
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe o nome do objeto';
  }
  if (value.trim().length > 60) {
    return 'Use no máximo 60 caracteres';
  }
  return null;
},
```

- The `maxLength` of the `TextFormField`s already renders the Material
  counter — keep them (60 and 200).
- `textInputAction` and `autovalidateMode: AutovalidateMode.onUserInteraction`.

### Submission (RF03/RF04)

```dart
Future<void> _submit() async {
  final form = _formKey.currentState;
  if (form == null || !form.validate()) return;

  final controller = context.read<ItemsController>();
  final success = await controller.submitItem(
    name: _nameController.text,
    description: _descriptionController.text,
    location: _locationController.text,
    situation: _situation!,
  );
  if (!mounted) return;
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo com sucesso!')),
    );
    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(controller.submitErrorMessage ?? 'Erro ao salvar.')),
    );
  }
}
```

- Use **no** extra navigation/context dependencies — only `mounted` +
  Flutter's `context.read`/`showSnackBar`.

### Button and indicator (RF03)

```dart
final controller = context.watch<ItemsController>();
FilledButton.icon(
  onPressed: controller.isSubmitting ? null : _submit,
  icon: controller.isSubmitting
      ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Icon(Icons.save_outlined),
  label: Text(controller.isSubmitting ? 'Salvando...' : 'Salvar'),
)
```

- While `isSubmitting`, the button stays disabled (prevents repeat submits)
  **and** all fields may be disabled (`enabled: !controller.isSubmitting`).
- `DateTime` is **not** a form field: it is recorded automatically (sent by the
  database, `default now()` — see Stage 2). Do not build a date picker.

### Layout

- `Scaffold` with `AppBar(title: Text('Cadastrar objeto'))`.
- `Form` inside `SingleChildScrollView` + `Padding(16)` + `Column(spacing: 16)`
  to avoid overflow (RNF01).
- Labels in Portuguese: «Nome do objeto», «Descrição», «Local», «Situação».

## Acceptance criteria

- [ ] All required fields validated before submission (RF02).
- [ ] Name ≤ 60 and description ≤ 200 characters (RF02).
- [ ] Situation chosen between Perdido/Encontrado (RF02).
- [ ] Button disabled + indicator during submission (RF03).
- [ ] Success → confirmation SnackBar and back to the already-refreshed listing (RF02).
- [ ] Failure → SnackBar with retry option (button re-enabled) (RF03).
- [ ] No overflow on small screens (RNF01).
- [ ] `flutter analyze` clean; `dart format .` applied.
