import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import '../platform_core/platform_login_screen.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService, required this.onLogin});

  final AuthService authService;
  final void Function(String sessionKind) onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final marketCode = TextEditingController();
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
    if (marketCode.text.trim().isEmpty || email.text.trim().isEmpty || password.text.trim().isEmpty) {
      setState(() => error = 'کۆدی بازاڕ، ئیمەیڵ و وشەی نهێنی پێویستن');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.authService.login(email: email.text, password: password.text, marketCode: marketCode.text);
      widget.onLogin('tenant');
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void openPlatformLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlatformLoginScreen(authService: widget.authService, onLogin: widget.onLogin)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZhiroxBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 74,
                      height: 74,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [Color(0xFFE7C15F), Color(0xFFFFE2A0)]),
                        border: Border.all(color: const Color(0x33FFFFFF)),
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF111827), size: 36),
                    ),
                    const Text('Zhirox AI Debt', textAlign: TextAlign.center, style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                    const SizedBox(height: 8),
                    const Text('سیستەمی مۆدێرنی پاراستنی پارە و بەڕێوەبردنی قەرز', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                    const SizedBox(height: 28),
                    ZhiroxPanel(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionTitle(title: 'چوونەژوورەوەی مارکێت', subtitle: 'زانیارییەکانت بە سەلامەتی بنووسە'),
                          TextField(controller: marketCode, decoration: const InputDecoration(labelText: 'کۆدی بازاڕ', prefixIcon: Icon(Icons.store_rounded))),
                          const SizedBox(height: 14),
                          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'ئیمەیڵ', prefixIcon: Icon(Icons.alternate_email_rounded))),
                          const SizedBox(height: 14),
                          TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'وشەی نهێنی', prefixIcon: Icon(Icons.lock_rounded))),
                          if (error != null) ...[
                            const SizedBox(height: 14),
                            ZhiroxPanel(
                              padding: const EdgeInsets.all(14),
                              child: Text(error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                            ),
                          ],
                          const SizedBox(height: 22),
                          FilledButton.icon(
                            onPressed: loading ? null : submit,
                            icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.login_rounded),
                            label: const Text('چوونەژوورەوە'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(onPressed: openPlatformLogin, icon: const Icon(Icons.admin_panel_settings_rounded), label: const Text('Platform Panel')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('RTL Kurdish • Secure API • Real-time-ready', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
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
