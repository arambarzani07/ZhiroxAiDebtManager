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

  Widget infoRow(String label, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60)),
          Flexible(child: Text(data, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.receipt_long_rounded, size: 42),
                    const SizedBox(height: 12),
                    const Text('Zhirox AI Debt', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    const Text('پسوولەی پارەدان', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
                    const Divider(height: 32),
                    infoRow('ژمارەی پسوولە', value('receipt_number')),
                    infoRow('Payment ID', widget.paymentId),
                    infoRow('کڕیار', value('customer_name')),
                    infoRow('بڕ', '${value('amount')} ${value('currency')}'),
                    infoRow('بەروار', value('created_at')),
                    const Divider(height: 32),
                    Text(receipt.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: openDeliveryLog, icon: const Icon(Icons.mark_email_read_rounded), label: const Text('Delivery Log')),
          ],
        ),
      ),
    );
  }
}
