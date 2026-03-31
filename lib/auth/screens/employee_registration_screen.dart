import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/utils/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _emailController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pincodeController = TextEditingController();
  final _supervisorReferralIdController = TextEditingController(); // Added
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _otpLoading = false;
  String _otpError = '';
  String _serverOtp = '';
  bool _agreePolicies = false;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
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

    if (!_otpVerified) {
      Get.snackbar(
        'Error',
        'Please verify OTP before registering',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

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

  Future<void> _sendOtp() async {
    try {
      setState(() {
        _otpLoading = true;
        _otpError = '';
      });
      final res = await ApiService.sendOtp(
        phone: _mobileController.text.trim(),
        username: _nameController.text.trim(),
      );
      _serverOtp = (res['otp'] ?? '').toString();
      setState(() {
        _otpSent = true;
      });
      Get.snackbar('Success', 'OTP sent', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      setState(() => _otpError = e.toString());
    } finally {
      setState(() => _otpLoading = false);
    }
  }

  Future<void> _verifyOtp(String otp) async {
    try {
      setState(() {
        _otpLoading = true;
        _otpError = '';
      });
      if (_serverOtp.isNotEmpty && _serverOtp == otp) {
        setState(() => _otpVerified = true);
        Get.snackbar('Success', 'OTP Verified Successfully',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        setState(() => _otpError = 'Invalid OTP');
      }
    } catch (e) {
      setState(() => _otpError = e.toString());
    } finally {
      setState(() => _otpLoading = false);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Unable to open link',
          snackPosition: SnackPosition.BOTTOM);
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
                  onPressed: _authController.isLoading.value ||
                          !_otpVerified ||
                          !_agreePolicies
                      ? null
                      : _register,
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _mobileController,
                            'ENTER MOBILE NUMBER',
                            keyboardType: TextInputType.phone,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _otpLoading ||
                                  !AppValidations.phoneRegex.hasMatch(
                                      _mobileController.text.trim())
                              ? null
                              : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: _otpLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Send OTP',
                                  style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    if (_otpSent) ...[
                      const SizedBox(height: 8),
                      _buildLabel('Enter OTP'),
                      Builder(builder: (context) {
                        final controller = TextEditingController();
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                  hintText: '6 digit OTP',
                                  counterText: '',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: _otpLoading
                                  ? null
                                  : () => _verifyOtp(controller.text.trim()),
                              child: const Text('Verify OTP'),
                            ),
                          ],
                        );
                      }),
                      if (_otpError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(_otpError,
                              style:
                                  const TextStyle(color: AppColors.error)),
                        ),
                    ],
                    _buildLabel('Address'),
                    
                    _buildTextField(_addressLine1Controller, 'LINE 1',
                        enabled: _otpVerified),
                    const SizedBox(height: 12),
                    _buildTextField(_addressLine2Controller, 'LINE 2',
                        enabled: _otpVerified),
                    _buildLabel('Pin code'),
                    _buildTextField(_pincodeController, 'ENTER PINCODE',
                        keyboardType: TextInputType.number,
                        enabled: _otpVerified),
                    _buildLabel('Supervisor Referral Code'),
                    _buildTextField(
                        _supervisorReferralIdController, 'ENTER REFERRAL CODE',
                        enabled: _otpVerified),
                    _buildLabel('Password'),
                    _buildTextField(
                      _passwordController,
                      'ENTER PASSWORD',
                      obscureText: !_showPassword,
                      enabled: _otpVerified,
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
                      enabled: _otpVerified,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _agreePolicies,
                          onChanged: (v) => setState(() {
                            _agreePolicies = v ?? false;
                          }),
                          activeColor: AppColors.primary,
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              const Text('I agree to '),
                              GestureDetector(
                                onTap: () => _openUrl(AppLinks.terms),
                                child: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Text(' & '),
                              GestureDetector(
                                onTap: () => _openUrl(AppLinks.privacy),
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
          color: AppColors.primary, // Changed to primary
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false,
      TextInputType? keyboardType,
      Widget? suffix,
      bool enabled = true,
      ValueChanged<String>? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mediumGray, // Changed to mediumGray
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        onChanged: onChanged,
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
