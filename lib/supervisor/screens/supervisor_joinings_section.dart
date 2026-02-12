import 'package:flutter/material.dart';
import '../../common/widgets/role_specific_avatar.dart';

class SupervisorJoiningsSection extends StatelessWidget {
  final VoidCallback onBackPressed;
  const SupervisorJoiningsSection({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFB08924)),
          onPressed: onBackPressed,
        ),
        title: const Text('Joinings',
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
            // Joinings Summary Card (Image 6 style)
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
                      Icon(Icons.people_outline,
                          size: 45, color: Color(0xFFB08924)),
                      SizedBox(height: 8),
                      Text(
                        'Total Joinings',
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
                        '420',
                        style: TextStyle(
                          color: Color(0xFFB08924),
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25, left: 4),
                        child: Text(
                          'joinings',
                          style: TextStyle(
                            color: Color(0xFFB08924),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Today Joinings Title
            const Text(
              'Today Joinings',
              style: TextStyle(
                color: Color(0xFF1A3358),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Joinings List
            _buildJoiningTile('John Doe', 'gh45354', '1h'),
            _buildJoiningTile('Alex Smith', 'gh45355', '2h'),
            _buildJoiningTile('Sarah Wilson', 'gh45356', '3h'),
            _buildJoiningTile('Michael Brown', 'gh45357', '4h'),
            _buildJoiningTile('Emma Davis', 'gh45358', '5h'),
            _buildJoiningTile('James Miller', 'gh45359', '6h'),
          ],
        ),
      ),
    );
  }

  Widget _buildJoiningTile(String name, String id, String time) {
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
          RoleSpecificAvatar(label: name, role: 'Employee', size: 45),
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
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Employee ID: $id',
                  style: const TextStyle(
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
