import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'intelligence_helpers.dart';
import 'intelligence_service.dart';

class ApprovalReviewScreen extends StatefulWidget {
  const ApprovalReviewScreen({super.key, required this.intelligenceService});

  final IntelligenceService intelligenceService;

  @override
  State<ApprovalReviewScreen> createState() => _ApprovalReviewScreenState();
}

class _ApprovalReviewScreenState extends State<ApprovalReviewScreen> {
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
      final data = await widget.intelligenceService.listPendingApprovals();
      setState(() => approvals = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> decide(Map<String, dynamic> item, bool approved) async {
    final id = intelligenceId(item);
    if (id.isEmpty) return;
    try {
      if (approved) {
        await widget.intelligenceService.approve(id, {'note': 'approved from Flutter'});
      } else {
        await widget.intelligenceService.reject(id, {'note': 'rejected from Flutter'});
      }
      load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget approvalCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZhiroxPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(intelligenceTitle(item), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(intelligenceBody(item), style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Chip(label: Text(intelligenceStatus(item))),
            const SizedBox(height: 8),
            Text(intelligenceDate(item), style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: FilledButton.icon(onPressed: () => decide(item, true), icon: const Icon(Icons.check_rounded), label: const Text('قبووڵکردن'))),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton.icon(onPressed: () => decide(item, false), icon: const Icon(Icons.close_rounded), label: const Text('ڕەتکردنەوە'))),
              ],
            ),
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
      appBar: AppBar(title: const Text('Approval Review')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && approvals.isEmpty) const ZhiroxPanel(child: Text('هیچ داواکارییەکی چاوەڕوان نییە.')),
            for (final item in approvals) approvalCard(item),
          ],
        ),
      ),
    );
  }
}
