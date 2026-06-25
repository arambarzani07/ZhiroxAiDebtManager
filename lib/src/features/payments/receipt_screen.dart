import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'receipt_delivery_log_screen.dart';
import 'payment_service.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key, required this.paymentId, required this.paymentService});

  final String paymentId;
  final PaymentService paymentService;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  Map<String, dynamic>? receipt;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final data = await widget.paymentService.getReceipt(widget.paymentId);
      setState(() => receipt = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String value(String key) => receipt?[key]?.toString() ?? '-';

  void openDeliveryLog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReceiptDeliveryLogScreen(paymentId: widget.paymentId, paymentService: widget.paymentService),
      ),
    );
  }

  void showSharePlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print/Share لە قۆناغی release hardening پەیوەست دەکرێت.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پسوولە')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (receipt != null)
              ZhiroxPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Zhirox AI Debt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text('Receipt No: ${value('receipt_number')}'),
                    Text('Payment ID: ${widget.paymentId}'),
                    const Divider(height: 28),
                    Text('Customer: ${value('customer_name')}'),
                    Text('Amount: ${value('amount')} ${value('currency')}'),
                    Text('Date: ${value('created_at')}'),
                    const Divider(height: 28),
                    Text(receipt.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: openDeliveryLog, icon: const Icon(Icons.mark_email_read_rounded), label: const Text('Receipt Delivery Log')),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: showSharePlaceholder, icon: const Icon(Icons.print_rounded), label: const Text('Print / Share Placeholder')),
          ],
        ),
      ),
    );
  }
}
