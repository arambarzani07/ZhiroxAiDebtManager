import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';

class CustomerActionFormScreen extends StatefulWidget {
  const CustomerActionFormScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
  });

  final String title;
  final List<CustomerActionField> fields;
  final Future<void> Function(Map<String, String> values) onSubmit;

  @override
  State<CustomerActionFormScreen> createState() => _CustomerActionFormScreenState();
}

class CustomerActionField {
  const CustomerActionField({required this.keyName, required this.label, this.maxLines = 1});

  final String keyName;
  final String label;
  final int maxLines;
}

class _CustomerActionFormScreenState extends State<CustomerActionFormScreen> {
  final Map<String, TextEditingController> controllers = {};
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      controllers[field.keyName] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    final values = <String, String>{};
    controllers.forEach((key, controller) {
      final value = controller.text.trim();
      if (value.isNotEmpty) values[key] = value;
    });
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.onSubmit(values);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                for (final field in widget.fields) ...[
                  TextField(
                    controller: controllers[field.keyName],
                    maxLines: field.maxLines,
                    decoration: InputDecoration(labelText: field.label),
                  ),
                  const SizedBox(height: 14),
                ],
                if (error != null) Text(error!, style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: loading ? null : save,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_rounded),
                  label: const Text('پاشەکەوتکردن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
