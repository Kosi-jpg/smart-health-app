import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_language.dart';
import 'auth_screen.dart';
import 'dashboard_screen.dart';
import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();

  await Supabase.initialize(
    url: 'https://rgxtrewroxdoxvbulgwm.supabase.co',
    publishableKey: 'sb_publishable_kkZXwenbs8RmNTdJy6S1bQ_jcG8gs3f',
  );

  final appLanguage = await AppLanguage.load();

  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  const MyApp({super.key, required this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appLanguage,
      builder: (context, child) {
        final user = Supabase.instance.client.auth.currentUser;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Health App',
          locale: appLanguage.locale,
          supportedLocales: AppLanguage.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
          home: user != null
              ? DashboardScreen(
                  loginScreenBuilder: () =>
                      AuthScreen(appLanguage: appLanguage),
                  appLanguage: appLanguage,
                )
              : AuthScreen(appLanguage: appLanguage),
        );
      },
    );
  }
}
