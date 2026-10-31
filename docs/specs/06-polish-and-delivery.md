# Stage 6 — Polish, code quality and repository organization (RNF01, RNF02, sections 7/8 of the assignment)

> **Related issue:** #6
> **Depends on:** stages 1–5
> **Blocks:** nothing (last stage, close the milestone)

## Goal

Secure the 2.0 points for "UI, code quality and repository organization" and
make the delivery pass the assignment's checklist 8.3.

## 1. Code quality (RNF02)

Mandatory checklist before every commit:

```bash
dart format .
flutter analyze   # must print: "No issues found!"
```

Rules to check in code review:

- [ ] Technical identifiers in English (`items`, `fetchItems`, `location`...);
      strings visible to the user in Portuguese.
- [ ] Expressive names, no relevant duplication.
- [ ] Clear layer separation: `presentation/` (UI), `domain/models` (models),
      `data/` (data access) — no `Supabase` imported directly by the UI.
- [ ] No `print()` (use `debugPrint` only if needed, and no leftovers).
- [ ] No remaining TODO/demo comments (the old counter demo was already replaced).

## 2. UI and usability (RNF01)

- [ ] Material 3 everywhere (`useMaterial3: true`).
- [ ] All UI text in Portuguese.
- [ ] Test small screens (`flutter run -d chrome`, narrow window) — no overflow.
- [ ] In-progress operations and failures always communicated
      (SnackBars/indicators).

## 3. README.md (section 7 of the assignment)

Update the existing `README.md`:

- [ ] Full names of team members (present: Gabriel Oliveira Pinto,
      Adonias Pereira dos Santos Terceiro — **confirm with the team**).
- [x] Feature description (already present; adjust if needed).
- [ ] **Cloud service**: replace the TODO with "Supabase (free plan)",
      explaining: project URL, public anon key in
      `lib/config/supabase_config.dart`, script `docs/supabase/schema.sql`,
      RLS policies of SELECT/INSERT for the `anon` role (item 8.2: keys/URLs
      must be available in the repository).
- [ ] Configuration and run instructions: create a Supabase account, run the
      script in the SQL Editor, fill in `SupabaseConfig`, then run:
      `flutter pub get` → `flutter run -d chrome`.
- [ ] Updated project structure (include `data/` alongside `domain/` and
      `presentation/`).

## 4. Repository hygiene (sections 8.1 and 8.4)

- [ ] Ensure `build/`, `.dart_tool/`, `*.apk`, `*.aab`, `*.ipa`, executables
      are **not** tracked: `git ls-files | Select-String "build/|\.apk|\.aab|\.ipa"`.
- [ ] Default Flutter `.gitignore` present, covering `build/` and `.dart_tool/`.
- [ ] No private credentials tracked — only the public Supabase anon key
      (public by design, protected by RLS).
- [ ] Repository public: `gh repo view gaboliveira-alt/pmob_aval2 --json visibility`.

## 5. Final smoke test (run before declaring done)

1. `flutter pub get && dart format . && flutter analyze`
2. `flutter run -d chrome`
3. Manual verification (evaluation criteria):
   - [ ] Register an object with invalid fields → validation errors (2.0 — registration).
   - [ ] Register a valid object → appears at the top of the listing (2.0 — listing).
   - [ ] Close and reopen the app → data persists (2.0 — cloud).
   - [ ] Disconnect the network → clear error + retry; submission blocked during
         the request (2.0 — async/state).
   - [ ] Material 3 UI, pt-BR, no overflow (2.0 — UI/quality).

## 6. Delivery (section 8)

- [ ] Repository public and accessible.
- [ ] Submit via SIGAA by 08/11/2026 23:59: repo link + full names.
- [ ] Every member has identifiable commits and understands the solution
      (the grade is shared by all).

## Acceptance criteria

- [ ] `flutter analyze`: zero issues; `dart format .`: no pending diffs.
- [ ] README complete per the checklist above.
- [ ] No build artifacts in the repo.
- [ ] App works end-to-end using only the README instructions.
