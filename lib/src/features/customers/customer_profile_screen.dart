import 'package:flutter/material.dart';

import '../dashboard/dashboard_widgets.dart';
import '../debt/customer_debt_timeline_screen.dart';
import '../debt/debt_service.dart';
import '../debt/give_debt_screen.dart';
import '../payments/customer_statement_screen.dart';
import '../payments/payment_service.dart';
import 'customer_action_form_screen.dart';
import 'customer_contact_health_screen.dart';
import 'customer_credit_limit_screen.dart';
import 'customer_duplicate_merge_screen.dart';
import 'customer_edit_screen.dart';
import 'customer_helpers.dart';
import 'customer_records_screen.dart';
import 'customer_service.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key, required this.customer, required this.customerService});

  final Map<String, dynamic> customer;
  final CustomerService customerService;

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  Map<String, dynamic>? profile;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  String get id => customerId(widget.customer);
  DebtService get debtService => DebtService(widget.customerService.apiClient);
  PaymentService get paymentService => PaymentService(widget.customerService.apiClient);

  Future<void> load() async {
    if (id.isEmpty) {
      setState(() {
        loading = false;
        error = 'ID ـی کڕیار نەدۆزرایەوە';
      });
      return;
    }
    try {
      final data = await widget.customerService.getProfile(id);
      setState(() => profile = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<bool?> openForm({
    required String title,
    required List<CustomerActionField> fields,
    required Future<void> Function(Map<String, String>) submit,
  }) {
    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerActionFormScreen(title: title, fields: fields, onSubmit: submit),
      ),
    );
  }

  void openRecords(String title, Future<List<Map<String, dynamic>>> Function() loader, Future<bool?> Function()? onAdd) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerRecordsScreen(title: title, loader: loader, onAdd: onAdd)),
    );
  }

  Future<void> openEdit() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CustomerEditScreen(customer: widget.customer, customerService: widget.customerService)),
    );
    if (changed == true) load();
  }

  void openScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> openGiveDebt() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => GiveDebtScreen(customer: widget.customer, debtService: debtService)),
    );
    if (changed == true) load();
  }

  @override
  Widget build(BuildContext context) {
    final name = customerDisplayName(widget.customer);
    final phone = customerPhone(widget.customer);
    final status = customerStatus(widget.customer);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ZhiroxPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(phone, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Chip(label: Text(status)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (error != null) ZhiroxPanel(child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
            if (profile != null)
              ZhiroxPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('پرۆفایلی تەواو', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(profile.toString()),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ZhiroxPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Debt & Ledger', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _ActionButton(
                    title: 'قەرز و Ledger',
                    icon: Icons.account_balance_wallet_rounded,
                    onTap: () => openScreen(CustomerDebtTimelineScreen(customer: widget.customer, debtService: debtService)),
                  ),
                  _ActionButton(title: 'دانانی قەرزی نوێ', icon: Icons.add_card_rounded, onTap: openGiveDebt),
                  _ActionButton(
                    title: 'Statement ـی کڕیار',
                    icon: Icons.description_rounded,
                    onTap: () => openScreen(CustomerStatementScreen(customer: widget.customer, paymentService: paymentService)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ZhiroxPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Customer Brain Advanced', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _ActionButton(title: 'دەستکاری کڕیار', icon: Icons.edit_rounded, onTap: openEdit),
                  _ActionButton(
                    title: 'Contact Health',
                    icon: Icons.health_and_safety_rounded,
                    onTap: () => openScreen(CustomerContactHealthScreen(customer: widget.customer, customerService: widget.customerService)),
                  ),
                  _ActionButton(
                    title: 'Credit Limit Review',
                    icon: Icons.price_check_rounded,
                    onTap: () => openScreen(CustomerCreditLimitScreen(customer: widget.customer, customerService: widget.customerService)),
                  ),
                  _ActionButton(
                    title: 'Duplicate Review',
                    icon: Icons.compare_arrows_rounded,
                    onTap: () => openScreen(CustomerDuplicateMergeScreen(customer: widget.customer, customerService: widget.customerService)),
                  ),
                  _ActionButton(
                    title: 'پەیوەندییەکان',
                    icon: Icons.call_rounded,
                    onTap: () => openRecords(
                      'پەیوەندییەکان',
                      () => widget.customerService.listContacts(id),
                      () => openForm(
                        title: 'زیادکردنی پەیوەندی',
                        fields: const [
                          CustomerActionField(keyName: 'phone', label: 'ژمارەی مۆبایل'),
                          CustomerActionField(keyName: 'note', label: 'تێبینی', maxLines: 3),
                        ],
                        submit: (values) => widget.customerService.createContact(id, values),
                      ),
                    ),
                  ),
                  _ActionButton(
                    title: 'دەستەبەر / Guarantor',
                    icon: Icons.verified_user_rounded,
                    onTap: () => openRecords(
                      'دەستەبەرەکان',
                      () => widget.customerService.listGuarantors(id),
                      () => openForm(
                        title: 'زیادکردنی دەستەبەر',
                        fields: const [
                          CustomerActionField(keyName: 'full_name', label: 'ناوی تەواو'),
                          CustomerActionField(keyName: 'phone', label: 'ژمارەی مۆبایل'),
                          CustomerActionField(keyName: 'relationship', label: 'پەیوەندی'),
                        ],
                        submit: (values) => widget.customerService.createGuarantor(id, values),
                      ),
                    ),
                  ),
                  _ActionButton(
                    title: 'بەڵگە و Evidence',
                    icon: Icons.attach_file_rounded,
                    onTap: () => openRecords(
                      'بەڵگەکان',
                      () => widget.customerService.listEvidence(id),
                      () => openForm(
                        title: 'زیادکردنی بەڵگە',
                        fields: const [
                          CustomerActionField(keyName: 'evidence_type', label: 'جۆری بەڵگە'),
                          CustomerActionField(keyName: 'note', label: 'تێبینی', maxLines: 3),
                        ],
                        submit: (values) => widget.customerService.createEvidence(id, values),
                      ),
                    ),
                  ),
                  _ActionButton(
                    title: 'مێژووی دۆخ',
                    icon: Icons.history_rounded,
                    onTap: () => openRecords(
                      'مێژووی دۆخ',
                      () => widget.customerService.listStatusHistory(id),
                      () => openForm(
                        title: 'گۆڕینی دۆخ',
                        fields: const [
                          CustomerActionField(keyName: 'new_status', label: 'دۆخی نوێ'),
                          CustomerActionField(keyName: 'reason', label: 'هۆکار', maxLines: 3),
                        ],
                        submit: (values) => widget.customerService.createStatus(id, values),
                      ),
                    ),
                  ),
                  _ActionButton(
                    title: 'Credit Lock',
                    icon: Icons.lock_rounded,
                    onTap: () => openRecords(
                      'Credit Locks',
                      () => widget.customerService.listCreditLocks(id),
                      () => openForm(
                        title: 'زیادکردنی Credit Lock',
                        fields: const [
                          CustomerActionField(keyName: 'reason', label: 'هۆکاری قوفڵ', maxLines: 3),
                          CustomerActionField(keyName: 'lock_type', label: 'جۆری قوفڵ'),
                        ],
                        submit: (values) => widget.customerService.createCreditLock(id, values),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(title)),
    );
  }
}
