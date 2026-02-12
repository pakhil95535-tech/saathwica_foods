import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../controllers/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.mediumGray, width: 1),
                ),
              ),
              child: Text(
                AppStrings.appName,
                style: AppTextStyles.headline3.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildExpandableMenuItem(
                    'Curries',
                    Icons.restaurant_menu,
                    [
                      'Chicken Fry',
                      'Chicken Curry',
                      'Mutton Curry',
                      'Gongura Chicken',
                      'Royyala Iguru'
                    ],
                  ),
                  _buildExpandableMenuItem(
                    'Masalas & Spices',
                    Icons.local_fire_department,
                    ['Gravy Powder', 'Pickle Powder', 'Biryani Masala'],
                  ),
                  _buildExpandableMenuItem(
                    'Snacks',
                    Icons.fastfood,
                    ['Chicken 65', 'Mirchi Bajji Mix'],
                  ),
                  _buildExpandableMenuItem(
                    'Pickles',
                    Icons.food_bank,
                    ['Gongura Pickle', 'Mango Pickle'],
                  ),
                  _buildMenuItem('Gravies', Icons.soup_kitchen, () {}),
                  const Divider(thickness: 1, color: AppColors.mediumGray),
                  _buildMenuItem('My Orders', Icons.inventory_2_outlined, () {
                    Get.toNamed('/orders');
                  }, iconColor: AppColors.teal),
                  _buildMenuItem('Contact Us', Icons.phone_outlined, () {},
                      iconColor: AppColors.teal),
                  _buildMenuItem('Privacy Policy', Icons.lock_outlined, () {},
                      iconColor: AppColors.teal),
                  _buildMenuItem(
                      'Terms and Conditions', Icons.description_outlined, () {},
                      iconColor: AppColors.teal),
                  _buildMenuItem('Credit Profile', Icons.credit_card, () {},
                      iconColor: AppColors.teal),
                  _buildMenuItem('FAQs', Icons.help_outline, () {},
                      iconColor: AppColors.teal),
                  _buildMenuItem('Logout', Icons.logout, () {
                    authController.logout();
                  }, textColor: AppColors.teal, iconColor: AppColors.teal),
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
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 24),
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

  Widget _buildExpandableMenuItem(
      String title, IconData icon, List<String> subItems) {
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 24),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 60),
      children: subItems
          .map((item) => ListTile(
                title: Text(
                  item,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
                onTap: () {},
                dense: true,
                contentPadding: EdgeInsets.zero,
              ))
          .toList(),
    );
  }
}
