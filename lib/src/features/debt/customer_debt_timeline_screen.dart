import 'package:flutter/material.dart';

import '../customers/customer_helpers.dart';
import '../dashboard/dashboard_widgets.dart';
import 'debt_case_detail_screen.dart';
import 'debt_helpers.dart';
import 'debt_service.dart';
import 'give_debt_screen.dart';
import 'ledger_read_only_screen.dart';

class CustomerDebtTimelineScreen extends StatefulWidget {
  const CustomerDebtTimelineScreen({super.key, required this.customer, required this.debtService});

  final Map<String, dynamic> customer;
  final DebtService debtService;

  @override
  State<CustomerDebtTimelineScreen> createState() => _CustomerDebtTimelineScreenState();
}

class _CustomerDebtTimelineScreenState extends State<CustomerDebtTimelineScreen> {
  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> cases = [];
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
      final loadedAccounts = await widget.debtService.listCustomerDebtAccounts(id);
      final loadedCases = await widget.debtService.listCustomerDebtCases(id);
      setState(() {
        accounts = loadedAccounts;
        cases = loadedCases;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> openGiveDebt() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => GiveDebtScreen(customer: widget.customer, debtService: widget.debtService)),
    );
    if (changed == true) load();
  }

  void openLedger() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LedgerReadOnlyScreen(customer: widget.customer, debtService: widget.debtService)),
    );
  }

  Future<void> openCase(Map<String, dynamic> debtCase) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DebtCaseDetailScreen(customer: widget.customer, debtCase: debtCase, debtService: widget.debtService),
      ),
    );
    if (changed == true) load();
  }

  Widget itemCard(Map<String, dynamic> item, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZhiroxPanel(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(debtTitle(item), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${debtAmount(item)} ${debtCurrency(item)}'),
              const SizedBox(height: 6),
              Chip(label: Text(debtStatus(item))),
              const SizedBox(height: 8),
              Text(item.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قەرز و Ledger')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openGiveDebt,
        icon: const Icon(Icons.add_card_rounded),
        label: const Text('قەرزی نوێ'),
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            FilledButton.icon(onPressed: openLedger, icon: const Icon(Icons.history_edu_rounded), label: const Text('کردنەوەی Ledger')),
            const SizedBox(height: 16),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null) ...[
              const Text('Debt Accounts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (accounts.isEmpty) const ZhiroxPanel(child: Text('هیچ account ـێکی قەرز نییە.')),
              for (final account in accounts) itemCard(account),
              const SizedBox(height: 18),
              const Text('Debt Cases', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (cases.isEmpty) const ZhiroxPanel(child: Text('هیچ case ـێکی قەرز نییە.')),
              for (final debtCase in cases) itemCard(debtCase, onTap: () => openCase(debtCase)),
            ],
          ],
        ),
      ),
    );
  }
}
