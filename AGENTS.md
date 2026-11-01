# AGENTS.md — Rules for AI agents (Lost & Found — UESPI)

This project is the **2nd evaluation** for the Mobile Device Programming course
(UESPI). The specs in [`docs/specs/`](docs/specs/) are **binding**: AI agents
must follow them to the letter — file names, classes, methods and behaviors
defined there must not be changed without team discussion.

## What the app is

A Flutter/Dart lost-and-found app for the university campus: users register
lost/found objects and browse the listing. Data lives in **Supabase**
(free tier, no authentication).

## Stack and decisions already made (do not change without team agreement)

| Topic | Decision |
|---|---|
| Framework | Flutter + Dart (web only; do not add android/ios) |
| Cloud | Supabase (`supabase_flutter`), table `public.items`, RLS allowing only `SELECT`/`INSERT` for `anon` |
| State | `ChangeNotifier` + `provider` (single class `ItemsController`) |
| UI | Material 3, language pt-BR (`Locale('pt', 'BR')`) |
| Platforms | `web/` only |

## Mandatory code rules (RNF02 of the assignment)

1. **Technical identifiers in English** (`name`, `location`, `fetchItems`);
   strings shown to the user in Portuguese.
2. **Expressive names** and low duplication; extract widgets/methods when
   duplication is relevant.
3. **Layer separation** — respect the structure:
   - `lib/domain/models/` — data models (pure Dart);
   - `lib/domain/repositories/` — contracts (`abstract interface`);
   - `lib/data/` — concrete implementations (Supabase);
   - `lib/presentation/` — controllers, screens and widgets.
   The UI **never** imports `supabase_flutter` directly; only `data/` does.
4. **No fictitious data** in code: the source is always the cloud (section 5 of
   the assignment).
5. **Do not implement** authentication, edit, delete, image upload, notifications
   or advanced search (not required — out of scope).
6. **Format and analyze** — before every commit, run from the project root:
   ```bash
   dart format .
   flutter analyze   # must print "No issues found!"
   ```
   The project must always be left in this state.
7. **Comments in code are strictly prohibited** — no comments of any kind in
   `.dart` files (`//`, `///`, `/* */`), not even explanatory or documentation
   comments. Express intent through expressive names; documentation belongs in
   the `README.md` and in `docs/`, never in the code.

## Repository rules (sections 7/8 of the assignment)

- **Never** commit build artifacts: `build/`, `.dart_tool/`, `*.apk`,
  `*.aab`, `*.ipa`, executables. The default Flutter `.gitignore` already
  covers this; do not weaken it.
- **Never** commit private credentials. The Supabase `publishable key`
  (formerly `anon key`) is public by design (database protected by RLS) and
  **must** live in `lib/config/supabase_config.dart` + be documented in the
  README (requirement 8.2).
- Commit messages in English, format `type: short description`
  (e.g. `feat: add item list screen with retry`), one per logical unit of
  work; every team member must have identifiable commits.
- Update `README.md` whenever configuration, structure or dependencies change.

## Git workflow — one branch per spec/feature

Each stage is developed in its own branch and only reaches `main` through a
Pull Request after its issue checklist passes. **Never push stage work
directly to `main`** — it must always stay functional and runnable.

1. **Branch naming:** `feature/NN-nome-da-spec`, using the spec number and
   file stem — branch, spec and issue share the same `NN`:
   - spec `docs/specs/01-setup-supabase.md` → issue `#1` → branch
     `feature/01-setup-supabase`
2. **Start a stage** by branching off an up-to-date `main`:

   ```bash
   git checkout main && git pull
   git checkout -b feature/01-setup-supabase
   ```

3. **Commit only to that branch**, following the commit format in this file
   (one commit per logical unit of work).
4. **When the stage is done**, run the gate: `dart format .` +
   `flutter analyze` + the stage's smoke test. Then open a PR from the
   feature branch to `main` with:
   - **Title:** the issue title (e.g. `Etapa 1 — Configurar Supabase...`);
   - **Description:** paste the spec's "Acceptance criteria" checklist with
     every item ticked `[x]`, and tick the same checklist in the issue;
   - **`Closes #N`** in the body, so the issue auto-closes on merge.
5. **Merge only when every checklist item passes.** Delete the branch after
   the merge (GitHub's "Delete branch" option).
6. Stages are merged in order (1 → 2 → 3 → 4 → 5 → 6). If a later branch
   conflicts, rebase/merge `main` into the feature branch — never the other
   way around.

## Workflow with the specs

1. Read the stage spec in `docs/specs/NN-name.md` **in full** before coding.
2. Implement exactly the files/names/contracts described — surprises (new
   dependencies, new layers, schema changes) only after team confirmation.
3. Each spec has a "Acceptance criteria" section: that is the definition of
   done for the stage.
4. Run `dart format .` + `flutter analyze` and the smoke test suited to the
   stage when finished.
5. Do not skip stages: respect the dependencies stated at the top of each spec.

## Stage order

1. [`01-setup-supabase.md`](docs/specs/01-setup-supabase.md) — Supabase + bootstrap (RF05)
2. [`02-data-layer.md`](docs/specs/02-data-layer.md) — model + repository (RF02/RF05)
3. [`03-state-management.md`](docs/specs/03-state-management.md) — `ItemsController` (RF04)
4. [`04-listing-screen.md`](docs/specs/04-listing-screen.md) — listing screen (RF01/RF03)
5. [`05-registration-form.md`](docs/specs/05-registration-form.md) — registration form (RF02/RF03)
6. [`06-polish-and-delivery.md`](docs/specs/06-polish-and-delivery.md) — polish, README, delivery (RNF01/RNF02)

## Useful commands

```bash
flutter pub get          # dependencies
flutter run -d chrome    # run (web)
dart format .            # format everything
flutter analyze          # static checks
```

## Evaluation context

- Worth 10.0 points across 5 criteria (registration 2.0, listing 2.0, cloud
  2.0, async/state 2.0, UI/code quality/repo 2.0).
- Deadline: **08/11/2026, 23:59**, submission only via SIGAA (repo link +
  member names).
- A "simple, functional, organized and technically correct" solution is
  valued; extra features are **not** needed for the maximum score — when in
  doubt, choose the simplest solution from the spec.
