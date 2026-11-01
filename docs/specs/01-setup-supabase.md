# Stage 1 — Supabase setup and app bootstrap (RF05)

> **Related issue:** #1
> **Depends on:** none (first stage)
> **Blocks:** stages 2, 3, 4, 5, 6

## Goal

Connect the app to Supabase (free plan) with the database schema already
created and the client initialized. No fictitious data may exist in code
(section 5 of the assignment).

## 1. Create the Supabase project (manual step for the team)

1. Create a free account at <https://supabase.com> → **New project** (Free plan).
2. In **Settings → API**, note:
   - `Project URL` (format `https://XXXXXXXX.supabase.co`)
   - `Publishable key` (format `sb_publishable_...`; formerly called `anon
     key` — public key by design; safe for the app because RLS restricts
     access to SELECT/INSERT only — no editing, no deletion, no sensitive data)
3. In the **SQL Editor**, paste and run the **entire** content of
   [`docs/supabase/schema.sql`](../supabase/schema.sql).

> The schema creates table `public.items` with size checks, the ordering index
> and the RLS policies for the `anon` role. Create nothing else (no auth, no
> storage).

## 2. Dependencies (`pubspec.yaml`)

Add to `dependencies:` (use `flutter pub add` to resolve versions):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.5+1
  supabase_flutter: ^2.18.3
```

Run `flutter pub get` after editing.

## 3. Configuration file

Create `lib/config/supabase_config.dart`:

```dart
abstract final class SupabaseConfig {
  static const String url = 'SUBSTITUA_PELA_URL_DO_PROJETO_SUPABASE';

  static const String publishKey =
      'SUBSTITUA_PELA_PUBLISHABLE_KEY_DO_PROJETO_SUPABASE';
}
```

- The team fills in the real values (`https://....supabase.co` and the
  publishable key) as soon as the Supabase project exists. They **must** live
  in this file (the app must compile straight from the repository, per
  checklist 8.3).

## 4. Entry point (`lib/main.dart`)

Replace the current content (counter demo) with:

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishKey,
  );
  runApp(const App());
}
```

## 5. Theme and localization (`lib/presentation/app.dart`)

Create widget `App` (`StatelessWidget` with a `const` constructor):

- `MaterialApp` with `title: 'Achados e Perdidos'`.
- Material 3 theme: `theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))`.
- Portuguese localization (RNF01):

```dart
localizationsDelegates: GlobalMaterialLocalizations.delegates,
supportedLocales: const [Locale('pt', 'BR')],
```

- `home: const _HomePlaceholder()` — a simple `Scaffold` with
  `body: Center(child: CircularProgressIndicator())`. This provisional screen is
  replaced by the listing screen in Stage 4.
- Required imports: `package:flutter/material.dart`,
  `package:flutter_localizations/flutter_localizations.dart`.

## Acceptance criteria

- [ ] `flutter pub get` runs without error.
- [ ] `Supabase.initialize` is called before `runApp`.
- [ ] The schema was executed on Supabase and table `public.items` exists.
- [ ] `SupabaseConfig.url` and `.publishKey` contain (or are ready to receive) the real values.
- [ ] `App` uses Material 3 and `Locale('pt', 'BR')`.
- [ ] `flutter analyze` clean and `dart format .` applied.
