import 'package:flutter/material.dart';

import '../../core/config/api_config.dart';
import '../dashboard/dashboard_widgets.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService, required this.onLogin});

  final AuthService authService;
  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(text: 'admin@zhirox.test');
  final password = TextEditingController(text: 'Admin@12345');
  final marketCode = TextEditingController(text: ApiConfig.defaultMarketCode);
  bool loading = false;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    marketCode.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.authService.login(
        email: email.text,
        password: password.text,
        marketCode: marketCode.text,
      );
      widget.onLogin();
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Zhirox AI Debt', textAlign: TextAlign.center, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('سیستەمی زیرەکی بەڕێوەبردنی قەرز', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 28),
                  ZhiroxPanel(
                    child: Column(
                      children: [
                        TextField(controller: marketCode, decoration: const InputDecoration(labelText: 'کۆدی بازاڕ')),
                        const SizedBox(height: 14),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
