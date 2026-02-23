// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/utils/constants.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _floatingController;
  late Animation<Offset> _floatingAnimation;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: const Offset(0, -0.05),
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter phone number and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    // Real API login
    final success = await _authController.login(phone, password);

    if (success) {
        final route = _authController.getInitialRoute();
        Get.offAllNamed(route);
      } else {
      Get.snackbar(
        'Login Failed',
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
      backgroundColor: AppColors.white, // Changed from primary to white
      body: AnimationLimiter(
        child: SingleChildScrollView(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                // Header / Illustration area
                Container(
                  height: MediaQuery.of(context).size.height * 0.45, // Reduced height slightly
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40), // Spacer for Status Bar
                      // Logo
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SlideTransition(
                          position: _floatingAnimation,
                          child: Image.asset(
                            AppAssets.logo,
                            height: 180,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.shopping_basket,
                                size: 100,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Form Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('User ID',
                          style: TextStyle(
                              color: AppColors.primary, // Changed to primary
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildTextField(_userIdController, 'ENTER USER ID'),

                      const SizedBox(height: 20),

                      const Text('Password',
                          style: TextStyle(
                              color: AppColors.primary, // Changed to primary
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildTextField(_passwordController,
                          'ENTER PASSWORD', // Fixed typo
                          obscureText: true),

                      const SizedBox(height: 40),

                      // Let's Continue Button
                      AnimationConfiguration.synchronized(
                        child: ScaleAnimation(
                          scale: 0.5,
                          child: Obx(() => SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: _authController.isLoading.value
                                      ? null
                                      : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary, // Changed to primary
                                    foregroundColor: AppColors.white, // Changed to white
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _authController.isLoading.value
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.white), // Changed to white
                                          ),
                                        )
                                      : const Text("Let's Continue",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Register Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate back to Role Selection for registration
                            Get.toNamed(AppRoutes.register);
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an account yet?   ",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 14), // Changed to primary
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05), // Subtle primary tint
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
