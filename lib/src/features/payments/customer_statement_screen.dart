import 'package:flutter/material.dart';

import '../customers/customer_helpers.dart';
import '../dashboard/dashboard_widgets.dart';
import 'payment_service.dart';

class CustomerStatementScreen extends StatefulWidget {
  const CustomerStatementScreen({super.key, required this.customer, required this.paymentService});

  final Map<String, dynamic> customer;
  final PaymentService paymentService;

  @override
  State<CustomerStatementScreen> createState() => _CustomerStatementScreenState();
}

class _CustomerStatementScreenState extends State<CustomerStatementScreen> {
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
  final currency = TextEditingController(text: 'IQD');
  Map<String, dynamic>? statement;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    fromDate.dispose();
    toDate.dispose();
    currency.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final id = customerId(widget.customer);
    if (id.isEmpty) {
      setState(() {
        loading = false;
        error = 'ID ـی کڕیار نەدۆزرایەوە';
      });
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final data = await widget.paymentService.getCustomerStatement(
        id,
        fromDate: fromDate.text,
        toDate: toDate.text,
        currency: currency.text,
      );
      setState(() => statement = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String value(String key) => statement?[key]?.toString() ?? '-';

  void showExportPlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF / Share export لە قۆناغی کۆتایی پەیوەست دەکرێت.')),
    );
  }

  Widget filterBox() {
    return ZhiroxPanel(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: fromDate, decoration: const InputDecoration(labelText: 'لە بەروار'))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: toDate, decoration: const InputDecoration(labelText: 'تا بەروار'))),
            ],
          ),
          const SizedBox(height: 12),
          TextField(controller: currency, decoration: const InputDecoration(labelText: 'دراو')),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: load, icon: const Icon(Icons.filter_alt_rounded), label: const Text('جێبەجێکردنی فلتەر')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statement ـی کڕیار')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ZhiroxPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customerDisplayName(widget.customer), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(customerPhone(widget.customer), style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            filterBox(),
            const SizedBox(height: 14),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (statement != null)
              ZhiroxPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('کورتەی حساب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Total debt: ${value('total_debt')}'),
                    Text('Total paid: ${value('total_paid')}'),
                    Text('Remaining: ${value('remaining_balance')}'),
                    const Divider(height: 28),
                    Text(statement.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            OutlinedButton.icon(onPressed: showExportPlaceholder, icon: const Icon(Icons.picture_as_pdf_rounded), label: const Text('PDF / Share Placeholder')),
          ],
        ),
      ),
    );
  }
}
