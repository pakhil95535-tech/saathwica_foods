import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeJobsScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  const EmployeeJobsScreen({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFB08924)),
          onPressed: onBackPressed ?? () => Get.back(),
        ),
        title: const Text('My joinings',
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
            // Joinings Summary Card (Image 6)
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
                      Icon(Icons.people, size: 45, color: Color(0xFFB08924)),
                      SizedBox(height: 8),
                      Text(
                        'Joinings',
                        style: TextStyle(
                          color: Color(0xFFB08924),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '400',
                    style: TextStyle(
                      color: Color(0xFFB08924),
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Recent joinings Title
            const Text(
              'Recent joinings',
              style: TextStyle(
                color: Color(0xFF1A3358),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Joinings List
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '1h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '2h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '3h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '1h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '2h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '3h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '2h'),
            _buildJoiningItem('Customer', 'Employee ID: gh45354', '3h'),
          ],
        ),
      ),
    );
  }

  Widget _buildJoiningItem(String name, String id, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              'assets/images/customerlogo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1A3358),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  id,
                  style: const TextStyle(
                    color: Color(0xFF1A3358),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                const Text(
                  'Assunto: ...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF1A3358),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '                                ', // Matching layout spacing if needed
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
