// lib/widgets/bottom_navigation_bar.dart

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../controllers/cart_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLarge,
          ),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profile Icon
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: AppStrings.profile,
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),

                // Home Icon
                _buildNavItem(
                  icon: Icons.home_outlined,
                  label: AppStrings.home,
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),

                // Cart Icon with Badge
                Obx(
                  () => GestureDetector(
                    onTap: () => onTap(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: AppSizes.iconLarge,
                              color: currentIndex == 2
                                  ? AppColors.white
                                  : AppColors.white.withOpacity(0.6),
                            ),
                            if (cartController.cartItemCount > 0)
                              badges.Badge(
                                badgeContent: Text(
                                  cartController.cartItemCount.toString(),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                badgeStyle: const badges.BadgeStyle(
                                  badgeColor: AppColors.white,
                                  padding: EdgeInsets.all(4),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.cart,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: currentIndex == 2
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: AppDurations.animationDurationShort,
            child: Icon(
              icon,
              size: AppSizes.iconLarge,
              color: isSelected
                  ? AppColors.white
                  : AppColors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.captionSmall.copyWith(
              color: isSelected
                  ? AppColors.white
                  : AppColors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
