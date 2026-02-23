
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';
import 'admin_success_screen.dart';

class CreateAdminScreen extends StatefulWidget {
  const CreateAdminScreen({super.key});

  @override
  State<CreateAdminScreen> createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Optional fields for backend compatibility if needed
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pincodeController = TextEditingController();
  final _referredByController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();
  bool _isCreating = false;

  Future<void> _createAdmin() async {
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

    setState(() => _isCreating = true);

    // Call AuthController's method to create admin WITHOUT logging in as them
    // We need to implement createAdmin in AuthController or ApiService
    final result = await _authController.createAdmin(
      name: _nameController.text.trim(),
      phone: _mobileController.text.trim(),
      password: _passwordController.text.trim(),
      address1: _addressLine1Controller.text.trim(),
      address2: _addressLine2Controller.text.trim(),
      pincode: _pincodeController.text.trim(),
      referredBy: _referredByController.text.trim(),
    );

    setState(() => _isCreating = false);

    if (result['success'] == true) {
      // Navigate to Success Screen
      Get.to(() => AdminSuccessScreen(
        adminId: _mobileController.text.trim(), // Assuming phone is used as ID
        adminPassword: _passwordController.text.trim(),
      ));
    } else {
      Get.snackbar(
        'Creation Failed',
        result['message'] ?? 'Unknown error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Admin',
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Admin Details',
                style: AppTextStyles.headline3,
              ),
              const SizedBox(height: 20),
              
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Admin Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),

              // Mobile (User ID)
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number (User ID)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  helperText: 'This will be the Admin User ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter mobile number';
                  if (value.length < 10) return 'Enter valid mobile number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address Line 1
              TextFormField(
                controller: _addressLine1Controller,
                decoration: const InputDecoration(
                  labelText: 'Address Line 1',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter address' : null,
              ),
              const SizedBox(height: 16),

              // Address Line 2
              TextFormField(
                controller: _addressLine2Controller,
                decoration: const InputDecoration(
                  labelText: 'Address Line 2 (Optional)',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Pincode
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  prefixIcon: Icon(Icons.pin_drop),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.length != 6 ? 'Enter valid 6-digit pincode' : null,
              ),
              const SizedBox(height: 16),

              // Referred By
              TextFormField(
                controller: _referredByController,
                decoration: const InputDecoration(
                  labelText: 'Referred By (Referral ID)',
                  prefixIcon: Icon(Icons.people_outline),
                  border: OutlineInputBorder(),
                  helperText: 'Enter referral ID if applicable',
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.length < 6 ? 'Password must be at least 6 chars' : null,
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please confirm password' : null,
              ),
              const SizedBox(height: 30),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCreating ? null : _createAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isCreating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Create Admin',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
