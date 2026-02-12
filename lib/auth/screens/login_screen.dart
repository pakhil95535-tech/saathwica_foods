// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void _login() {
    final userId = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    if (userId == 'admin@foodapp.com' && password == 'Admin@123') {
      Get.offAllNamed(AppRoutes.adminDashboard);
      return;
    }

    // Existing customer/other user login logic
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Gold background
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
                // Header / Illustration area (White background with rounded bottom corners)
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40), // Spacer for Status Bar
                      // Illustration
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SlideTransition(
                          position: _floatingAnimation,
                          child: Image.asset(
                            'assets/images/login_illustration.png',
                            height: 250,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.shopping_basket,
                                size: 150,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Form Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('User ID',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildTextField(_userIdController, 'ENTER USER ID'),

                      const SizedBox(height: 20),

                      const Text('Password',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildTextField(_passwordController,
                          'ENTER PASSOWRD', // Typo matches design image
                          obscureText: true),

                      const SizedBox(height: 40),

                      // Let's Continue Button
                      AnimationConfiguration.synchronized(
                        child: ScaleAnimation(
                          scale: 0.5,
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 0,
                              ),
                              child: const Text("Let's Continue",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
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
                                  color: AppColors.white, fontSize: 14),
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
        color: const Color(0xFFF5F5F5), // Light grey/white for input background
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
