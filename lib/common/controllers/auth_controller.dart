// lib/controllers/auth_controller.dart

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();
  final errorMessage = ''.obs;

  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initSharedPreferences();
    await checkLoginStatus();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> login(String userId, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user
      final user = User(
        id: userId,
        name: 'John Doe',
        email: 'john@example.com',
        phone: userId,
        userType: 'customer',
      );

      currentUser.value = user;
      isLoggedIn.value = true;

      // Save to local storage
      await _prefs.setString('user_id', user.id);
      await _prefs.setString('user_token', 'mock_token_$userId');

      return true;
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String userType,
    String? referralId,
    required String addressLine1,
    required String addressLine2,
    required String pincode,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final user = User(
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        referralId: referralId,
      );

      currentUser.value = user;
      isLoggedIn.value = true;

      // Save to local storage
      await _prefs.setString('user_id', user.id);
      await _prefs.setString('user_type', userType);

      return true;
    } catch (e) {
      errorMessage.value = 'Registration failed: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // TODO: Call logout API
      await Future.delayed(const Duration(seconds: 1));

      currentUser.value = null;
      isLoggedIn.value = false;

      await _prefs.remove('user_id');
      await _prefs.remove('user_token');
      await _prefs.remove('user_type');

      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Logout failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final userId = _prefs.getString('user_id');

      if (userId != null && userId.isNotEmpty) {
        // TODO: Fetch user details from API
        currentUser.value = User(
          id: userId,
          name: 'John Doe',
          email: 'john@example.com',
          phone: userId,
          userType: _prefs.getString('user_type') ?? 'customer',
        );
        isLoggedIn.value = true;
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
  }

  User? get user => currentUser.value;
  bool get loggedIn => isLoggedIn.value;
  String get userId => currentUser.value?.id ?? '';
}
