import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/models/earnings.dart';
import '../../services/earnings_service.dart';

class SupervisorEarningsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const SupervisorEarningsScreen({super.key, this.onBackPressed});

  @override
  State<SupervisorEarningsScreen> createState() =>
      _SupervisorEarningsScreenState();
}

class _SupervisorEarningsScreenState extends State<SupervisorEarningsScreen> {
  final _auth = Get.find<AuthController>();
  EarningsSummary? _summary;
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final idStr = _auth.currentUser.value?.id ?? '';
    final role =
        _auth.currentUser.value?.userType.toLowerCase() ?? 'supervisor';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFB08924)),
          onPressed: widget.onBackPressed ?? () => Get.back(),
        ),
        title: const Text('My earnings',
            style: TextStyle(
              color: Color(0xFF1A3358),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_loading) const LinearProgressIndicator(minHeight: 2),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(_error, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 12),
            // Earnings Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEF),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFF0E0B0), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.account_balance_wallet,
                          size: 45, color: Color(0xFFB08924)),
                      SizedBox(height: 8),
                      Text(
                        'Earnings',
                        style: TextStyle(
                          color: Color(0xFFB08924),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹ ${(_summary?.total ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pending: ₹ ${(_summary?.pending ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Completed: ₹ ${(_summary?.completed ?? 0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Recent transactions Title
            const Text(
              'Recent transactions',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Breakdown: Supervisor → Employee revenue
            const Text(
              'Employee Revenue',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ..._buildBreakdownTiles(),
            const SizedBox(height: 16),

            // Transactions List
            if ((_summary?.transactions.isEmpty ?? true))
              const Text(
                'No transactions found',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._summary!.transactions
                  .map((t) => _buildTransactionTile(
                      t.amount.toStringAsFixed(2),
                      t.createdAt,
                      t.orderStatus.isEmpty ? 'Completed' : t.orderStatus,
                      t.downlineName.isNotEmpty ? t.downlineName : 'Employee',
                      ))
                  ,
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(
      String amount, DateTime when, String status, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.add_card, color: Color(0xFFB08924), size: 32),
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
                    fontSize: 15,
                  ),
                ),
                Text(
                  desc.isNotEmpty ? desc : status,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Color(0xFF1A3358),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBreakdownTiles() {
    final Map<String, double> map = {};
    for (final t in _summary?.transactions ?? const <EarningTransaction>[]) {
      final key = t.downlineName.isNotEmpty ? t.downlineName : 'Employee';
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
