import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AnimationLimiter(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => ScaleAnimation(
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  const Spacer(),
                  // Success Animation
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(
                        'assets/animations/success.json',
                        repeat: false,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.check_circle,
                              color: AppColors.success, size: 120);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    AppStrings.congratulations,
                    style: AppTextStyles.headline2
                        .copyWith(color: AppColors.primaryDark),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    AppStrings.orderTaken,
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Track Order (Placeholder)
                        Get.toNamed(AppRoutes.orderTracking);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        AppStrings.trackOrder,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.home);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        AppStrings.continueShopping,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
