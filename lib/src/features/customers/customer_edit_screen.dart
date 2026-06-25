import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_helpers.dart';
import 'customer_service.dart';

class CustomerEditScreen extends StatefulWidget {
  const CustomerEditScreen({super.key, required this.customer, required this.customerService});

  final Map<String, dynamic> customer;
  final CustomerService customerService;

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  late final TextEditingController name;
  late final TextEditingController phone;
  late final TextEditingController note;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: customerDisplayName(widget.customer) == 'کڕیاری بێ ناو' ? '' : customerDisplayName(widget.customer));
    phone = TextEditingController(text: customerPhone(widget.customer) == 'ژمارە نییە' ? '' : customerPhone(widget.customer));
    note = TextEditingController(text: textValue(widget.customer, ['note', 'description'], fallback: ''));
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final id = customerId(widget.customer);
    if (id.isEmpty) {
      setState(() => error = 'ID ـی کڕیار نەدۆزرایەوە');
      return;
    }
    if (name.text.trim().isEmpty) {
      setState(() => error = 'ناوی کڕیار پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.customerService.updateCustomer(id, {
        'full_name_ku': name.text.trim(),
        if (phone.text.trim().isNotEmpty) 'primary_phone': phone.text.trim(),
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
      appBar: AppBar(title: const Text('دەستکاری کڕیار')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'ناوی کڕیار')),
                const SizedBox(height: 14),
                TextField(controller: phone, decoration: const InputDecoration(labelText: 'ژمارەی سەرەکی')),
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
