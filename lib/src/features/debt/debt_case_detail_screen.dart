import 'package:flutter/material.dart';

import '../customers/customer_helpers.dart';
import '../dashboard/dashboard_widgets.dart';
import '../payments/payment_service.dart';
import '../payments/receive_payment_screen.dart';
import 'debt_correction_request_screen.dart';
import 'debt_helpers.dart';
import 'debt_service.dart';

class DebtCaseDetailScreen extends StatefulWidget {
  const DebtCaseDetailScreen({super.key, required this.customer, required this.debtCase, required this.debtService});

  final Map<String, dynamic> customer;
  final Map<String, dynamic> debtCase;
  final DebtService debtService;

  @override
  State<DebtCaseDetailScreen> createState() => _DebtCaseDetailScreenState();
}

class _DebtCaseDetailScreenState extends State<DebtCaseDetailScreen> {
  Map<String, dynamic>? details;
  bool loading = true;
  String? error;

  String get debtCaseId => debtText(widget.debtCase, ['id', 'debt_case_id'], fallback: '');

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    if (debtCaseId.isEmpty) {
      setState(() {
        loading = false;
        error = 'ID ـی case نەدۆزرایەوە';
      });
      return;
    }
    try {
      final data = await widget.debtService.getDebtCase(debtCaseId);
      setState(() => details = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> receivePayment() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReceivePaymentScreen(
          customer: widget.customer,
          paymentService: PaymentService(widget.debtService.apiClient),
        ),
      ),
    );
    if (changed == true) load();
  }

  Future<void> requestCorrection() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DebtCorrectionRequestScreen(debtCase: widget.debtCase, debtService: widget.debtService)),
    );
    if (changed == true) load();
  }

  @override
  Widget build(BuildContext context) {
    final source = details ?? widget.debtCase;
    return Scaffold(
      appBar: AppBar(title: const Text('وردەکاری Case')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ZhiroxPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customerDisplayName(widget.customer), style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(debtTitle(source), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('${debtAmount(source)} ${debtCurrency(source)}'),
                  const SizedBox(height: 8),
                  Chip(label: Text(debtStatus(source))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (details != null) ZhiroxPanel(child: Text(details.toString())),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: receivePayment, icon: const Icon(Icons.payments_rounded), label: const Text('وەرگرتنی پارە')),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: requestCorrection, icon: const Icon(Icons.rule_folder_rounded), label: const Text('داواکاری ڕاستکردنەوە')),
          ],
        ),
      ),
    );
  }
}
