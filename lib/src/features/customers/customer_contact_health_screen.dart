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
      body: ZhiroxBackground(
        child: RefreshIndicator(
          onRefresh: load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
              const SectionTitle(title: 'Contact Health', subtitle: 'هەڵسەنگاندنی ژمارە و توانای پەیوەندی بە کڕیار'),
              if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
              if (error != null) FriendlyErrorPanel(message: error!, onRetry: load),
              if (!loading && error == null && health == null) const ZhiroxPanel(child: Text('زانیاری پەیوەندی بەردەست نییە.')),
              if (health != null) ...[
                Row(
                  children: [
                    Expanded(child: MetricCard(title: 'Score', value: value('score'), subtitle: 'contact quality', icon: Icons.health_and_safety_rounded)),
                    const SizedBox(width: 10),
                    Expanded(child: MetricCard(title: 'Verified', value: value('verified_contacts_count'), subtitle: 'پەیوەندی پشتڕاست', icon: Icons.verified_rounded)),
                  ],
                ),
                const SizedBox(height: 12),
                ZhiroxPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('وردەکاری', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      Text('Weak: ${value('weak_contacts_count')}'),
                      Text('Last contact: ${value('last_contact_at')}'),
                      const SizedBox(height: 12),
                      Text(health.toString(), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
