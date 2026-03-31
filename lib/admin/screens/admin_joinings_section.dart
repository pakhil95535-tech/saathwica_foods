// lib/screens/admin/admin_joinings_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/models/joinings.dart';
import '../../services/earnings_service.dart';
import '../../common/utils/constants.dart';
import 'package:intl/intl.dart';

class AdminJoiningsSection extends StatefulWidget {
  final VoidCallback onBackPressed;
  const AdminJoiningsSection({super.key, required this.onBackPressed});

  @override
  State<AdminJoiningsSection> createState() => _AdminJoiningsSectionState();
}

class _AdminJoiningsSectionState extends State<AdminJoiningsSection> {
  final _auth = Get.find<AuthController>();
  JoiningsSummary? _summary;
  bool _loading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final idStr = _auth.currentUser.value?.id ?? '';
    final role = _auth.currentUser.value?.userType.toLowerCase() ?? 'admin';
    final referralCode = _auth.currentUser.value?.referralId ?? ''; // Using referral ID as code

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
      // Pass referral code to service for strict filtering
      final s = await EarningsService.fetchJoinings(
        userId: id,
        role: role,
        referralCode: referralCode,
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetch,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    final total = _summary?.total ?? 0;
    final joinings = _summary?.joinings ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetch,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildTotalCard(total),
                  const SizedBox(height: 30),
                  const Text(
                    'Recent joinings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (joinings.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No joinings yet'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: joinings.length,
                      itemBuilder: (context, index) {
                        return _buildJoinTile(joinings[index]);
                      },
                    ),
                  const SizedBox(height: 20),
                ],
              ),
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
                color: AppColors.primary, size: 20),
            onPressed: widget.onBackPressed,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'My Joinings',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary, size: 22),
            onPressed: _fetch,
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.groups, color: AppColors.primary, size: 50),
            ],
          ),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Total Joinings',
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
              '$total',
              style: const TextStyle(
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

  Widget _buildJoinTile(Joining joining) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.person, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  joining.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  joining.role.toUpperCase(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (joining.phone.isNotEmpty)
                  Text(
                    joining.phone,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('MMM d').format(joining.joinedAt),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                DateFormat('yyyy').format(joining.joinedAt),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
