import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupervisorJoiningsScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;
  const SupervisorJoiningsScreen({super.key, this.onBackPressed});

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
            // Joinings Summary Card
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
                    '420',
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
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '1h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '2h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '3h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '1h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '2h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '3h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '2h'),
            _buildJoiningItem('Employee', 'Supervisor ID: SP12345', '3h'),
          ],
        ),
      ),
    );
  }

  Widget _buildJoiningItem(String role, String id, String time) {
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
            child: const Icon(Icons.person_add,
                color: Color(0xFFB08924), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New $role Joined',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3358),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                id,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
