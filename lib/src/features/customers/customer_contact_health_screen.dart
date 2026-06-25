import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_helpers.dart';
import 'customer_service.dart';

class CustomerContactHealthScreen extends StatefulWidget {
  const CustomerContactHealthScreen({super.key, required this.customer, required this.customerService});

  final Map<String, dynamic> customer;
  final CustomerService customerService;

  @override
  State<CustomerContactHealthScreen> createState() => _CustomerContactHealthScreenState();
}

class _CustomerContactHealthScreenState extends State<CustomerContactHealthScreen> {
  Map<String, dynamic>? health;
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
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final data = await widget.customerService.getContactHealth(id);
      setState(() => health = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String value(String key) => health?[key]?.toString() ?? '-';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Health')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (health != null)
              ZhiroxPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('هەڵسەنگاندنی پەیوەندی', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Text('Score: ${value('score')}'),
                    Text('Verified: ${value('verified_contacts_count')}'),
                    Text('Weak: ${value('weak_contacts_count')}'),
                    Text('Last contact: ${value('last_contact_at')}'),
                    const SizedBox(height: 12),
                    Text(health.toString(), style: const TextStyle(color: Colors.white60)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
