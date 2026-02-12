import 'package:flutter/material.dart';

class RoleSpecificAvatar extends StatelessWidget {
  final String label;
  final String? role; // Added optional role parameter
  final double size;

  const RoleSpecificAvatar({
    super.key,
    required this.label,
    this.role,
    this.size = 45,
  });

  @override
  Widget build(BuildContext context) {
    String? assetPath;

    // Prioritize forced role if provided
    final String targetRole = (role ?? label).toLowerCase();

    if (targetRole.contains('customer')) {
      assetPath = 'assets/images/customerlogo.png';
    } else if (targetRole.contains('supervisor')) {
      assetPath = 'assets/images/supervisorlogo.png';
    } else if (targetRole.contains('employee')) {
      assetPath = 'assets/images/employeelogo.png';
    }

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(size * 0.1),
      ),
      padding: EdgeInsets.all(size * 0.1),
      child: assetPath != null
          ? Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
    );
  }
}
