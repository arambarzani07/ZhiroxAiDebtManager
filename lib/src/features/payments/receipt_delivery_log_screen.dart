import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'delivery_status_card.dart';
import 'payment_service.dart';

class ReceiptDeliveryLogScreen extends StatefulWidget {
  const ReceiptDeliveryLogScreen({super.key, required this.paymentId, required this.paymentService});

  final String paymentId;
  final PaymentService paymentService;

  @override
  State<ReceiptDeliveryLogScreen> createState() => _ReceiptDeliveryLogScreenState();
}

class _ReceiptDeliveryLogScreenState extends State<ReceiptDeliveryLogScreen> {
  List<Map<String, dynamic>> logs = [];
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
      final data = await widget.paymentService.listReceiptDeliveryLogs(widget.paymentId);
      setState(() => logs = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Delivery Log')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ZhiroxPanel(child: Text('مێژووی ناردنی پسوولە بە شێوەی کارت پیشان دەدرێت.')),
            const SizedBox(height: 14),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && logs.isEmpty) const ZhiroxPanel(child: Text('هیچ delivery log ـێک نییە.')),
            for (final item in logs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DeliveryStatusCard(item: item),
              ),
          ],
        ),
      ),
    );
  }
}
