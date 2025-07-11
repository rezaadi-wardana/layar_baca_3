import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;
  final Function(String) onLanguageChange;
  final String selectedLanguage;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onLanguageChange,
    required this.selectedLanguage,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkTheme;
  late String selectedLanguage;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.isDarkMode;
    selectedLanguage = widget.selectedLanguage;

    final user = Supabase.instance.client.auth.currentUser;
    isLoggedIn = user != null;
  }

  void _changePasswordDialog() {
    final newPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        final t = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(t.changePassword),
          content: TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: t.newPassword),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPassword = newPasswordController.text.trim();
                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.passwordTooShort)),
                  );
                  return;
                }

                try {
                  final supabase = Supabase.instance.client;
                  await supabase.auth.updateUser(
                    UserAttributes(password: newPassword),
                  );

                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.passwordChanged)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${t.failed}: ${e.toString()}")),
                  );
                }
              },
              child: Text(t.save),
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(String? language) {
    if (language != null) {
      setState(() {
        selectedLanguage = language;
      });
      widget.onLanguageChange(language);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bahasa diubah ke $language")),
      );
    }
  }

  void _toggleTheme(bool value) {
    setState(() {
      isDarkTheme = value;
    });
    widget.onThemeToggle(value);
    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDarkTheme ? t.darkModeEnabled : t.lightModeEnabled,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.titleSettings)),
      body: ListView(
        children: [
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.lock),
              title: Text(t.changePassword),
              onTap: _changePasswordDialog,
            ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t.language),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'Indonesia', child: Text('Indonesia')),
                DropdownMenuItem(value: 'English', child: Text('English')),
              ],
              onChanged: _changeLanguage,
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.palette),
            title: Text(t.darkTheme),
            value: isDarkTheme,
            onChanged: _toggleTheme,
          ),
        ],
      ),
    );
  }
}
