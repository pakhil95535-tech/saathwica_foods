import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../../routes/app_routes.dart';

class PaymentResultScreen extends StatelessWidget {
  const PaymentResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final success = args['success'] == true;
    final txId = (args['transactionId'] ?? '').toString();
    final method = (args['method'] ?? '').toString();
    final amount = (args['amount'] ?? 0.0) as double;

    return Scaffold(
      appBar: AppBar(
        title: Text(success ? 'Payment Successful' : 'Payment Failed'),
        backgroundColor: success ? Colors.green : AppColors.error,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : AppColors.error,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              success ? 'Payment Completed' : 'Payment Failed',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Transaction ID: $txId',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),
            Text('Method: $method',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),
            Text('Amount: ₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.orderConfirmation);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Done',
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.checkout);
                },
                child: const Text('Back to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
