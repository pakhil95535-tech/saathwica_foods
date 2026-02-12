import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SupervisorRegistrationScreen extends StatefulWidget {
  const SupervisorRegistrationScreen({super.key});

  @override
  State<SupervisorRegistrationScreen> createState() =>
      _SupervisorRegistrationScreenState();
}

class _SupervisorRegistrationScreenState
    extends State<SupervisorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pincodeController = TextEditingController();
  final _adminReferralIdController = TextEditingController(); // Added
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _pincodeController.dispose();
    _adminReferralIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    // Skipping validation as requested for simple flow
    Get.offAllNamed(AppRoutes.supervisorDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Register as Supervisor',
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text('Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: AnimationLimiter(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Form(
              key: _formKey,
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
                    _buildLabel('Name'),
                    _buildTextField(_nameController, 'YOUR NAME'),
                    _buildLabel('Mobile Number'),
                    _buildTextField(_mobileController, 'ENTER PASSOWRD',
                        keyboardType: TextInputType.phone),
                    _buildLabel('Address'),
                    _buildTextField(_addressLine1Controller, 'LINE 1'),
                    const SizedBox(height: 12),
                    _buildTextField(_addressLine2Controller, 'LINE 2'),
                    _buildLabel('Pin code'),
                    _buildTextField(_pincodeController, 'ENTER PINCODE',
                        keyboardType: TextInputType.number),
                    _buildLabel('Admin Referrel ID'),
                    _buildTextField(
                        _adminReferralIdController, 'ENTER REFERREL ID'),
                    _buildLabel('Password'),
                    _buildTextField(_passwordController, 'ENTER PASSWORD',
                        obscureText: true),
                    _buildLabel('Password'),
                    _buildTextField(
                        _confirmPasswordController, 'ENTER PASSWORD',
                        obscureText: true),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 0.5),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }
}
