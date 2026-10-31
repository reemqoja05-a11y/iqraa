import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global service locator. Each feature registers its own data sources,
/// repositories, use cases and blocs inside [initDependencies].
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  if (sl.isRegistered<SupabaseClient>()) return;

  // Core
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
}