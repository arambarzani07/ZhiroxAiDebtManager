import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'debt_helpers.dart';
import 'debt_service.dart';

class DebtCorrectionRequestScreen extends StatefulWidget {
  const DebtCorrectionRequestScreen({super.key, required this.debtCase, required this.debtService});

  final Map<String, dynamic> debtCase;
  final DebtService debtService;

  @override
  State<DebtCorrectionRequestScreen> createState() => _DebtCorrectionRequestScreenState();
}

class _DebtCorrectionRequestScreenState extends State<DebtCorrectionRequestScreen> {
  final reason = TextEditingController();
  final note = TextEditingController();
  bool loading = false;
  String? error;

  String get debtCaseId => debtText(widget.debtCase, ['id', 'debt_case_id'], fallback: '');

  @override
  void dispose() {
    reason.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (debtCaseId.isEmpty) {
      setState(() => error = 'ID ـی case نەدۆزرایەوە');
      return;
    }
    if (reason.text.trim().isEmpty) {
      setState(() => error = 'هۆکار پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.debtService.requestCorrection(debtCaseId, {
        'reason': reason.text.trim(),
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
      appBar: AppBar(title: const Text('داواکاری ڕاستکردنەوە')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ZhiroxPanel(child: Text('ئەم بەشە تەنها داواکاری پێداچوونەوە دەنێرێت؛ ledger ڕاستەوخۆ ناگۆڕدرێت.')),
          const SizedBox(height: 14),
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: reason, maxLines: 3, decoration: const InputDecoration(labelText: 'هۆکار')),
                const SizedBox(height: 14),
                TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : submit,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.rule_folder_rounded),
                  label: const Text('ناردنی داواکاری'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
