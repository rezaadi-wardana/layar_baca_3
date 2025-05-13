import 'package:flutter/material.dart';
import 'package:layar_baca_3/screens/favorite_book_screen.dart';
import 'package:layar_baca_3/screens/feedback_screen.dart';
import 'package:layar_baca_3/screens/profile_screen.dart';
import 'package:layar_baca_3/screens/recent_book_screen.dart';
import 'package:layar_baca_3/screens/register_screen.dart';
import 'package:layar_baca_3/screens/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pzqsltmqynnmtrsfqrst.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB6cXNsdG1xeW5ubXRyc2ZxcnN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMjE0OTQsImV4cCI6MjA2MjU5NzQ5NH0.DrwPOrjrpaoiASQnxBwfilr2T8h1wkVONP3SQ4tc3nk',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Layar Baca 3",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: HomeScreen(),
      routes: {
        '/profile': (context) => const ProfileScreen(),
        '/register': (context) => const RegisterScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/favorite': (context) => const FavoriteBooksScreen(),
        '/recent': (context) => const RecentBooksScreen(),
      },
    );
  }
}


// LayarBaca#123 password supabase