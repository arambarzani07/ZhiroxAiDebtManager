import 'package:flutter/material.dart';

import '../../core/config/api_config.dart';
import '../auth/auth_service.dart';
import 'dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.authService, required this.onLogout});

  final AuthService authService;
  final Future<void> Function() onLogout;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? profile;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await widget.authService.me();
      setState(() => profile = data);
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zhirox AI Debt'),
        leading: IconButton(icon: const Icon(Icons.logout), onPressed: widget.onLogout),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadProfile,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('داشبۆردی سەرەکی', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text('پەیوەست بە: ${ApiConfig.productionApiBaseUrl}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 18),
              if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
              if (profile != null) ZhiroxPanel(child: Text('Login profile loaded ✅\n${profile.toString()}')),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 700;
                  final cards = [
                    const MetricCard(title: 'کڕیاران', value: 'Live API', subtitle: 'Customer Brain بە API پەیوەست دەکرێت', icon: Icons.people_alt_rounded),
                    const MetricCard(title: 'قەرز', value: 'Ledger', subtitle: 'دەفتەری حساب source of truth ـە', icon: Icons.account_balance_wallet_rounded),
                    const MetricCard(title: 'پارەی نەقد', value: 'Cash', subtitle: 'Cash session و handover ئامادەیە', icon: Icons.payments_rounded),
                    const MetricCard(title: 'AI', value: 'Guarded', subtitle: 'AI تەنها پێشنیار دەدات، جێبەجێ ناکات', icon: Icons.auto_awesome_rounded),
                  ];
                  if (narrow) {
                    return Column(children: cards.map((card) => Padding(padding: const EdgeInsets.only(bottom: 12), child: card)).toList());
                  }
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    children: cards,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
