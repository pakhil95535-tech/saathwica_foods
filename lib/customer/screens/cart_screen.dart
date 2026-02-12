import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/cart_controller.dart';
import '../../common/models/models.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Cart',
          style: AppTextStyles.headline3.copyWith(color: AppColors.primaryDark),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (cartController.cart.value == null ||
            cartController.cart.value!.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined,
                    size: 80, color: AppColors.lightGray),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: AppTextStyles.headline4
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Start Shopping',
                      style: TextStyle(color: AppColors.white)),
                ),
              ],
            ),
          );
        }

        return AnimationLimiter(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: cartController.cart.value!.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final item = cartController.cart.value!.items[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildCartItem(item, cartController),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  _buildOrderSummary(cartController),
                ],
              ).first,
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCartItem(CartItem item, CartController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.mediumGray,
            image: item.product.image.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(item.product.image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: item.product.image.isEmpty
              ? const Icon(Icons.image_not_supported,
                  color: AppColors.textSecondary)
              : null,
        ),
        const SizedBox(width: 16),

        // details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.product.name,
                      style: AppTextStyles.subtitle1
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.removeFromCart(item.product.id),
                    child: const Icon(Icons.delete_outline,
                        color: AppColors.error, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.product.size ?? '500 g', // Fallback or dynamic
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${item.product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.subtitle1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        color: AppColors.lightGray,
                        iconColor: AppColors.textSecondary,
                        onTap: () {
                          if (item.quantity > 1) {
                            controller.updateQuantity(
                                item.product.id, item.quantity - 1);
                          } else {
                            controller.removeFromCart(item.product.id);
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.quantity}',
                        style: AppTextStyles.subtitle1,
                      ),
                      const SizedBox(width: 12),
                      _buildQuantityButton(
                        icon: Icons.add,
                        color: AppColors.primary,
                        iconColor: AppColors.white,
                        onTap: () {
                          controller.updateQuantity(
                              item.product.id, item.quantity + 1);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }

  Widget _buildOrderSummary(CartController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow(AppStrings.subtotal,
                '₹${controller.subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildSummaryRow(AppStrings.delivery,
                '₹${controller.deliveryCharge.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildSummaryRow(
              AppStrings.total,
              '₹${controller.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.checkout);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.goToCheckout,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.headline4.copyWith(fontWeight: FontWeight.bold)
              : AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.headline4.copyWith(fontWeight: FontWeight.bold)
              : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
