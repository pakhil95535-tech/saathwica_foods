import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_earnings_section.dart';

class AdminEarningsScreen extends StatelessWidget {
  const AdminEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: AdminEarningsSection(
          onBackPressed: () => Get.back(),
        ),
      ),
    );
  }
}
