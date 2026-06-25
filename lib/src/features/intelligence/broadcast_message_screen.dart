import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import 'intelligence_service.dart';

class BroadcastMessageScreen extends StatefulWidget {
  const BroadcastMessageScreen({super.key, required this.intelligenceService});

  final IntelligenceService intelligenceService;

  @override
  State<BroadcastMessageScreen> createState() => _BroadcastMessageScreenState();
}

class _BroadcastMessageScreenState extends State<BroadcastMessageScreen> {
  final title = TextEditingController();
  final body = TextEditingController();
  final channel = TextEditingController(text: 'whatsapp');
  final targetGroup = TextEditingController(text: 'all_customers');
  bool loading = false;
  String? error;

  @override
  void dispose() {
    title.dispose();
    body.dispose();
    channel.dispose();
    targetGroup.dispose();
    super.dispose();
  }

  Future<void> send() async {
    if (title.text.trim().isEmpty || body.text.trim().isEmpty) {
      setState(() => error = 'ناونیشان و ناوەڕۆک پێویستن');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.intelligenceService.createBroadcast({
        'title': title.text.trim(),
        'body': body.text.trim(),
        'channel': channel.text.trim().isEmpty ? 'whatsapp' : channel.text.trim(),
        'target_group': targetGroup.text.trim().isEmpty ? 'all_customers' : targetGroup.text.trim(),
      });
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
      appBar: AppBar(title: const Text('ناردنی پەیامی گشتی')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ZhiroxPanel(
            child: Column(
              children: [
                TextField(controller: title, decoration: const InputDecoration(labelText: 'ناونیشان')),
                const SizedBox(height: 14),
                TextField(controller: body, maxLines: 5, decoration: const InputDecoration(labelText: 'ناوەڕۆکی پەیام')),
                const SizedBox(height: 14),
                TextField(controller: channel, decoration: const InputDecoration(labelText: 'Channel')),
                const SizedBox(height: 14),
                TextField(controller: targetGroup, decoration: const InputDecoration(labelText: 'Target Group')),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  Text(error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: loading ? null : send,
                  icon: loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded),
                  label: const Text('ناردن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
