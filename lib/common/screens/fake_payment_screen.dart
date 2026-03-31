import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../controllers/cart_controller.dart';
import '../../routes/app_routes.dart';

class FakePaymentScreen extends StatefulWidget {
  const FakePaymentScreen({super.key});

  @override
  State<FakePaymentScreen> createState() => _FakePaymentScreenState();
}

class _FakePaymentScreenState extends State<FakePaymentScreen> {
  final cartController = Get.find<CartController>();
  final List<String> methods = ['UPI', 'Card', 'Wallet', 'COD'];
  String selected = 'UPI';
  bool processing = false;

  void _startPayment({required bool success}) async {
    setState(() => processing = true);
    await Future.delayed(const Duration(seconds: 2));
    final txId = 'TXN${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}';
    cartController.setPaymentResult(
      status: success ? 'success' : 'failed',
      transactionId: txId,
      method: selected,
    );
    setState(() => processing = false);
    Get.offNamed(AppRoutes.paymentResult, arguments: {
      'success': success,
      'transactionId': txId,
      'method': selected,
      'amount': cartController.total,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: methods
                  .map(
                    (m) => ChoiceChip(
                      label: Text(m),
                      selected: selected == m,
                      onSelected: (v) {
                        if (v) setState(() => selected = m);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mediumGray),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Obx(() => Text('₹${cartController.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const Spacer(),
            if (processing)
              const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primary),
              )
            else ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _startPayment(success: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Pay Now',
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _startPayment(success: false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('Simulate Payment Failed'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
