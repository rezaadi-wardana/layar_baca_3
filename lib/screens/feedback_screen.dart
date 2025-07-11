import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Clipboard
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  final supabase = Supabase.instance.client;


Future<void> _sendEmail() async {
  final session = Supabase.instance.client.auth.currentSession;

  if (session == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silakan login terlebih dahulu untuk memberikan masukan.'),
      ),
    );
    return;
  }

  final feedback = _feedbackController.text.trim();
  if (feedback.isEmpty) return;

  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'wardhana15.aw@gmail.com',
    queryParameters: {
      'subject': 'Kritik dan Saran untuk Aplikasi Layar Baca',
      'body': 'Berikut ini kritik dan saran saya:\n$feedback',
    },
  );

  try {
    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka aplikasi email');
    }
  } catch (e) {
    await Clipboard.setData(ClipboardData(text: feedback));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gagal membuka email. Teks telah disalin ke clipboard.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.feedback)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(loc.beriMasukan),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: loc.writeFeedback,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _sendEmail, child: Text(loc.send)),
          ],
        ),
      ),
    );
  }
}
