import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../common/widgets/role_specific_avatar.dart';
import '../../common/widgets/shared_search_bar.dart';

class SupervisorHomeSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(int) onNavigate;

  const SupervisorHomeSection({
    super.key,
    required this.scaffoldKey,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildBanner(),
                const SizedBox(height: 15),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildMetricsSection(),
                const SizedBox(height: 30),
                _buildRecentMessagesSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 10, left: 15, right: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.sort, color: Color(0xFFB08924), size: 30),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_none,
                    color: Color(0xFFB08924), size: 28),
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: Color(0xFFB08924),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/home_banner.png',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 15,
            left: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No Preservatives & no colours',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const SharedSearchBar();
  }

  Widget _buildMetricsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildMetricCard(
              'Earnings', '₹ 40,000', Icons.account_balance_wallet),
          const SizedBox(width: 15),
          _buildMetricCard('Joinings', '420', Icons.people),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0E0B0), width: 1),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: const Color(0xFFB08924), size: 38),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFB08924),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Color(0xFFB08924),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMessagesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Messages',
              style: TextStyle(
                  color: Color(0xFF1A3358),
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildMessageTile('Swathi', '1h'),
          _buildMessageTile('Priya', '2h'),
          _buildMessageTile('John Doe', '3h'),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String name, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          RoleSpecificAvatar(label: name, role: 'Employee', size: 40),
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
