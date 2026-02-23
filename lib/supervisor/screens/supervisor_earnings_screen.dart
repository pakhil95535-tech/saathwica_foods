import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupervisorEarningsScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  const SupervisorEarningsScreen({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFB08924)),
          onPressed: onBackPressed ?? () => Get.back(),
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
            // Earnings Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEF),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFF0E0B0), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹ ',
                        style: TextStyle(
                          color: Color(0xFFB08924),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '40,000',
                        style: TextStyle(
                          color: Color(0xFFB08924),
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Recent transactions Title
            const Text(
              'Recent transactions',
              style: TextStyle(
                color: Color(0xFF1A3358),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Transactions List
            _buildTransactionTile('1,500.00', '1h'),
            _buildTransactionTile('1,000.00', '2h'),
            _buildTransactionTile('2,500.00', '3h'),
            _buildTransactionTile('1,500.00', '1h'),
            _buildTransactionTile('1,000.00', '2h'),
            _buildTransactionTile('2,500.00', '3h'),
            _buildTransactionTile('1,500.00', '2h'),
            _buildTransactionTile('1,000.00', '3h'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String amount, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_downward,
                color: Color(0xFFB08924), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Received',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3358),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$time ago',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '+ ₹$amount',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
