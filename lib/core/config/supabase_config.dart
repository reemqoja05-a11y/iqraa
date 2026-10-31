/// Supabase connection settings.
///
/// The publishable key is public by design and is safe inside the app:
/// real data protection comes from Row Level Security (RLS) in the database.
/// NEVER put the `service_role` / secret key in this project.
///
/// Optional override without editing code:
/// flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_PUBLISHABLE_KEY=...
class SupabaseConfig {
  const SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://anoctvalnezzejwariov.supabase.co',
  );

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_UZPmx362NWO8HNH9Sk39-g_ab8Mx7_E',
  );
}