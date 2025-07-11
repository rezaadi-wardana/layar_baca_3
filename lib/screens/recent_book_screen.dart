import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentBooksScreen extends StatefulWidget {
  const RecentBooksScreen({super.key});

  @override
  State<RecentBooksScreen> createState() => _RecentBooksScreenState();
}

class _RecentBooksScreenState extends State<RecentBooksScreen> {
  String? title;
  String? author = "Unknown"; // Default
  String? cover;

  @override
  void initState() {
    super.initState();
    loadRecent();
  }

  Future<void> loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      title = prefs.getString('last_read_title');
      cover = prefs.getString('last_read_cover');
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.terakhirDibaca)),
      body: title == null
          ? Center(child: Text(loc.noBookRead))
          : ListTile(
              leading: cover != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        cover!,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.book),
                      ),
                    )
                  : const Icon(Icons.history),
              title: Text(title!),
              subtitle: Text(author!),
            ),
    );
  }
}
