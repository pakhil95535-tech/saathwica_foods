import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class HistoricalNotificationsScreen extends StatelessWidget {
  const HistoricalNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> historicalNotifications = [
      {
        'title': 'Welcome to Grand Taste!',
        'body': 'Thank you for joining us. Enjoy the best food in town.',
        'date': '2026-03-01',
      },
      {
        'title': 'New Masala Available',
        'body': 'Our new Biryani Masala is now in stock. Try it today!',
        'date': '2026-03-05',
      },
      {
        'title': 'Order Delivered',
        'body': 'Your order #ORD12345 has been delivered successfully.',
        'date': '2026-03-10',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: historicalNotifications.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final notification = historicalNotifications[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.history, color: AppColors.primary),
            ),
            title: Text(
              notification['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  notification['body']!,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  notification['date']!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
