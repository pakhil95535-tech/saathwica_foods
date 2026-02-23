import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class SharedStaffDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const SharedStaffDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // No logo, only app name as per request
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text('Home'),
              selected: currentIndex == 1,
              onTap: () {
                onNavigate(1);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet,
                  color: AppColors.primary),
              title: const Text('My Earnings'),
              selected: currentIndex == 0,
              onTap: () {
                onNavigate(0);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: AppColors.primary),
              title: const Text('Joinings'),
              selected: currentIndex == 2,
              onTap: () {
                onNavigate(2);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('My Profile'),
              onTap: () {
                Get.back();
                final role =
                    authController.currentUser.value?.userType.toLowerCase() ??
                        '';
                if (role == 'employee') {
                  Get.toNamed(AppRoutes.employeeProfile);
                } else if (role == 'supervisor') {
                  Get.toNamed(AppRoutes.supervisorProfile);
                }
                // Add admin case if needed
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF1A3358),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              onTap: () => authController.logout(),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Version: 11.1.150',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
