import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'ai_suggestions_screen.dart';
import 'approval_review_screen.dart';
import 'broadcast_message_screen.dart';
import 'intelligence_helpers.dart';
import 'intelligence_service.dart';

class IntelligenceDashboardScreen extends StatefulWidget {
  const IntelligenceDashboardScreen({super.key, required this.intelligenceService});

  final IntelligenceService intelligenceService;

  @override
  State<IntelligenceDashboardScreen> createState() => _IntelligenceDashboardScreenState();
}

class _IntelligenceDashboardScreenState extends State<IntelligenceDashboardScreen> {
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> suggestions = [];
  List<Map<String, dynamic>> approvals = [];
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
      final loadedMessages = await widget.intelligenceService.listBroadcasts();
      final loadedSuggestions = await widget.intelligenceService.listSuggestions();
      final loadedApprovals = await widget.intelligenceService.listPendingApprovals();
      setState(() {
        messages = loadedMessages;
        suggestions = loadedSuggestions;
        approvals = loadedApprovals;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> openMessage() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => BroadcastMessageScreen(intelligenceService: widget.intelligenceService)),
    );
    if (changed == true) load();
  }

  void openSuggestions() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AiSuggestionsScreen(intelligenceService: widget.intelligenceService)));
  }

  void openApprovals() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ApprovalReviewScreen(intelligenceService: widget.intelligenceService)));
  }

  Widget recordCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZhiroxPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(intelligenceTitle(item), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(intelligenceBody(item), style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Chip(label: Text(intelligenceStatus(item))),
            const SizedBox(height: 8),
            Text(item.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پەیام و AI')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(onPressed: openMessage, icon: const Icon(Icons.send_rounded), label: const Text('پەیامی گشتی')),
                OutlinedButton.icon(onPressed: openSuggestions, icon: const Icon(Icons.auto_awesome_rounded), label: const Text('پێشنیارەکانی AI')),
                OutlinedButton.icon(onPressed: openApprovals, icon: const Icon(Icons.rule_rounded), label: const Text('پێداچوونەوە')),
              ],
            ),
            const SizedBox(height: 18),
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null) ...[
              Row(
                children: [
                  Expanded(child: MetricCard(title: 'پەیام', value: messages.length.toString(), subtitle: 'کۆی پەیامەکان', icon: Icons.campaign_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: MetricCard(title: 'AI', value: suggestions.length.toString(), subtitle: 'پێشنیار', icon: Icons.auto_awesome_rounded)),
                ],
              ),
              const SizedBox(height: 10),
              MetricCard(title: 'پێداچوونەوە', value: approvals.length.toString(), subtitle: 'چاوەڕوان', icon: Icons.rule_rounded),
              const SizedBox(height: 18),
              const Text('پەیامە نوێکان', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              if (messages.isEmpty) const ZhiroxPanel(child: Text('هیچ پەیامێکی گشتی نییە.')),
              for (final item in messages) recordCard(item),
            ],
          ],
        ),
      ),
    );
  }
}
