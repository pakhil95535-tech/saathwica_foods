import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/models/joinings.dart';
import '../../services/earnings_service.dart';
import '../../common/utils/constants.dart';
import 'package:intl/intl.dart';

class SupervisorJoiningsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const SupervisorJoiningsScreen({super.key, this.onBackPressed});

  @override
  State<SupervisorJoiningsScreen> createState() =>
      _SupervisorJoiningsScreenState();
}

class _SupervisorJoiningsScreenState extends State<SupervisorJoiningsScreen> {
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
    final role =
        _auth.currentUser.value?.userType.toLowerCase() ?? 'supervisor';
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: widget.onBackPressed ?? () => Get.back(),
        ),
        title: const Text('My Joinings',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _fetch,
            tooltip: 'Refresh',
          ),
        ],
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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

    return RefreshIndicator(
      onRefresh: _fetch,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Joinings Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.1), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.people, size: 45, color: AppColors.primary),
                      SizedBox(height: 8),
                      Text(
                        'Total Joinings',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$total',
                    style: const TextStyle(
                      color: AppColors.primary,
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
                  final joining = joinings[index];
                  return _buildJoiningItem(joining);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoiningItem(Joining joining) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray.withOpacity(0.3)),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.person, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  joining.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  joining.role.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (joining.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    joining.phone,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('yyyy').format(joining.joinedAt),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
