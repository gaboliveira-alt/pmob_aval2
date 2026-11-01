/// Public Supabase configuration.
///
/// The `anon key` (renamed by Supabase to `publishable key`) is a public key
/// by design: the database is protected by RLS that allows only SELECT and
/// INSERT (no authentication, no sensitive data). These values are also
/// documented in the README (item 8.2 of the assignment).
abstract final class SupabaseConfig {
  /// Project URL from Settings → API of the Supabase project.
  static const String url = 'https://nifftybncapixnbubylz.supabase.co';

  /// Publishable key (public) from Settings → API of the Supabase project.
  static const String publishKey =
      'sb_publishable_d7mXe8MRUdhR9H4C4k2E2g_YaPgfELR';
}
