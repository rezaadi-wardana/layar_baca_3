import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:layar_baca_3/screens/favorite_book_screen.dart';
import 'package:layar_baca_3/screens/feedback_screen.dart';
import 'package:layar_baca_3/screens/profile_screen.dart';
import 'package:layar_baca_3/screens/recent_book_screen.dart';
import 'package:layar_baca_3/screens/register_screen.dart';
import 'package:layar_baca_3/screens/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ Import localization


// Tambahkan enum untuk bahasa
enum AppLanguage { indonesia, english }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pzqsltmqynnmtrsfqrst.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6cXNsdG1xeW5ubXRyc2ZxcnN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMjE0OTQsImV4cCI6MjA2MjU5NzQ5NH0.DrwPOrjrpaoiASQnxBwfilr2T8h1wkVONP3SQ4tc3nk',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('id');


  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _locale = language == 'English' ? const Locale('en') : const Locale('id');
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Layar Baca 3",
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        primarySwatch: Colors.orange,
      ),
      themeMode: _themeMode,
      home: HomeScreen(),
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/register': (context) => const RegisterScreen(),
        '/settings':
            (context) => SettingsScreen(
              isDarkMode: _themeMode == ThemeMode.dark,
              onThemeToggle: _toggleTheme,
              selectedLanguage:
                  _locale.languageCode == 'en' ? 'English' : 'Indonesia',
              onLanguageChange: _changeLanguage,
            ),
        '/feedback': (context) => const FeedbackScreen(),
        '/favorite': (context) => const FavoriteBooksScreen(),
        '/recent': (context) => const RecentBooksScreen(),
      },
    );
  }
}
