
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';
import '../widgets/super_admin_drawer.dart';

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.primary, size: 28),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
      drawer: const SuperAdminDrawer(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                Image.asset(
                  AppAssets.appLogo,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.newBrandName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 40),

                // Shortcut Buttons
                _buildDashboardButton(
                  context,
                  'Create Admin',
                  Icons.person_add,
                  () => Get.toNamed(AppRoutes.createAdmin),
                ),
                const SizedBox(height: 20),
                _buildDashboardButton(
                  context,
                  'Add Product',
                  Icons.add_shopping_cart,
                  () => Get.toNamed(AppRoutes.createProduct),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
