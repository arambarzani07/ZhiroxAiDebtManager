import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'cash_service.dart';

class CashHandoverScreen extends StatefulWidget {
  const CashHandoverScreen({super.key, required this.cashService});

  final CashService cashService;

  @override
  State<CashHandoverScreen> createState() => _CashHandoverScreenState();
}

class _CashHandoverScreenState extends State<CashHandoverScreen> {
  final amount = TextEditingController();
  final currency = TextEditingController(text: 'IQD');
  final receiverUserId = TextEditingController();
  final note = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    currency.dispose();
    receiverUserId.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (amount.text.trim().isEmpty) {
      setState(() => error = 'بڕی handover پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.cashService.createHandover({
        'amount': amount.text.trim(),
        'currency': currency.text.trim().isEmpty ? 'IQD' : currency.text.trim(),
        if (receiverUserId.text.trim().isNotEmpty) 'receiver_user_id': receiverUserId.text.trim(),
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
      appBar: AppBar(title: const Text('Cash Handover')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕ')),
                const SizedBox(height: 14),
                TextField(controller: currency, decoration: const InputDecoration(labelText: 'دراو')),
                const SizedBox(height: 14),
                TextField(controller: receiverUserId, decoration: const InputDecoration(labelText: 'ID ـی وەرگر')),
                const SizedBox(height: 14),
                TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : save,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.swap_horiz_rounded),
                  label: const Text('پاشەکەوتکردنی Handover'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
