import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'payment_service.dart';
import 'receipt_screen.dart';

class PaymentAllocationScreen extends StatefulWidget {
  const PaymentAllocationScreen({super.key, required this.paymentId, required this.paymentService});

  final String paymentId;
  final PaymentService paymentService;

  @override
  State<PaymentAllocationScreen> createState() => _PaymentAllocationScreenState();
}

class _PaymentAllocationScreenState extends State<PaymentAllocationScreen> {
  List<Map<String, dynamic>> allocations = [];
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
      final data = await widget.paymentService.listAllocations(widget.paymentId);
      setState(() => allocations = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void openReceipt() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReceiptScreen(paymentId: widget.paymentId, paymentService: widget.paymentService)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Allocation')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ZhiroxPanel(child: Text('ئەم بەشە پیشانی دەدات پارەدانەکە چۆن دابەش کراوە.')),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: openReceipt, icon: const Icon(Icons.receipt_long_rounded), label: const Text('کردنەوەی پسوولە')),
            const SizedBox(height: 14),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && allocations.isEmpty) const ZhiroxPanel(child: Text('هێشتا allocation دیار نییە.')),
            for (final item in allocations)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ZhiroxPanel(child: Text(item.toString())),
              ),
          ],
        ),
      ),
    );
  }
}
