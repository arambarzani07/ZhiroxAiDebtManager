import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'report_list_screen.dart';
import 'report_service.dart';

class ReportsDashboardScreen extends StatefulWidget {
  const ReportsDashboardScreen({super.key, required this.reportService});

  final ReportService reportService;

  @override
  State<ReportsDashboardScreen> createState() => _ReportsDashboardScreenState();
}

class _ReportsDashboardScreenState extends State<ReportsDashboardScreen> {
  Map<String, dynamic>? debtSummary;
  Map<String, dynamic>? paymentStatus;
  Map<String, dynamic>? cashReport;
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
      final loadedDebtSummary = await widget.reportService.getDebtSummary();
      final loadedPaymentStatus = await widget.reportService.getPaymentStatusReport();
      final loadedCashReport = await widget.reportService.getCashReport();
      setState(() {
        debtSummary = loadedDebtSummary;
        paymentStatus = loadedPaymentStatus;
        cashReport = loadedCashReport;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String value(Map<String, dynamic>? data, String key) => data?[key]?.toString() ?? '-';

  void openTopCustomers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportListScreen(title: 'Top Customers', loader: widget.reportService.listTopCustomers),
      ),
    );
  }

  void openEmployeeActivity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportListScreen(title: 'Employee Activity', loader: widget.reportService.listEmployeeActivity),
      ),
    );
  }

  Widget reportPanel(String title, Map<String, dynamic>? data, List<String> keys) {
    if (data == null) return ZhiroxPanel(child: Text('$title: -'));
    return ZhiroxPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (final key in keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(key, style: const TextStyle(color: Colors.white60)),
                  Flexible(child: Text(value(data, key), textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          const Divider(height: 24),
          Text(data.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null) ...[
              reportPanel('Debt Summary', debtSummary, const ['total_debt', 'total_paid', 'remaining_balance', 'overdue_amount']),
              const SizedBox(height: 12),
              reportPanel('Payment Status', paymentStatus, const ['paid_count', 'unpaid_count', 'paid_amount', 'unpaid_amount']),
              const SizedBox(height: 12),
              reportPanel('Cash Report', cashReport, const ['opening_balance', 'closing_balance', 'expected_balance', 'actual_balance']),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: openTopCustomers, icon: const Icon(Icons.people_alt_rounded), label: const Text('Top Customers')),
              const SizedBox(height: 10),
              OutlinedButton.icon(onPressed: openEmployeeActivity, icon: const Icon(Icons.badge_rounded), label: const Text('Employee Activity')),
            ],
          ],
        ),
      ),
    );
  }
}
