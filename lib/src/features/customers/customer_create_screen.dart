import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_service.dart';

class CustomerCreateScreen extends StatefulWidget {
  const CustomerCreateScreen({super.key, required this.customerService});

  final CustomerService customerService;

  @override
  State<CustomerCreateScreen> createState() => _CustomerCreateScreenState();
}

class _CustomerCreateScreenState extends State<CustomerCreateScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final note = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (name.text.trim().isEmpty) {
      setState(() => error = 'ناوی کڕیار پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.customerService.createCustomer(
        fullNameKu: name.text,
        phone: phone.text,
        note: note.text,
      );
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
      appBar: AppBar(title: const Text('زیادکردنی کڕیار')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'ناوی کڕیار')),
                const SizedBox(height: 14),
                TextField(controller: phone, decoration: const InputDecoration(labelText: 'ژمارەی مۆبایل')),
                const SizedBox(height: 14),
                TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : save,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_rounded),
                  label: const Text('پاشەکەوتکردن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
