// lib/screens/admin/admin_joinings_section.dart

import 'package:flutter/material.dart';
import '../../common/utils/constants.dart';
import '../../common/widgets/role_specific_avatar.dart';

class AdminJoiningsSection extends StatelessWidget {
  final VoidCallback onBackPressed;
  const AdminJoiningsSection({super.key, required this.onBackPressed});

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
                const SizedBox(height: 20),
                _buildTotalCard(),
                const SizedBox(height: 30),
                _buildRecentJoiningsSection(),
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
            icon: const Icon(Icons.arrow_back_ios,
                color: Color(0xFF8B6C3F), size: 20),
            onPressed: onBackPressed,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'My joinings',
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
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.groups, color: AppColors.primary, size: 50),
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Joinings',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '920',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentJoiningsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent joinings',
          style: TextStyle(
            color: Color(0xFF1A3358),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        _buildJoinTile('Supervisor', 'Admin ID: 5fttt45'),
        _buildJoinTile('Supervisor', 'Admin ID: fr5677'),
        _buildJoinTile('Employee', 'Supervisor ID: rf4575'),
        _buildJoinTile('Employee', 'Supervisor ID: rf4575'),
        _buildJoinTile('Customer', 'Employee ID: gh45354'),
        _buildJoinTile('Customer', 'Employee ID: gh45354'),
        _buildJoinTile('Customer', 'Employee ID: gh45354'),
        _buildJoinTile('Customer', 'Employee ID: gh45354'),
      ],
    );
  }

  Widget _buildJoinTile(String role, String id) {
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
          RoleSpecificAvatar(label: role, size: 45),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF1A3358),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Assunto: ...',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            id,
            style: const TextStyle(
              color: Color(0xFF1A3358),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
