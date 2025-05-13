import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Ganti Password (Coming Soon)"),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("Bahasa (Coming Soon)"),
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text("Tema (Coming Soon)"),
          ),
        ],
      ),
    );
  }
}
