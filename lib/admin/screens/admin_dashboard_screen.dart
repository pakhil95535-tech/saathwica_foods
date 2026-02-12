import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import 'admin_earnings_section.dart';
import 'admin_joinings_section.dart';
import '../../routes/app_routes.dart';
import '../../common/widgets/shared_staff_drawer.dart';
import '../../common/widgets/role_specific_avatar.dart';
import '../../common/widgets/shared_search_bar.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 1; // Default to Home
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> sections = [
      AdminEarningsSection(
          onBackPressed: () => setState(() => _currentIndex = 1)),
      _AdminHomeSection(scaffoldKey: _scaffoldKey),
      AdminJoiningsSection(
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
          _buildNavItem(Icons.people, 2),
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

class _AdminHomeSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const _AdminHomeSection({required this.scaffoldKey});

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
                const SizedBox(height: 20),
                _buildBanner(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 30),
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
      padding: const EdgeInsets.only(
        top: 40 + 10, // Approximate status bar height
        bottom: 15,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.white, size: 28),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            child: const Column(
              children: [
                Icon(Icons.notifications_none,
                    color: AppColors.white, size: 28),
                Text(
                  'Notifications',
                  style: TextStyle(color: AppColors.white, fontSize: 10),
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
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE21111),
                  borderRadius: BorderRadius.circular(5),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SharedSearchBar(
      onFilterTap: () {},
    );
  }

  Widget _buildMetricsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildMetricCard(
            'Earnings',
            '₹ 94,000',
            Icons.account_balance_wallet,
          ),
          const SizedBox(width: 20),
          _buildMetricCard(
            'Joinings',
            '920',
            Icons.groups_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    bool hasCurrency = value.contains('₹');
    String mainValue = hasCurrency ? value.split(' ')[1] : value;
    String? prefix = hasCurrency ? value.split(' ')[0] : null;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppColors.primary, size: 30),
                if (prefix != null)
                  Text(
                    prefix,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                mainValue,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
          const Text(
            'Recent Messages',
            style: TextStyle(
              color: Color(0xFF1A3358),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildMessageTile('Ciclano', '1h', 'Supervisor'),
          _buildMessageTile('Beltrano', '2h', 'Customer'),
          _buildMessageTile('Beltrano', '3h', 'Employee'),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String name, String time, String role) {
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
          RoleSpecificAvatar(label: name, role: role, size: 50),
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
                  'Assunto: ...',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF1A3358),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.assignment_ind_outlined, color: AppColors.primary),
        ],
      ),
    );
  }
}
