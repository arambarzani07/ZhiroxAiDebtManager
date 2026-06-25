import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'cash_service.dart';

class CashCloseSessionScreen extends StatefulWidget {
  const CashCloseSessionScreen({super.key, required this.cashService});

  final CashService cashService;

  @override
  State<CashCloseSessionScreen> createState() => _CashCloseSessionScreenState();
}

class _CashCloseSessionScreenState extends State<CashCloseSessionScreen> {
  final finalBalance = TextEditingController();
  final note = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    finalBalance.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (finalBalance.text.trim().isEmpty) {
      setState(() => error = 'بڕی کۆتایی پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.cashService.closeCurrentSession({
        'closing_balance': finalBalance.text.trim(),
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
      appBar: AppBar(title: const Text('کۆتایی Cash Session')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: finalBalance, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕی کۆتایی')),
                const SizedBox(height: 14),
                TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : save,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.stop_circle_rounded),
                  label: const Text('کۆتاییهێنان'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
