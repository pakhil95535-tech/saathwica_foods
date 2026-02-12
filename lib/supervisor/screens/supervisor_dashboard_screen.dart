import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/auth_controller.dart';
import 'supervisor_home_section.dart';
import 'supervisor_earnings_section.dart';
import 'supervisor_joinings_section.dart';
import '../../common/widgets/shared_staff_drawer.dart';

class SupervisorDashboardScreen extends StatefulWidget {
  const SupervisorDashboardScreen({super.key});

  @override
  State<SupervisorDashboardScreen> createState() =>
      _SupervisorDashboardScreenState();
}

class _SupervisorDashboardScreenState extends State<SupervisorDashboardScreen> {
  int _currentIndex = 1; // Default to Home
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthController authController = Get.find<AuthController>();

  late List<Widget> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [
      SupervisorEarningsSection(
          onBackPressed: () => setState(() => _currentIndex = 1)),
      SupervisorHomeSection(
        scaffoldKey: _scaffoldKey,
        onNavigate: (index) => setState(() => _currentIndex = index),
      ),
      SupervisorJoiningsSection(
          onBackPressed: () => setState(() => _currentIndex = 1)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      drawer: SharedStaffDrawer(
        currentIndex: _currentIndex,
        onNavigate: (index) => setState(() => _currentIndex = index),
      ),
      body: _sections[_currentIndex],
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.account_balance_wallet_outlined,
              Icons.account_balance_wallet),
          _buildNavItem(1, Icons.home_outlined, Icons.home),
          _buildNavItem(2, Icons.groups_outlined, Icons.groups),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(
          isSelected ? filledIcon : outlineIcon,
          color: AppColors.white,
          size: isSelected ? 32 : 28,
        ),
      ),
    );
  }
}
