import 'package:flutter/material.dart';

import '../customers/customer_helpers.dart';
import '../dashboard/dashboard_widgets.dart';
import 'payment_allocation_screen.dart';
import 'payment_service.dart';

class ReceivePaymentScreen extends StatefulWidget {
  const ReceivePaymentScreen({super.key, required this.customer, required this.paymentService});

  final Map<String, dynamic> customer;
  final PaymentService paymentService;

  @override
  State<ReceivePaymentScreen> createState() => _ReceivePaymentScreenState();
}

class _ReceivePaymentScreenState extends State<ReceivePaymentScreen> {
  final amount = TextEditingController();
  final currency = TextEditingController(text: 'IQD');
  final note = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    currency.dispose();
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
      setState(() => error = 'بڕی پارەدان پێویستە');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final result = await widget.paymentService.receivePayment(id, {
        'amount': amount.text.trim(),
        'currency': currency.text.trim().isEmpty ? 'IQD' : currency.text.trim(),
        if (note.text.trim().isNotEmpty) 'note': note.text.trim(),
      });
      if (!mounted) return;
      final paymentId = result['payment_id']?.toString() ?? result['id']?.toString();
      if (paymentId != null && paymentId.isNotEmpty) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaymentAllocationScreen(paymentId: paymentId, paymentService: widget.paymentService)),
        );
      }
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
      appBar: AppBar(title: const Text('وەرگرتنی پارە')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const ZhiroxPanel(child: Text('بڕی پارەدان وەک string دەنێردرێت بۆ پاراستنی دروستی حساب.')),
          const SizedBox(height: 14),
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'بڕی پارەدان')),
                const SizedBox(height: 14),
                TextField(controller: currency, decoration: const InputDecoration(labelText: 'دراو')),
                const SizedBox(height: 14),
                TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'تێبینی')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : save,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.payments_rounded),
                  label: const Text('پاشەکەوتکردنی پارەدان'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
