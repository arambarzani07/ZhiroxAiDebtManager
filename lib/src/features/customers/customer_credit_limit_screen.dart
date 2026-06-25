import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_helpers.dart';
import 'customer_service.dart';

class CustomerCreditLimitScreen extends StatefulWidget {
  const CustomerCreditLimitScreen({super.key, required this.customer, required this.customerService});

  final Map<String, dynamic> customer;
  final CustomerService customerService;

  @override
  State<CustomerCreditLimitScreen> createState() => _CustomerCreditLimitScreenState();
}

class _CustomerCreditLimitScreenState extends State<CustomerCreditLimitScreen> {
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

  Future<void> submit() async {
    final id = customerId(widget.customer);
    if (id.isEmpty) {
      setState(() => error = 'ID ـی کڕیار نەدۆزرایەوە');
      return;
    }
    if (amount.text.trim().isEmpty) {
      setState(() => error = 'بڕی credit limit پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.customerService.requestCreditLimitReview(id, {
        'requested_limit': amount.text.trim(),
        'currency': currency.text.trim().isEmpty ? 'IQD' : currency.text.trim(),
        if (reason.text.trim().isNotEmpty) 'reason': reason.text.trim(),
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
      appBar: AppBar(title: const Text('داواکاری Credit Limit')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ZhiroxPanel(child: Text('بڕی پارە وەک text/string دەنێردرێت، نەک double، بۆ پاراستنی دروستی حساب.')),
          const SizedBox(height: 14),
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕی سنووری قەرز')),
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
                  onPressed: loading ? null : submit,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.rule_rounded),
                  label: const Text('ناردن بۆ پێداچوونەوە'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
