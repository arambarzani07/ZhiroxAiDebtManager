import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'customer_helpers.dart';
import 'customer_service.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key, required this.customer, required this.customerService});

  final Map<String, dynamic> customer;
  final CustomerService customerService;

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  Map<String, dynamic>? profile;
  String? error;
  bool loading = true;

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
      final data = await widget.customerService.getProfile(id);
      setState(() => profile = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = customerDisplayName(widget.customer);
    final phone = customerPhone(widget.customer);
    final status = customerStatus(widget.customer);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ZhiroxPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(phone, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Chip(label: Text(status)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (profile != null)
              ZhiroxPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('پرۆفایلی تەواو', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(profile.toString()),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const ZhiroxPanel(
              child: Text('قۆناغی داهاتوو: timeline ـی قەرز و پارەدان، contact health، guarantor، evidence و credit lock بە شێوەی کارت زیاد دەکرێن.'),
            ),
          ],
        ),
      ),
    );
  }
}
