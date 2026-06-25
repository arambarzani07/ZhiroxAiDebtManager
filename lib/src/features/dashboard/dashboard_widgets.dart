import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ZhiroxBackground extends StatelessWidget {
  const ZhiroxBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF07111F), Color(0xFF050B16), Color(0xFF030711)],
        ),
      ),
      child: child,
    );
  }
}

class ZhiroxPanel extends StatelessWidget {
  const ZhiroxPanel({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x1AFFFFFF)),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 28, offset: Offset(0, 14))],
      ),
      child: child,
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.title, required this.value, required this.subtitle, required this.icon});

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ZhiroxPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(colors: [Color(0xFFE7C15F), Color(0xFFFFE2A0)]),
            ),
            child: Icon(icon, color: const Color(0xFF111827), size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: AppTheme.muted, fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppTheme.muted, fontSize: 12, height: 1.35)),
        ],
      ),
    );
  }
}

class ModernActionButton extends StatelessWidget {
  const ModernActionButton({super.key, required this.title, required this.subtitle, required this.icon, required this.onTap});

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(colors: [Color(0xFFE7C15F), Color(0xFFF3D88A)]),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: const Color(0x22111827), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: const Color(0xFF111827)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: Color(0xAA111827), fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 18),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}
