import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../dashboard/dashboard_widgets.dart';

class PlatformLoginScreen extends StatefulWidget {
  const PlatformLoginScreen({super.key, required this.authService, required this.onLogin});

  final AuthService authService;
  final void Function(String sessionKind) onLogin;

  @override
  State<PlatformLoginScreen> createState() => _PlatformLoginScreenState();
}

class _PlatformLoginScreenState extends State<PlatformLoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      setState(() => error = 'ئیمەیڵ و وشەی نهێنی پێویستن');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.authService.loginSystemOwner(email: email.text, password: password.text);
      widget.onLogin('owner');
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Platform Panel')),
      body: ZhiroxBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ZhiroxPanel(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [Color(0xFF37D7FF), Color(0xFFE7C15F)])),
                        child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF111827), size: 34),
                      ),
                      const SectionTitle(title: 'چوونەژوورەوەی Platform', subtitle: 'تەنها بۆ خاوەنی سیستەم و بەڕێوەبردنی license'),
                      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'ئیمەیڵ', prefixIcon: Icon(Icons.alternate_email_rounded))),
                      const SizedBox(height: 14),
                      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'وشەی نهێنی', prefixIcon: Icon(Icons.lock_rounded))),
                      if (error != null) ...[
                        const SizedBox(height: 14),
                        Text(error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                      ],
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        onPressed: loading ? null : submit,
                        icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login_rounded),
                        label: const Text('چوونەژوورەوە'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
