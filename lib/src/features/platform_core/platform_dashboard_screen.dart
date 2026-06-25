import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'platform_helpers.dart';
import 'platform_records_screen.dart';
import 'platform_service.dart';

class PlatformDashboardScreen extends StatefulWidget {
  const PlatformDashboardScreen({super.key, required this.platformService, required this.onLogout});

  final PlatformService platformService;
  final Future<void> Function() onLogout;

  @override
  State<PlatformDashboardScreen> createState() => _PlatformDashboardScreenState();
}

class _PlatformDashboardScreenState extends State<PlatformDashboardScreen> {
  Map<String, dynamic>? health;
  List<Map<String, dynamic>> markets = [];
  List<Map<String, dynamic>> plans = [];
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
      final loadedHealth = await widget.platformService.getHealth();
      final loadedMarkets = await widget.platformService.listMarkets();
      final loadedPlans = await widget.platformService.listPlans();
      setState(() {
        health = loadedHealth;
        markets = loadedMarkets;
        plans = loadedPlans;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void openMarkets() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlatformRecordsScreen(title: 'Markets', loader: widget.platformService.listMarkets)));
  }

  void openPlans() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlatformRecordsScreen(title: 'Plans', loader: widget.platformService.listPlans)));
  }

  Widget healthPanel() {
    final data = health;
    if (data == null) return const ZhiroxPanel(child: Text('Platform health: -'));
    return ZhiroxPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Platform Health', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text('Status: ${platformStatus(data)}'),
          Text('Markets: ${platformMetric(data, ['markets_count', 'market_count'])}'),
          Text('Plans: ${platformMetric(data, ['active_plans', 'active_licenses'])}'),
          const Divider(height: 28),
          Text(data.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Panel'),
        leading: IconButton(icon: const Icon(Icons.logout), onPressed: widget.onLogout),
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null) ...[
              healthPanel(),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: MetricCard(title: 'Markets', value: markets.length.toString(), subtitle: 'markets', icon: Icons.store_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: MetricCard(title: 'Plans', value: plans.length.toString(), subtitle: 'plans', icon: Icons.verified_rounded)),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: openMarkets, icon: const Icon(Icons.store_rounded), label: const Text('Markets')),
              const SizedBox(height: 10),
              OutlinedButton.icon(onPressed: openPlans, icon: const Icon(Icons.verified_rounded), label: const Text('Plans')),
            ],
          ],
        ),
      ),
    );
  }
}
