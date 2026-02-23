import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_joinings_section.dart';

class AdminJoiningsScreen extends StatelessWidget {
  const AdminJoiningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: AdminJoiningsSection(
          onBackPressed: () => Get.back(),
        ),
      ),
    );
  }
}
