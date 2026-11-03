/// Build-time configuration from `--dart-define-from-file=env/<name>.json`.
/// No secrets live here: the anon key is public by design and every table is
/// protected by Row Level Security. Service keys exist only in Edge Functions.
class Env {
  const Env({
    required this.name,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.sentryDsn,
    this.configError,
  });

  const Env.fromDefines()
    : name = const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
      supabaseUrl = const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY'),
      sentryDsn = const String.fromEnvironment('SENTRY_DSN'),
      configError = null;

  final String name;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String sentryDsn;

  /// Set when the backend failed to initialise at startup.
  final String? configError;

  /// True only for real-looking values: the placeholders from
  /// env/example.json count as "not configured".
  bool get isConfigured =>
      configError == null &&
      supabaseUrl.startsWith('https://') &&
      supabaseAnonKey.isNotEmpty &&
      !supabaseUrl.contains('YOUR-PROJECT-REF') &&
      !supabaseAnonKey.startsWith('YOUR-');

  bool get hasSentry => sentryDsn.isNotEmpty;

  Env withError(String error) => Env(
    name: name,
    supabaseUrl: supabaseUrl,
    supabaseAnonKey: supabaseAnonKey,
    sentryDsn: sentryDsn,
    configError: error,
  );
}
