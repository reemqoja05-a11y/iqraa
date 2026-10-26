import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/app_controller.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://anoctvalnezzejwariov.supabase.co',
    publishableKey: 'sb_publishable_UZPmx362NWO8HNH9Sk39-g_ab8Mx7_E',
  );

  runApp(const IqraApp());
}

/// Iqra — reading habit application.
///
/// Native Flutter conversion of the Google Stitch HTML designs.
/// MVC structure: models → views → controllers → data, with shared widgets
/// and theme under lib/views/widgets and lib/theme.
class IqraApp extends StatelessWidget {
  const IqraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListenableBuilder(
        listenable: appController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'اقرأ',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ar'), Locale('en')],
            locale: appController.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.onboarding,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
