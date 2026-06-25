import 'package:flutter/material.dart';

import '../../core/config/api_config.dart';
import '../auth/auth_service.dart';
import '../cash/cash_module_screen.dart';
import '../cash/cash_service.dart';
import '../customers/customer_list_screen.dart';
import '../customers/customer_service.dart';
import '../intelligence/intelligence_dashboard_screen.dart';
import '../intelligence/intelligence_service.dart';
import '../reports/report_service.dart';
import '../reports/reports_dashboard_screen.dart';
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

  void openCustomers() => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerListScreen(customerService: CustomerService(widget.authService.apiClient))));
  void openCash() => Navigator.push(context, MaterialPageRoute(builder: (_) => CashModuleScreen(cashService: CashService(widget.authService.apiClient))));
  void openReports() => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsDashboardScreen(reportService: ReportService(widget.authService.apiClient))));
  void openSmartCenter() => Navigator.push(context, MaterialPageRoute(builder: (_) => IntelligenceDashboardScreen(intelligenceService: IntelligenceService(widget.authService.apiClient))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Zhirox AI Debt'),
        actions: [IconButton(icon: const Icon(Icons.logout_rounded), onPressed: widget.onLogout)],
      ),
      body: ZhiroxBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: loadProfile,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              children: [
                ZhiroxPanel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(colors: [Color(0xFFE7C15F), Color(0xFFFFE2A0)]),
                            ),
                            child: const Icon(Icons.shield_rounded, color: Color(0xFF111827), size: 30),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('داشبۆردی زانیار', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.6)),
                                SizedBox(height: 4),
                                Text('بەڕێوەبردنی قەرز، کاش، ڕاپۆرت و AI', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: const Color(0xFF0B1324), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0x1AFFFFFF))),
                        child: Row(
                          children: [
                            const Icon(Icons.cloud_done_rounded, color: Color(0xFFE7C15F), size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ApiConfig.productionApiBaseUrl, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12), textDirection: TextDirection.ltr)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
                if (profile != null)
                  const ZhiroxPanel(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Row(
                      children: [
                        Icon(Icons.verified_rounded, color: Color(0xFF22C55E)),
                        SizedBox(width: 10),
                        Expanded(child: Text('چوونەژوورەوە سەرکەوتووە و پەیوەندی API کار دەکات', style: TextStyle(fontWeight: FontWeight.w700))),
                      ],
                    ),
                  ),
                const SizedBox(height: 18),
                const SectionTitle(title: 'بەشە سەرەکییەکان', subtitle: 'هەموو بەشەکان بە API ـی ڕاستەقینە پەیوەستن'),
                ModernActionButton(title: 'کڕیاران', subtitle: 'لیست، زیادکردن، پرۆفایل و contact health', icon: Icons.people_alt_rounded, onTap: openCustomers),
                const SizedBox(height: 12),
                ModernActionButton(title: 'کاش و سندووق', subtitle: 'Session، handover، discrepancy و reconciliation', icon: Icons.payments_rounded, onTap: openCash),
                const SizedBox(height: 12),
                ModernActionButton(title: 'ڕاپۆرتەکان', subtitle: 'قەرز، پارەدان، کاش و چاودێری کارمەند', icon: Icons.query_stats_rounded, onTap: openReports),
                const SizedBox(height: 12),
                ModernActionButton(title: 'Smart Center', subtitle: 'پەیام، پێشنیاری AI و approval review', icon: Icons.auto_awesome_rounded, onTap: openSmartCenter),
                const SizedBox(height: 22),
                const SectionTitle(title: 'کورتەی سیستەم', subtitle: 'نمایشی خێرای بەشە گرنگەکان'),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final twoColumns = constraints.maxWidth >= 560;
                    final cards = [
                      const MetricCard(title: 'کڕیاران', value: 'Customer', subtitle: 'پرۆفایل و قەرز', icon: Icons.people_alt_rounded),
                      const MetricCard(title: 'Ledger', value: 'Source', subtitle: 'دەفتەری حسابی ڕاستەقینە', icon: Icons.account_balance_wallet_rounded),
                      const MetricCard(title: 'Cash', value: 'Control', subtitle: 'سندووق و جیاوازی', icon: Icons.payments_rounded),
                      const MetricCard(title: 'AI', value: 'Guarded', subtitle: 'پێشنیار بە پێداچوونەوە', icon: Icons.auto_awesome_rounded),
                    ];
                    if (!twoColumns) {
                      return Column(children: cards.map((card) => Padding(padding: const EdgeInsets.only(bottom: 12), child: card)).toList());
                    }
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: cards,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
