import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/utils/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdminRegistrationScreen extends StatefulWidget {
  const AdminRegistrationScreen({super.key});

  @override
  State<AdminRegistrationScreen> createState() =>
      _AdminRegistrationScreenState();
}

class _AdminRegistrationScreenState extends State<AdminRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pincodeController = TextEditingController();
  final _referralCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _pincodeController.dispose();
    _referralCodeController.dispose();
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
      userType: 'admin',
      referralId: _referralCodeController.text.trim(),
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: _addressLine2Controller.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    if (success) {
      Get.defaultDialog(
        title: 'Admin Created',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please share these credentials securely:'),
            const SizedBox(height: 10),
            Text('Phone: ${_mobileController.text.trim()}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Password: ${_passwordController.text.trim()}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.back(); // Go back to drawer/dashboard after creation
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
        barrierDismissible: false,
      );
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
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Create Admin',
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
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
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
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
                                AppColors.primary),
                          ),
                        )
                      : const Text('Create Admin',
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
                    _buildTextField(_nameController, 'ADMIN NAME'),
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
                    _buildLabel('Referral Code'),
                    _buildTextField(
                        _referralCodeController, 'ENTER REFERRAL CODE'),
                    _buildLabel('Password'),
                    _buildTextField(
                      _passwordController,
                      'ENTER PASSWORD',
                      obscureText: !_showPassword,
                      suffix: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),
                    _buildLabel('Confirm Password'),
                    _buildTextField(
                      _confirmPasswordController,
                      'CONFIRM PASSWORD',
                      obscureText: !_showConfirmPassword,
                      suffix: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword),
                      ),
                    ),
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
      {bool obscureText = false, TextInputType? keyboardType, Widget? suffix}) {
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
          suffixIcon: suffix,
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
