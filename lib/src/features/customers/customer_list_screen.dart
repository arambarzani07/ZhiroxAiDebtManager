import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_create_screen.dart';
import 'customer_helpers.dart';
import 'customer_profile_screen.dart';
import 'customer_service.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key, required this.customerService});

  final CustomerService customerService;

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> customers = [];
  bool loading = true;
  String? error;
  String query = '';

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
      final data = await widget.customerService.listCustomers();
      setState(() => customers = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> createCustomer() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CustomerCreateScreen(customerService: widget.customerService)),
    );
    if (changed == true) load();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = customers.where((customer) {
      final text = '${customerDisplayName(customer)} ${customerPhone(customer)} ${customerStatus(customer)}'.toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('کڕیاران')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createCustomer,
        icon: const Icon(Icons.person_add_alt_rounded),
        label: const Text('کڕیاری نوێ'),
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Customer Brain', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('لیستی کڕیاران بە API پەیوەستە', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), labelText: 'گەڕان'),
            ),
            const SizedBox(height: 16),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && filtered.isEmpty)
              const ZhiroxPanel(child: Text('هیچ کڕیارێک نەدۆزرایەوە.')),
            for (final customer in filtered)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ZhiroxPanel(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(customerDisplayName(customer), style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${customerPhone(customer)} • ${customerStatus(customer)}'),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerProfileScreen(customer: customer, customerService: widget.customerService),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
