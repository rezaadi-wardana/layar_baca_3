import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;
  Map<String, dynamic>? profileData;

  Future<Map<String, dynamic>> _getProfileData() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception("User tidak ditemukan");
    }

    final response =
        await supabase.from('profiles').select().eq('id', user.id).single();

    return response;
  }

  Future<void> _login() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Berhasil Login')));
        await _fetchProfile();
        setState(() {});
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response =
          await supabase.from('profiles').select().eq('id', user.id).single();

      setState(() {
        profileData = response;
      });
    }
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    profileData = null;
    setState(() {});
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Widget _buildLoggedOutView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 40),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.red,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text("Belum memiliki akses? Silakan login terlebih dahulu"),
        ),
        const SizedBox(height: 20),
        _buildTextField(_emailController, "Email"),
        const SizedBox(height: 10),
        _buildTextField(_passwordController, "Password", obscure: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child:
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
        ),
        const SizedBox(height: 10),
        const Center(child: Text("Belum punya akun?")),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text("Daftar"),
        ),
        const SizedBox(height: 30),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Pengaturan"),
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback),
          title: const Text("Kritik dan Saran"),
          onTap: () {
            Navigator.pushNamed(context, '/feedback');
          },
        ),
      ],
    );
  }

  Widget _buildLoggedInView() {
    final user = supabase.auth.currentUser;

    return FutureBuilder<Map<String, dynamic>>(
      future: _getProfileData(), // Fungsi baru yang return data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Gagal memuat data profil."));
        }

        final profile = snapshot.data!;
        final email = user?.email ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile['nama'] ?? '-',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile['username'] ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Logout"),
            ),
            const SizedBox(height: 30),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text("Buku Favorit"),
              onTap: () {
                Navigator.pushNamed(context, '/favorite');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Terakhir Dibaca"),
              onTap: () {
                Navigator.pushNamed(context, '/recent');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Pengaturan"),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("Kritik dan Saran"),
              onTap: () {
                Navigator.pushNamed(context, '/feedback');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: session == null ? _buildLoggedOutView() : _buildLoggedInView(),
    );
  }
}
