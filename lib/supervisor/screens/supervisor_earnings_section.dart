import 'package:flutter/material.dart';

class SupervisorEarningsSection extends StatelessWidget {
  final VoidCallback onBackPressed;
  const SupervisorEarningsSection({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFB08924)),
          onPressed: onBackPressed,
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
            // Earnings Summary Card (Image 5 style)
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
            _buildTransactionTile('1,000.00', '2h'),
            _buildTransactionTile('2,500.00', '3h'),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(String amount, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.add_card_outlined,
              color: Color(0xFFB08924), size: 30),
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
                const Text(
                  'Assunto: ...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF1A3358),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
