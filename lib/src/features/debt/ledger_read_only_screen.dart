import 'package:flutter/material.dart';

import '../customers/customer_helpers.dart';
import '../dashboard/dashboard_widgets.dart';
import 'debt_helpers.dart';
import 'debt_service.dart';

class LedgerReadOnlyScreen extends StatefulWidget {
  const LedgerReadOnlyScreen({super.key, required this.customer, required this.debtService});

  final Map<String, dynamic> customer;
  final DebtService debtService;

  @override
  State<LedgerReadOnlyScreen> createState() => _LedgerReadOnlyScreenState();
}

class _LedgerReadOnlyScreenState extends State<LedgerReadOnlyScreen> {
  List<Map<String, dynamic>> records = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
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
    try {
      final data = await widget.debtService.listCustomerLedger(id);
      setState(() => records = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ledger — تەنها خوێندنەوە')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ZhiroxPanel(child: Text('Ledger تەنها خوێندنەوەیە. دەستکاری و سڕینەوە لێرە نییە.')),
            const SizedBox(height: 14),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && records.isEmpty) const ZhiroxPanel(child: Text('هیچ تۆمارێکی ledger نییە.')),
            for (final item in records)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ZhiroxPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(debtTitle(item), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('${debtAmount(item)} ${debtCurrency(item)}'),
                      const SizedBox(height: 6),
                      Text(item.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
