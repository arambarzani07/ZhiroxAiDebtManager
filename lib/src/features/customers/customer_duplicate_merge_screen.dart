import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_helpers.dart';
import 'customer_service.dart';

class CustomerDuplicateMergeScreen extends StatefulWidget {
  const CustomerDuplicateMergeScreen({super.key, required this.customer, required this.customerService});

  final Map<String, dynamic> customer;
  final CustomerService customerService;

  @override
  State<CustomerDuplicateMergeScreen> createState() => _CustomerDuplicateMergeScreenState();
}

class _CustomerDuplicateMergeScreenState extends State<CustomerDuplicateMergeScreen> {
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
      final data = await widget.customerService.findDuplicates(id);
      setState(() => records = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> sendRequest(Map<String, dynamic> record) async {
    final sourceId = customerId(widget.customer);
    final targetId = customerId(record);
    if (sourceId.isEmpty || targetId.isEmpty) return;
    await widget.customerService.requestMerge(sourceId, {
      'target_customer_id': targetId,
      'reason': 'similar customer profile',
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('داواکاری نێردرا')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Duplicate Review')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const ZhiroxPanel(child: Text('ئەم بەشە تەنها داواکاری پێداچوونەوە دەنێرێت.')),
            const SizedBox(height: 14),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && records.isEmpty) const ZhiroxPanel(child: Text('هیچ تۆماری هاوشێوە نەدۆزرایەوە.')),
            for (final record in records)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ZhiroxPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customerDisplayName(record), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(customerPhone(record), style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => sendRequest(record),
                        icon: const Icon(Icons.compare_arrows_rounded),
                        label: const Text('ناردنی داواکاری'),
                      ),
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
