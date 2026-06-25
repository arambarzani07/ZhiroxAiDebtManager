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
      appBar: AppBar(title: const Text('Platform Login')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: ZhiroxPanel(
                child: Column(
                  children: [
                    const Text('Platform Panel', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 18),
                    TextField(controller: email, decoration: const InputDecoration(labelText: 'ئیمەیڵ')),
                    const SizedBox(height: 14),
                    TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'وشەی نهێنی')),
                    if (error != null) ...[
                      const SizedBox(height: 14),
                      Text(error!, style: const TextStyle(color: Colors.redAccent)),
                    ],
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: loading ? null : submit,
                      child: loading ? const CircularProgressIndicator() : const Text('چوونەژوورەوە'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
