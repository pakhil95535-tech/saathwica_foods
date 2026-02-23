import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../widgets/employee_drawer.dart';
import '../../common/utils/constants.dart';
import '../../common/widgets/dashboard_option_card.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.mediumGray,
      drawer: const EmployeeDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.primary, size: 28),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: AppColors.primary, size: 28),
                    onPressed: () => Get.toNamed(AppRoutes.notifications),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Branding Section
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.appLogo,
                      height: 80,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppStrings.newBrandName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Employee Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Dashboard Options
              DashboardOptionCard(
                title: 'My Earnings',
                icon: Icons.account_balance_wallet,
                onTap: () => Get.toNamed(AppRoutes.employeeEarnings),
              ),
              DashboardOptionCard(
                title: 'My Joinings',
                icon: Icons.group_add,
                onTap: () => Get.toNamed(AppRoutes.employeeJobs),
              ),
              DashboardOptionCard(
                title: 'Shop Now',
                icon: Icons.shopping_bag,
                onTap: () => Get.toNamed(AppRoutes.shopNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
