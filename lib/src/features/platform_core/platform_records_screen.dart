import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'platform_helpers.dart';

class PlatformRecordsScreen extends StatefulWidget {
  const PlatformRecordsScreen({super.key, required this.title, required this.loader});

  final String title;
  final Future<List<Map<String, dynamic>>> Function() loader;

  @override
  State<PlatformRecordsScreen> createState() => _PlatformRecordsScreenState();
}

class _PlatformRecordsScreenState extends State<PlatformRecordsScreen> {
  List<Map<String, dynamic>> records = [];
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
      final data = await widget.loader();
      setState(() => records = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Widget recordCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ZhiroxPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(platformTitle(item), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Chip(label: Text(platformStatus(item))),
            const SizedBox(height: 8),
            Text(platformDate(item), style: const TextStyle(color: Colors.white54, fontSize: 12)),
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
      appBar: AppBar(title: Text(widget.title)),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && records.isEmpty) const ZhiroxPanel(child: Text('هیچ تۆمارێک نییە.')),
            for (final item in records) recordCard(item),
          ],
        ),
      ),
    );
  }
}
