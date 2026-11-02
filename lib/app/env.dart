/// Build-time configuration from `--dart-define-from-file=env/<name>.json`.
/// No secrets live here: the anon key is public by design and every table is
/// protected by Row Level Security. Service keys exist only in Edge Functions.
class Env {
  const Env({required this.name, required this.supabaseUrl, required this.supabaseAnonKey, required this.sentryDsn});

  const Env.fromDefines()
    : name = const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
      supabaseUrl = const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY'),
      sentryDsn = const String.fromEnvironment('SENTRY_DSN');

  final String name;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String sentryDsn;

  bool get isConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  bool get hasSentry => sentryDsn.isNotEmpty;
}
