import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'cash_service.dart';

class CashDiscrepancyScreen extends StatefulWidget {
  const CashDiscrepancyScreen({super.key, required this.cashService});

  final CashService cashService;

  @override
  State<CashDiscrepancyScreen> createState() => _CashDiscrepancyScreenState();
}

class _CashDiscrepancyScreenState extends State<CashDiscrepancyScreen> {
  final amount = TextEditingController();
  final currency = TextEditingController(text: 'IQD');
  final reason = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    currency.dispose();
    reason.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (amount.text.trim().isEmpty || reason.text.trim().isEmpty) {
      setState(() => error = 'بڕ و هۆکار پێویستن');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.cashService.createDiscrepancy({
        'amount': amount.text.trim(),
        'currency': currency.text.trim().isEmpty ? 'IQD' : currency.text.trim(),
        'reason': reason.text.trim(),
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
      appBar: AppBar(title: const Text('Cash Discrepancy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕی جیاوازی')),
                const SizedBox(height: 14),
                TextField(controller: currency, decoration: const InputDecoration(labelText: 'دراو')),
                const SizedBox(height: 14),
                TextField(controller: reason, maxLines: 3, decoration: const InputDecoration(labelText: 'هۆکار')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : save,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.warning_rounded),
                  label: const Text('پاشەکەوتکردنی جیاوازی'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
