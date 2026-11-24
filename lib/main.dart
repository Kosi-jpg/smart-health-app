
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';
import 'dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rgxtrewroxdoxvbulgwm.supabase.co',
    publishableKey: 'sb_publishable_kkZXwenbs8RmNTdJy6S1bQ_jcG8gs3f',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Health App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: user != null
          ? DashboardScreen(
              loginScreenBuilder: () => const AuthScreen(),
            )
          : const AuthScreen(),
    );
  }
}
