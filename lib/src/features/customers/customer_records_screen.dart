import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';

class CustomerRecordsScreen extends StatefulWidget {
  const CustomerRecordsScreen({
    super.key,
    required this.title,
    required this.loader,
    this.onAdd,
  });

  final String title;
  final Future<List<Map<String, dynamic>>> Function() loader;
  final Future<bool?> Function()? onAdd;

  @override
  State<CustomerRecordsScreen> createState() => _CustomerRecordsScreenState();
}

class _CustomerRecordsScreenState extends State<CustomerRecordsScreen> {
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

  Future<void> add() async {
    if (widget.onAdd == null) return;
    final changed = await widget.onAdd!();
    if (changed == true) load();
  }

  String summary(Map<String, dynamic> record) {
    final parts = <String>[];
    for (final key in ['full_name', 'full_name_ku', 'phone', 'status', 'type', 'note', 'reason', 'created_at']) {
      final value = record[key];
      if (value != null && value.toString().trim().isNotEmpty) parts.add('$key: $value');
    }
    return parts.isEmpty ? record.toString() : parts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: widget.onAdd == null
          ? null
          : FloatingActionButton.extended(
              onPressed: add,
              icon: const Icon(Icons.add_rounded),
              label: const Text('زیادکردن'),
            ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (loading) const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (!loading && error == null && records.isEmpty) const ZhiroxPanel(child: Text('هیچ تۆمارێک نییە.')),
            for (final record in records)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ZhiroxPanel(child: Text(summary(record))),
              ),
          ],
        ),
      ),
    );
  }
}
