import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'cash_close_session_screen.dart';
import 'cash_discrepancy_screen.dart';
import 'cash_handover_screen.dart';
import 'cash_helpers.dart';
import 'cash_open_session_screen.dart';
import 'cash_service.dart';

class CashModuleScreen extends StatefulWidget {
  const CashModuleScreen({super.key, required this.cashService});

  final CashService cashService;

  @override
  State<CashModuleScreen> createState() => _CashModuleScreenState();
}

class _CashModuleScreenState extends State<CashModuleScreen> {
  Map<String, dynamic>? currentSession;
  List<Map<String, dynamic>> sessions = [];
  List<Map<String, dynamic>> handovers = [];
  List<Map<String, dynamic>> discrepancies = [];
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
    Map<String, dynamic>? loadedCurrent;
    try {
      loadedCurrent = await widget.cashService.getCurrentSession();
    } catch (_) {
      loadedCurrent = null;
    }
    try {
      final loadedSessions = await widget.cashService.listSessions();
      final loadedHandovers = await widget.cashService.listHandovers();
      final loadedDiscrepancies = await widget.cashService.listDiscrepancies();
      setState(() {
        currentSession = loadedCurrent;
        sessions = loadedSessions;
        handovers = loadedHandovers;
        discrepancies = loadedDiscrepancies;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> openAction(Widget screen) async {
    final changed = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => screen));
    if (changed == true) load();
  }

  Future<void> reconcile() async {
    try {
      await widget.cashService.reconcileCurrentSession({'note': 'manual reconcile from Flutter'});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reconciliation پاشەکەوت کرا')));
      }
      load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget recordCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZhiroxPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cashTitle(item), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${cashAmount(item)} ${cashCurrency(item)}'),
            const SizedBox(height: 6),
            Chip(label: Text(cashStatus(item))),
            const SizedBox(height: 6),
            Text(cashDate(item), style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            Text(item.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget currentSessionCard() {
    final session = currentSession;
    if (session == null) {
      return const ZhiroxPanel(child: Text('Cash session ـی کراوە نییە.'));
    }
    return ZhiroxPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cash Session ـی ئێستا', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('${cashAmount(session)} ${cashCurrency(session)}'),
          const SizedBox(height: 8),
          Chip(label: Text(cashStatus(session))),
          const SizedBox(height: 8),
          Text(session.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash Module')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            currentSessionCard(),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: () => openAction(CashOpenSessionScreen(cashService: widget.cashService)),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('دەستپێکردن'),
                ),
                OutlinedButton.icon(
                  onPressed: () => openAction(CashCloseSessionScreen(cashService: widget.cashService)),
                  icon: const Icon(Icons.stop_circle_rounded),
                  label: const Text('کۆتایی'),
                ),
                OutlinedButton.icon(
                  onPressed: () => openAction(CashHandoverScreen(cashService: widget.cashService)),
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text('Handover'),
                ),
                OutlinedButton.icon(
                  onPressed: () => openAction(CashDiscrepancyScreen(cashService: widget.cashService)),
                  icon: const Icon(Icons.warning_rounded),
                  label: const Text('Discrepancy'),
                ),
                OutlinedButton.icon(
                  onPressed: reconcile,
                  icon: const Icon(Icons.fact_check_rounded),
                  label: const Text('Reconcile'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null) ...[
              const Text('Sessions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (sessions.isEmpty) const ZhiroxPanel(child: Text('هیچ session ـێک نییە.')),
              for (final item in sessions) recordCard(item),
              const SizedBox(height: 18),
              const Text('Handovers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (handovers.isEmpty) const ZhiroxPanel(child: Text('هیچ handover ـێک نییە.')),
              for (final item in handovers) recordCard(item),
              const SizedBox(height: 18),
              const Text('Discrepancies', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (discrepancies.isEmpty) const ZhiroxPanel(child: Text('هیچ discrepancy ـێک نییە.')),
              for (final item in discrepancies) recordCard(item),
            ],
          ],
        ),
      ),
    );
  }
}
