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
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => CustomerCreateScreen(customerService: widget.customerService)));
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
      floatingActionButton: FloatingActionButton.extended(onPressed: createCustomer, icon: const Icon(Icons.person_add_alt_rounded), label: const Text('کڕیاری نوێ')),
      body: ZhiroxBackground(
        child: RefreshIndicator(
          onRefresh: load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
            children: [
              ZhiroxPanel(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: const LinearGradient(colors: [Color(0xFFE7C15F), Color(0xFFFFE2A0)])),
                      child: const Icon(Icons.people_alt_rounded, color: Color(0xFF111827)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Customer Brain', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: -0.4)),
                          const SizedBox(height: 4),
                          Text('${filtered.length} / ${customers.length} کڕیار', style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(onChanged: (value) => setState(() => query = value), decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), labelText: 'گەڕان بە ناو، ژمارە، دۆخ')),
              const SizedBox(height: 16),
              if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
              if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
              if (!loading && error == null && filtered.isEmpty) const ZhiroxPanel(child: Text('هیچ کڕیارێک نەدۆزرایەوە.')),
              for (final customer in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ZhiroxPanel(
                    padding: const EdgeInsets.all(16),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(color: const Color(0xFF16243A), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.person_rounded, color: Color(0xFFE7C15F)),
                      ),
                      title: Text(customerDisplayName(customer), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                      subtitle: Padding(padding: const EdgeInsets.only(top: 4), child: Text('${customerPhone(customer)} • ${customerStatus(customer)}', style: const TextStyle(color: Color(0xFF94A3B8)))),
                      trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerProfileScreen(customer: customer, customerService: widget.customerService))),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
