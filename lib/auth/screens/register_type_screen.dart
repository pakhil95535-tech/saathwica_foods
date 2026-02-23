import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';

class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({super.key});

  Widget _buildUserTypeCard({
    required String title,
    required String imagePath,
    required String route,
    double height = 180,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80, // Slightly smaller to fit better in grid
              width: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.person,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Changed to white
      appBar: AppBar(
        backgroundColor: AppColors.white, // Changed to white
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary), // Changed to primary
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Register',
          style: AppTextStyles.headline4.copyWith(color: AppColors.primary), // Changed to primary
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: AnimationLimiter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: widget,
                    ),
                  ),
                ),
                children: [
                  const SizedBox(height: 10),

                  // Row for Supervisor and Employee
                  Row(
                    children: [
                      Expanded(
                        child: _buildUserTypeCard(
                          title: 'Supervisor',
                          imagePath: AppAssets.supervisorLogo,
                          route: AppRoutes.registerSupervisor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildUserTypeCard(
                          title: 'Employee',
                          imagePath: AppAssets.employeeLogo,
                          route: AppRoutes.registerEmployee,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Customer Card (Full Width)
                  _buildUserTypeCard(
                    title: 'Customer',
                    imagePath: AppAssets.customerLogo,
                    route: AppRoutes.registerCustomer,
                  ),

                  const SizedBox(height: 40), // Spacer

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => Get.offNamed(AppRoutes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary, // Ensure contrast
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
