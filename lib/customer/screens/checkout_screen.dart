import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/cart_controller.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'add_address_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    // Ensure addresses are fetched if list is empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cartController.savedAddresses.isEmpty) {
        cartController.fetchAddressesFromBackend();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.checkout,
          style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
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
                Obx(() {
                  if (cartController.isLoading.value &&
                      cartController.savedAddresses.isEmpty) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ));
                  }

                  if (cartController.addressErrorMessage.value.isNotEmpty &&
                      cartController.savedAddresses.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.error.withAlpha(51)),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.error.withAlpha(13),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: AppColors.error, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cartController.addressErrorMessage.value,
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () =>
                                cartController.fetchAddressesFromBackend(),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Retry'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 30),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => _showAddressSelection(context, cartController),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mediumGray),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      cartController.selectedAddress.value
                                              ?.fullName ??
                                          'Add Address',
                                      style: AppTextStyles.subtitle1.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (cartController.selectedAddress.value !=
                                        null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.primary.withAlpha(25),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: AppColors.primary
                                                  .withAlpha(76)),
                                        ),
                                        child: Text(
                                          'Saved Address',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cartController.selectedAddress.value != null
                                      ? '${cartController.selectedAddress.value!.hNo}, ${cartController.selectedAddress.value!.street}\n${cartController.selectedAddress.value!.addressLine1}, ${cartController.selectedAddress.value!.city} - ${cartController.selectedAddress.value!.pincode}\n${cartController.selectedAddress.value!.phone}'
                                      : 'No address selected',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  );
                }),

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
                Obx(() {
                  double totalSavings =
                      cartController.cart.value?.items.fold(0.0, (sum, item) {
                            if (item.product.originalPrice >
                                item.product.price) {
                              return sum! +
                                  (item.product.originalPrice -
                                          item.product.price) *
                                      item.quantity;
                            }
                            return sum;
                          }) ??
                          0.0;

                  return Column(
                    children: [
                      _buildSummaryRow(AppStrings.subtotal,
                          '₹${cartController.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow(AppStrings.delivery,
                          '₹${cartController.deliveryCharge.toStringAsFixed(2)}'),
                      if (totalSavings > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Savings',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- ₹${totalSavings.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        AppStrings.total,
                        '₹${cartController.total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 32),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                        onPressed: cartController.isLoading.value
                            ? null
                            : () async {
                                final order = await cartController.placeOrder();
                                if (order != null) {
                                  Get.offNamed(AppRoutes.orderConfirmation,
                                      arguments: order);
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
                  ? AppColors.primary.withAlpha(204)
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

  void _showAddressSelection(BuildContext context, CartController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.mediumGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Delivery Address',
                    style: AppTextStyles.headline4),
                TextButton.icon(
                  onPressed: () {
                    Get.back(); // Close sheet
                    Get.to(() => const AddAddressScreen());
                  },
                  icon:
                      const Icon(Icons.add, size: 18, color: AppColors.primary),
                  label: const Text('Add New',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Flexible(
              child: Obx(() {
                if (controller.savedAddresses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_off_outlined,
                              size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text('No saved addresses',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Text('Tap "Add New" to add a delivery address',
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.savedAddresses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final address = controller.savedAddresses[index];
                    final isSelected =
                        controller.selectedAddress.value?.id == address.id;
                    return InkWell(
                      onTap: () {
                        controller.setSelectedAddress(address);
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.05)
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusSmall),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primary.withOpacity(0.3))
                              : null,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: address.id,
                              groupValue: controller.selectedAddress.value?.id,
                              onChanged: (_) {
                                controller.setSelectedAddress(address);
                                Get.back();
                              },
                              activeColor: AppColors.primary,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(address.fullName,
                                          style: AppTextStyles.subtitle1),
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text('Selected',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${address.hNo}, ${address.street}, ${address.addressLine1}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary),
                                  ),
                                  Text(
                                    '${address.city} - ${address.pincode}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  Text(
                                    address.phone,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      color: AppColors.primary, size: 20),
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    Get.back(); // Close sheet
                                    Get.to(() =>
                                        AddAddressScreen(address: address));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: AppColors.error, size: 20),
                                  tooltip: 'Delete',
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'Delete Address',
                                      middleText:
                                          'Are you sure you want to delete this address?',
                                      textConfirm: 'Delete',
                                      textCancel: 'Cancel',
                                      confirmTextColor: Colors.white,
                                      buttonColor: AppColors.error,
                                      onConfirm: () {
                                        Get.back(); // Close dialog first
                                        controller.deleteAddress(address);
                                        // The Obx list rebuilds automatically
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
