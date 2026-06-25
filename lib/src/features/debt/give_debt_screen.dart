import 'package:flutter/material.dart';

import '../customers/customer_helpers.dart';
import '../dashboard/dashboard_widgets.dart';
import 'debt_service.dart';

class GiveDebtScreen extends StatefulWidget {
  const GiveDebtScreen({super.key, required this.customer, required this.debtService});

  final Map<String, dynamic> customer;
  final DebtService debtService;

  @override
  State<GiveDebtScreen> createState() => _GiveDebtScreenState();
}

class _GiveDebtScreenState extends State<GiveDebtScreen> {
  final amount = TextEditingController();
  final currency = TextEditingController(text: 'IQD');
  final dueDate = TextEditingController();
  final note = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    currency.dispose();
    dueDate.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final id = customerId(widget.customer);
    if (id.isEmpty) {
      setState(() => error = 'ID ـی کڕیار نەدۆزرایەوە');
      return;
    }
    if (amount.text.trim().isEmpty) {
      setState(() => error = 'بڕی قەرز پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.debtService.createDebt(id, {
        'amount': amount.text.trim(),
        'currency': currency.text.trim().isEmpty ? 'IQD' : currency.text.trim(),
        if (dueDate.text.trim().isNotEmpty) 'due_date': dueDate.text.trim(),
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
      appBar: AppBar(title: const Text('دانانی قەرز')),
      body: ZhiroxBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            const SectionTitle(title: 'دانانی قەرز', subtitle: 'بڕی پارە وەک string دەنێردرێت بۆ پاراستنی حساب'),
            ZhiroxPanel(
              child: Column(
                children: [
                  TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕی قەرز', prefixIcon: Icon(Icons.add_card_rounded))),
                  const SizedBox(height: 14),
                  TextField(controller: currency, decoration: const InputDecoration(labelText: 'دراو', prefixIcon: Icon(Icons.payments_rounded))),
                  const SizedBox(height: 14),
                  TextField(controller: dueDate, decoration: const InputDecoration(labelText: 'بەرواری گەڕاندنەوە', prefixIcon: Icon(Icons.event_rounded))),
                  const SizedBox(height: 14),
                  TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی', prefixIcon: Icon(Icons.edit_note_rounded))),
                  if (error != null) ...[
                    const SizedBox(height: 14),
                    FriendlyErrorPanel(message: error!),
                  ],
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: loading ? null : save,
                    icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add_card_rounded),
                    label: const Text('پاشەکەوتکردنی قەرز'),
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
