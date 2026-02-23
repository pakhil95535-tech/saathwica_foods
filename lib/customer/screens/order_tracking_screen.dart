import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/order_controller.dart';
import '../../common/models/models.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    final order = Get.arguments as Order?;
    if (order != null) {
      final orderController = Get.put(OrderController());
      orderController.trackOrder(order.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as Order?;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Tracking'),
        ),
        body: const Center(
          child: Text('Order not found'),
        ),
      );
    }

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
          'Order #${order.id}',
          style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
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
                _buildTimelineItem(
                  logo: AppAssets.logo,
                  icon: Icons.assignment,
                  title: 'Order Taken',
                  isCompleted: [
                    'confirmed',
                    'preparing',
                    'in_delivery',
                    'delivered',
                    'completed'
                  ].contains(order.status),
                  showLine: true,
                  bgColor: const Color(0xFFF9FBE7),
                ),
                _buildTimelineItem(
                  icon: Icons.restaurant,
                  title: 'Order Is Being Prepared',
                  isCompleted: [
                    'preparing',
                    'in_delivery',
                    'delivered',
                    'completed'
                  ].contains(order.status),
                  showLine: true,
                  bgColor: const Color(0xFFF3E5F5),
                ),
                _buildTimelineItem(
                  logo: AppAssets.logo,
                  icon: Icons.local_shipping,
                  title: 'Order Is Being Delivered',
                  subtitle: order.status == 'in_delivery'
                      ? 'Your delivery agent is coming'
                      : null,
                  isCompleted: ['in_delivery', 'delivered', 'completed']
                      .contains(order.status),
                  items: order.status == 'in_delivery'
                      ? _buildMapPlaceholder()
                      : null,
                  showLine: true,
                  trailing:
                      order.status == 'in_delivery' ? _buildCallButton() : null,
                  bgColor: const Color(0xFFFCE4EC),
                ),
                _buildTimelineItem(
                  logo: 'assets/images/checkmark_logo.png',
                  icon: Icons.check_circle,
                  title: 'Order Received',
                  isCompleted:
                      ['delivered', 'completed'].contains(order.status),
                  showLine: false,
                  bgColor: const Color(0xFFE8F5E9),
                  trailing: order.status == 'pending' ||
                          order.status == 'confirmed' ||
                          order.status == 'preparing'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    shape: BoxShape.circle)),
                          ],
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    String? logo,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isCompleted,
    required bool showLine,
    required Color bgColor,
    Widget? items,
    Widget? trailing,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: logo != null
                    ? Image.asset(logo, fit: BoxFit.contain)
                    : Icon(
                        icon,
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 24,
                      ),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFFFE082), // Gold/Yellow line
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.subtitle1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompleted || subtitle != null
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          if (subtitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                subtitle,
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (trailing != null)
                      trailing
                    else if (isCompleted)
                      const Icon(Icons.check_circle,
                          color: AppColors.success, size: 24),
                  ],
                ),
                if (items != null) ...[
                  const SizedBox(height: 16),
                  items,
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/map_placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
          child: Icon(Icons.map, color: AppColors.lightGray, size: 40)),
    );
  }

  Widget _buildCallButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFAF8E30), // Goldish color from call_logo background
        shape: BoxShape.circle,
      ),
      child: Image.asset('assets/images/call_logo.png', fit: BoxFit.contain),
    );
  }
}
