import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    final role =
        (authController.currentUser.value?.userType.toLowerCase() ?? 'customer')
            .replaceAll(' ', '')
            .replaceAll('_', '');

    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.mediumGray, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAssets.appLogo,
                    height: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.newBrandName,
                    style: AppTextStyles.headline3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.toUpperCase(),
                    style: AppTextStyles.subtitle1.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (role == 'superadmin') ...[
                    _buildMenuItem('My Profile', Icons.person_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.superAdminProfile);
                    }),
                  ] else if (role == 'admin') ...[
                    _buildMenuItem('My Profile', Icons.person_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.customerProfile);
                    }),
                    _buildMenuItem(
                        'My Earnings', Icons.account_balance_wallet_outlined,
                        () {
                      Get.back();
                      Get.toNamed(AppRoutes.adminEarnings);
                    }),
                    _buildMenuItem('My Joinings', Icons.people_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.adminJoinings);
                    }),
                  ] else if (role == 'employee') ...[
                    _buildMenuItem('My Profile', Icons.person_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.customerProfile);
                    }),
                    _buildMenuItem(
                        'My Earnings', Icons.account_balance_wallet_outlined,
                        () {
                      Get.back();
                      Get.toNamed(AppRoutes.employeeEarnings);
                    }),
                    _buildMenuItem('My Joinings', Icons.people_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.employeeJobs);
                    }),
                  ] else if (role == 'supervisor') ...[
                    _buildMenuItem('My Profile', Icons.person_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.supervisorProfile);
                    }),
                    _buildMenuItem(
                        'My Earnings', Icons.account_balance_wallet_outlined,
                        () {
                      Get.back();
                      Get.toNamed(AppRoutes.supervisorEarnings);
                    }),
                    _buildMenuItem('My Joinings', Icons.people_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.supervisorJoinings);
                    }),
                  ] else ...[
                    // Customer (and others default to this)
                    _buildMenuItem('My Profile', Icons.person_outline, () {
                      Get.back();
                      Get.toNamed(AppRoutes.customerProfile);
                    }),
                  ],
                  
                  // Common items for everyone
                  _buildMenuItem('My Orders', Icons.inventory_2_outlined, () {
                    Get.back();
                    Get.toNamed('/orders');
                  }),
                  _buildMenuItem('My Wishlist', Icons.favorite_border, () {
                    Get.back();
                    Get.toNamed(AppRoutes.wishlist);
                  }),
                  _buildMenuItem('Logout', Icons.logout, () {
                    authController.logout();
                  }),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Version: 11.1.150',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap,
      {Color? textColor, Color? iconColor}) {
    return ListTile(
      leading:
          Icon(icon, color: iconColor ?? const Color(0xFF146B2C), size: 24),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: textColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    );
  }
}
