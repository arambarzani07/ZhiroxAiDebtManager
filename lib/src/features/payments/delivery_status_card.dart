import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';

class DeliveryStatusCard extends StatelessWidget {
  const DeliveryStatusCard({super.key, required this.item});

  final Map<String, dynamic> item;

  String value(String key, {String fallback = '-'}) {
    final raw = item[key];
    if (raw == null || raw.toString().trim().isEmpty) return fallback;
    return raw.toString();
  }

  IconData get icon {
    final channel = value('channel').toLowerCase();
    if (channel.contains('whatsapp')) return Icons.chat_rounded;
    if (channel.contains('sms')) return Icons.sms_rounded;
    if (channel.contains('email')) return Icons.email_rounded;
    if (channel.contains('print')) return Icons.print_rounded;
    return Icons.mark_email_read_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return ZhiroxPanel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Icon(icon)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value('channel'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Status: ${value('status')}', style: const TextStyle(color: Colors.white70)),
                Text('Recipient: ${value('recipient')}', style: const TextStyle(color: Colors.white70)),
                Text('Date: ${value('sent_at', fallback: value('created_at'))}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                if (value('note').trim() != '-') ...[
                  const SizedBox(height: 6),
                  Text(value('note'), style: const TextStyle(color: Colors.white60)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
