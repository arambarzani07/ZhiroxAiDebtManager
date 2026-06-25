import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'intelligence_helpers.dart';
import 'intelligence_service.dart';

class AiSuggestionsScreen extends StatefulWidget {
  const AiSuggestionsScreen({super.key, required this.intelligenceService});

  final IntelligenceService intelligenceService;

  @override
  State<AiSuggestionsScreen> createState() => _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends State<AiSuggestionsScreen> {
  List<Map<String, dynamic>> suggestions = [];
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
      final data = await widget.intelligenceService.listSuggestions();
      setState(() => suggestions = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget suggestionCard(Map<String, dynamic> item) {
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
      appBar: AppBar(title: const Text('AI Suggestions')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && suggestions.isEmpty) const ZhiroxPanel(child: Text('هیچ پێشنیارێکی AI نییە.')),
            for (final item in suggestions) suggestionCard(item),
          ],
        ),
      ),
    );
  }
}
