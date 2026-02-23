import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/utils/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class EmployeeRegistrationScreen extends StatefulWidget {
  const EmployeeRegistrationScreen({super.key});

  @override
  State<EmployeeRegistrationScreen> createState() =>
      _EmployeeRegistrationScreenState();
}

class _EmployeeRegistrationScreenState
    extends State<EmployeeRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pincodeController = TextEditingController();
  final _supervisorReferralIdController = TextEditingController(); // Added
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _pincodeController.dispose();
    _supervisorReferralIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    final success = await _authController.register(
      name: _nameController.text.trim(),
      phone: _mobileController.text.trim(),
      email: '', // Not required by backend
      password: _passwordController.text.trim(),
      userType: 'employee',
      referralId: _supervisorReferralIdController.text.trim(),
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: _addressLine2Controller.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    if (success) {
      final route = _authController.getInitialRoute();
      Get.offAllNamed(route);
    } else {
      Get.snackbar(
        'Registration Failed',
        _authController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // Changed to white
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary), // Changed to primary
          onPressed: () => Get.back(),
        ),
        title: const Text('Register as Employee',
            style:
                TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)), // Changed to primary
        backgroundColor: AppColors.white, // Changed to white
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _authController.isLoading.value ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Changed to primary
                    foregroundColor: AppColors.white, // Changed to white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: _authController.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white), // Changed to white
                          ),
                        )
                      : const Text('Register',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              )),
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
                    _buildTextField(_mobileController, 'ENTER MOBILE NUMBER',
                        keyboardType: TextInputType.phone),
                    _buildLabel('Address'),
                    _buildTextField(_addressLine1Controller, 'LINE 1'),
                    const SizedBox(height: 12),
                    _buildTextField(_addressLine2Controller, 'LINE 2'),
                    _buildLabel('Pin code'),
                    _buildTextField(_pincodeController, 'ENTER PINCODE',
                        keyboardType: TextInputType.number),
                    _buildLabel('Admin Referral Code'),
                    _buildTextField(
                        _supervisorReferralIdController, 'ENTER REFERRAL CODE'),
                    _buildLabel('Password'),
                    _buildTextField(_passwordController, 'ENTER PASSWORD',
                        obscureText: true),
                    _buildLabel('Confirm Password'),
                    _buildTextField(
                        _confirmPasswordController, 'CONFIRM PASSWORD',
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
          color: AppColors.primary, // Changed to primary
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
        color: AppColors.mediumGray, // Changed to mediumGray
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
