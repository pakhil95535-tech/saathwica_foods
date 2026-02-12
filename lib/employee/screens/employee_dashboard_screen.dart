import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';
import '../../common/widgets/shared_staff_drawer.dart';
import '../../common/widgets/role_specific_avatar.dart';
import '../../common/widgets/shared_search_bar.dart';
import 'employee_earnings_screen.dart';
import 'employee_jobs_screen.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  int _currentIndex = 1; // Default to Home
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = [
      EmployeeEarningsScreen(
          onBackPressed: () => setState(() => _currentIndex = 1)),
      _EmployeeHomeSection(scaffoldKey: _scaffoldKey),
      EmployeeJobsScreen(
          onBackPressed: () => setState(() => _currentIndex = 1)),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9F9F9),
      drawer: SharedStaffDrawer(
        currentIndex: _currentIndex,
        onNavigate: (index) => setState(() => _currentIndex = index),
      ),
      body: sections[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.account_balance_wallet, 0),
          _buildNavItem(Icons.home, 1, isHome: true),
          _buildNavItem(Icons.work, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isHome = false}) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Icon(
        icon,
        color: AppColors.white,
        size: isHome ? (isActive ? 50 : 40) : (isActive ? 38 : 30),
      ),
    );
  }
}

class _EmployeeHomeSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _EmployeeHomeSection({required this.scaffoldKey});

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
            left: 50, // Approx as seen in image
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
              'Earnings', '₹ 44,000', Icons.account_balance_wallet),
          const SizedBox(width: 15),
          _buildMetricCard('Joinings', '400', Icons.people),
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
          _buildMessageTile('Ciclano', '1h'),
          _buildMessageTile('Beltrano', '2h'),
          _buildMessageTile('Beltrano', '3h'),
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
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          RoleSpecificAvatar(label: name, role: 'Customer', size: 40),
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
