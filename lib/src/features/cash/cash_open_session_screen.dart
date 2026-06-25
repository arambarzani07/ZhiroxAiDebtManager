import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'cash_service.dart';

class CashOpenSessionScreen extends StatefulWidget {
  const CashOpenSessionScreen({super.key, required this.cashService});

  final CashService cashService;

  @override
  State<CashOpenSessionScreen> createState() => _CashOpenSessionScreenState();
}

class _CashOpenSessionScreenState extends State<CashOpenSessionScreen> {
  final startBalance = TextEditingController();
  final currency = TextEditingController(text: 'IQD');
  final note = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    startBalance.dispose();
    currency.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (startBalance.text.trim().isEmpty) {
      setState(() => error = 'بڕی سەرەتایی پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.cashService.openSession({
        'opening_balance': startBalance.text.trim(),
        'currency': currency.text.trim().isEmpty ? 'IQD' : currency.text.trim(),
        if (note.text.trim().isNotEmpty) 'note': note.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دەستپێکردنی Cash Session')),
      body: ZhiroxBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            const SectionTitle(title: 'Cash Session', subtitle: 'دەستپێکردنی سندووق بە بڕی سەرەتایی'),
            ZhiroxPanel(
              child: Column(
                children: [
                  TextField(controller: startBalance, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕی سەرەتایی', prefixIcon: Icon(Icons.payments_rounded))),
                  const SizedBox(height: 14),
                  TextField(controller: currency, decoration: const InputDecoration(labelText: 'دراو', prefixIcon: Icon(Icons.account_balance_wallet_rounded))),
                  const SizedBox(height: 14),
                  TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی', prefixIcon: Icon(Icons.edit_note_rounded))),
                  if (error != null) ...[
                    const SizedBox(height: 14),
                    FriendlyErrorPanel(message: error!),
                  ],
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: loading ? null : save,
                    icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.play_arrow_rounded),
                    label: const Text('دەستپێکردن'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
