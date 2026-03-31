// lib/screens/admin/admin_earnings_section.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/models/earnings.dart';
import '../../services/earnings_service.dart';

class AdminEarningsSection extends StatefulWidget {
  final VoidCallback onBackPressed;
  const AdminEarningsSection({super.key, required this.onBackPressed});

  @override
  State<AdminEarningsSection> createState() => _AdminEarningsSectionState();
}

class _AdminEarningsSectionState extends State<AdminEarningsSection> {
  final _auth = Get.find<AuthController>();
  EarningsSummary? _summary;
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetch() async {
    final idStr = _auth.currentUser.value?.id ?? '';
    final role = _auth.currentUser.value?.userType.toLowerCase() ?? 'admin';
    final id = int.tryParse(idStr);
    if (id == null) {
      setState(() {
        _error = 'Invalid user';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final s = await EarningsService.fetchEarnings(
        userId: id,
        role: role,
      );
      setState(() => _summary = s);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                if (_loading)
                  const LinearProgressIndicator(minHeight: 2)
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _fetch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Refresh',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(_error, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                _buildTotalCard(),
                const SizedBox(height: 30),
                _buildRecentTransactionsSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 10,
        left: 10,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF8B6C3F)),
            onPressed: widget.onBackPressed,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'My earnings',
                style: TextStyle(
                  color: Color(0xFF1A3358),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.account_balance_wallet,
                  color: AppColors.primary, size: 45),
            ],
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Earnings',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹ ${(_summary?.total ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pending: ₹ ${(_summary?.pending ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Completed: ₹ ${(_summary?.completed ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection() {
    final txns = _summary?.transactions ?? const <EarningTransaction>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Supervisor Revenue',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ..._buildBreakdownTiles(),
        const SizedBox(height: 16),
        const Text(
          'Recent transactions',
          style: TextStyle(
            color: Color(0xFF1A3358),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        if (txns.isEmpty)
          const Text(
            'No transactions found',
            style: TextStyle(color: Colors.grey),
          )
        else
          ...txns.map((t) => _buildTransactionTile(
                t.amount.toStringAsFixed(2),
                t.createdAt,
                t.orderStatus.isEmpty ? 'Completed' : t.orderStatus,
                t.downlineName.isNotEmpty ? t.downlineName : 'Supervisor',
              )),
      ],
    );
  }

  Widget _buildTransactionTile(
      String amount, DateTime when, String status, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.add_card_outlined,
              color: AppColors.primary, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹ $amount',
                  style: const TextStyle(
                    color: Color(0xFF1A3358),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  desc.isNotEmpty ? desc : status,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Color(0xFF1A3358),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBreakdownTiles() {
    final Map<String, double> map = {};
    for (final t in _summary?.transactions ?? const <EarningTransaction>[]) {
      final key = t.downlineName.isNotEmpty ? t.downlineName : 'Supervisor';
      map[key] = (map[key] ?? 0) + t.amount;
    }
    return map.entries
        .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: const TextStyle(color: Colors.black87)),
                Text('₹ ${e.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ))
        .toList();
  }
}
