import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/cart_controller.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
          AppStrings.checkout,
          style: AppTextStyles.headline3.copyWith(color: AppColors.primaryDark),
        ),
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                // Order Summary Header
                _buildSectionHeader(AppStrings.orderSummary),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mediumGray),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            '${cartController.totalQuantity} items',
                            style: AppTextStyles.bodyMedium,
                          )),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: AppColors.textSecondary),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Delivery Address
                _buildSectionHeader(AppStrings.deliveryAddress),
                const SizedBox(height: 12),
                Obx(() => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mediumGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartController
                                          .selectedAddress.value?.fullName ??
                                      'Add Address',
                                  style: AppTextStyles.subtitle1
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cartController.selectedAddress.value != null
                                      ? '${cartController.selectedAddress.value!.addressLine1}\n${cartController.selectedAddress.value!.city}, ${cartController.selectedAddress.value!.state}\n${cartController.selectedAddress.value!.phone}'
                                      : 'No address selected',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit,
                              size: 20, color: AppColors.textPrimary),
                        ],
                      ),
                    )),

                const SizedBox(height: 24),

                // Delivery Type
                _buildSectionHeader(AppStrings.deliveryType),
                const SizedBox(height: 12),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                cartController.setDeliveryType('standard'),
                            child: _buildDeliveryTypeOption(
                              'Standard',
                              '1-2 days',
                              Icons.local_shipping_outlined,
                              cartController.selectedDeliveryType.value ==
                                  'standard',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                cartController.setDeliveryType('express'),
                            child: _buildDeliveryTypeOption(
                              'Express',
                              'Same day',
                              Icons.local_shipping,
                              cartController.selectedDeliveryType.value ==
                                  'express',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                cartController.setDeliveryType('schedule'),
                            child: _buildDeliveryTypeOption(
                              'Schedule',
                              'Choose time',
                              Icons.schedule,
                              cartController.selectedDeliveryType.value ==
                                  'schedule',
                            ),
                          ),
                        ),
                      ],
                    )),

                const SizedBox(height: 24),

                // Payment Method
                _buildSectionHeader(AppStrings.paymentMethod),
                const SizedBox(height: 12),
                Obx(() => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mediumGray),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 24,
                            color: Colors.blue.shade900,
                            alignment: Alignment.center,
                            child: Text(
                                cartController.selectedPaymentMethod.value?.type
                                        .toUpperCase() ??
                                    'CARD',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 16),
                          Text(
                              '•••• ${cartController.selectedPaymentMethod.value?.lastFour ?? '****'}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    )),

                const SizedBox(height: 32),

                // Order Totals
                Obx(() => Column(
                      children: [
                        _buildSummaryRow(AppStrings.subtotal,
                            '₹${cartController.subtotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 12),
                        _buildSummaryRow(AppStrings.delivery,
                            '₹${cartController.deliveryCharge.toStringAsFixed(2)}'),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          AppStrings.total,
                          '₹${cartController.total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    )),

                const SizedBox(height: 32),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                        onPressed: cartController.isLoading.value
                            ? null
                            : () async {
                                final success =
                                    await cartController.placeOrder();
                                if (success) {
                                  Get.offNamed(AppRoutes.orderConfirmation);
                                } else if (cartController
                                    .errorMessage.value.isNotEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    cartController.errorMessage.value,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: AppColors.error,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.lightGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: cartController.isLoading.value
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppStrings.placeOrder,
                                style: AppTextStyles.subtitle1.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDeliveryTypeOption(
      String title, String subtitle, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.mediumGray),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.white : Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.8)
                  : AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
