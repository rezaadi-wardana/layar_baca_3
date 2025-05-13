import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _namaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHpController = TextEditingController();

  bool isLoading = false;

  Future<void> _registerWithEmail() async {
  setState(() => isLoading = true);

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final username = _usernameController.text.trim();
  final nama = _namaController.text.trim();
  final noHp = _nomorHpController.text.trim();

  try {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      throw Exception("User ID tidak tersedia.");
    }

    final userId = user.id;

    final insertResponse = await Supabase.instance.client
        .from('profiles')
        .insert({
          'id': userId,
          'username': username,
          'nama': nama,
          'email': email,
          'no_hp': noHp,
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil mendaftar. Silakan login.')),
    );

    Navigator.pop(context);
  } on AuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Auth error: ${e.message}')),
    );
  } on PostgrestException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database error: ${e.message}')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error tidak diketahui: $e')),
    );
  } finally {
    setState(() => isLoading = false);
  }
}


  Future<void> _signInWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal login dengan Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.account_circle, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            _buildTextField("Username", _usernameController),
            _buildTextField("Nama", _namaController),
            _buildTextField("Password", _passwordController, isPassword: true),
            _buildTextField("Email", _emailController),
            _buildTextField("Nomor HP", _nomorHpController),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: isLoading ? null : _registerWithEmail,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                        "Daftar",
                        style: TextStyle(color: Colors.red),
                      ),
            ),
            const SizedBox(height: 16),
            const Text("Punya Akun Google?"),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.g_mobiledata, color: Colors.red),
              label: const Text("Google Account"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
