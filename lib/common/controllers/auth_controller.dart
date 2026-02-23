// lib/controllers/auth_controller.dart

import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/models.dart';
import '../../services/api_service.dart';
import '../../routes/app_routes.dart';
import 'cart_controller.dart';
import 'order_controller.dart';
import 'product_controller.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();
  final errorMessage = ''.obs;

  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await checkLoginStatus();
  }

  // ─── Login ──────────────────────────────────────────────────────────────
  Future<bool> login(String phone, String password) async {
    // Super Admin Hardcoded Login
    if (phone == '0000000000' && password == 'superadmin') {
      currentUser.value = User(
        id: 'superadmin',
        name: 'Super Admin',
        email: 'superadmin@saathwica.com',
        phone: '0000000000',
        userType: 'superadmin',
      );
      isLoggedIn.value = true;
      await _storage.write(key: 'user_id', value: 'superadmin');
      await _storage.write(key: 'user_type', value: 'superadmin');
      // No token for hardcoded superadmin, or maybe mock one
      return true;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.loginUser(
        phone: phone,
        password: password,
      );

      // Parse user from response
      final userData = response['user'] ?? response['data'] ?? response;
      final user = User(
        id: (userData['id'] ?? userData['user_id'] ?? '').toString(),
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? phone,
        userType: userData['role'] ?? userData['userType'] ?? 'customer',
        referralId: userData['refferel_id']?.toString(),
      );

      currentUser.value = user;
      isLoggedIn.value = true;

      // Save to secure storage
      await _storage.write(key: 'user_id', value: user.id);
      await _storage.write(key: 'user_type', value: user.userType);

      // Store token securely
      final token = response['token'] ?? response['access_token'];
      if (token != null) {
        final tokenStr = token.toString();
        await _storage.write(key: 'user_token', value: tokenStr);
        ApiService.authToken = tokenStr;

        // Optionally extract userId from JWT if backend supports it
        try {
          if (!JwtDecoder.isExpired(tokenStr)) {
            final decodedToken = JwtDecoder.decode(tokenStr);
            final jwtUserId = decodedToken['sub'] ??
                decodedToken['id'] ??
                decodedToken['user_id'];
            if (jwtUserId != null) {
              currentUser.value =
                  currentUser.value?.copyWith(id: jwtUserId.toString());
              await _storage.write(key: 'user_id', value: jwtUserId.toString());
            }
          }
        } catch (_) {}
      }

      // Fetch addresses after successful login
      if (Get.isRegistered<CartController>()) {
        await Get.find<CartController>().fetchAddressesFromBackend();
      }
      
      // Refresh products based on new user role/token
      if (Get.isRegistered<ProductController>()) {
        await Get.find<ProductController>().fetchProducts();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Register ───────────────────────────────────────────────────────────
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
    String referredBy = '', // Changed to String
    double earnings = 0.0,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.registerUser(
        name: name,
        phone: phone,
        pincode: pincode,
        address1: addressLine1,
        address2: addressLine2.isEmpty ? null : addressLine2,
        referralId: referralId ?? '',
        password: password,
        role: userType,
        referredBy: referredBy,
        earnings: earnings,
      );

      // Parse user from response
      final userData = response['user'] ?? response['data'] ?? response;
      final user = User(
        id: (userData['id'] ?? userData['user_id'] ?? '').toString(),
        name: userData['name'] ?? name,
        email: userData['email'] ?? email,
        phone: userData['phone'] ?? phone,
        userType: userData['role'] ?? userType,
        referralId: referralId,
      );

      currentUser.value = user;
      isLoggedIn.value = true;

      // Save to secure storage
      await _storage.write(key: 'user_id', value: user.id);
      await _storage.write(key: 'user_type', value: user.userType);

      // Store token securely
      final token = response['token'] ?? response['access_token'];
      if (token != null) {
        final tokenStr = token.toString();
        await _storage.write(key: 'user_token', value: tokenStr);
        ApiService.authToken = tokenStr;
      }

      // Refresh products based on new user role/token
      if (Get.isRegistered<ProductController>()) {
        await Get.find<ProductController>().fetchProducts();
      }

      return true;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      return false;
    } catch (e) {
      errorMessage.value = 'Registration failed: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Create Admin (Super Admin only) ───────────────────────────────────
  Future<Map<String, dynamic>> createAdmin({
    required String name,
    required String phone,
    required String password,
    required String address1,
    required String address2,
    required String pincode,
    required String referredBy,
  }) async {
    try {
      final response = await ApiService.registerUser(
        name: name,
        phone: phone,
        pincode: pincode,
        address1: address1,
        address2: address2,
        referralId: '',
        referredBy: referredBy,
        password: password,
        role: 'admin',
      );

      // We do NOT log in the new user. Just return success.
      return {
        'success': true,
        'data': response,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // ─── Logout ─────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      isLoading.value = true;

      currentUser.value = null;
      isLoggedIn.value = false;

      await _storage.delete(key: 'user_id');
      await _storage.delete(key: 'user_token');
      await _storage.delete(key: 'user_type');

      ApiService.authToken = null;

      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().clearCart();
        Get.find<CartController>().savedAddresses.clear();
        Get.find<CartController>().selectedAddress.value = null;
      }
      
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().orders.clear();
      }

      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Logout failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Check Login Status (restore session) ──────────────────────────────
  Future<void> checkLoginStatus() async {
    try {
      final userId = await _storage.read(key: 'user_id');
      final savedToken = await _storage.read(key: 'user_token');
      final userType = await _storage.read(key: 'user_type');

      // Restore token for future requests
      if (savedToken != null && savedToken.isNotEmpty) {
        ApiService.authToken = savedToken;
      }

      if (userId != null && userId.isNotEmpty) {
        try {
          final userIdInt = int.tryParse(userId);
          if (userIdInt != null) {
            final response = await ApiService.getUserDetails(userIdInt);
            final userData = response['user'] ?? response['data'] ?? response;

            currentUser.value = User(
              id: (userData['id'] ?? userData['user_id'] ?? userId).toString(),
              name: userData['name'] ?? '',
              email: userData['email'] ?? '',
              phone: userData['phone'] ?? '',
              userType: userData['role'] ??
                  userData['userType'] ??
                  userType ??
                  'customer',
              referralId: userData['refferel_id']?.toString(),
            );
            isLoggedIn.value = true;
            // Fetch addresses after successful login
            if (Get.isRegistered<CartController>()) {
              await Get.find<CartController>().fetchAddressesFromBackend();
            }
            
            // Refresh products based on restored user role/token
            if (Get.isRegistered<ProductController>()) {
              Get.find<ProductController>().fetchProducts();
            }
          } else {
            // user_id is not numeric – fall back to local data
            _restoreFromLocal(userId, userType);
          }
        } catch (_) {
          // API unreachable – fall back to locally saved data
          _restoreFromLocal(userId, userType);
        }
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
  }

  void _restoreFromLocal(String userId, String? userType) {
    currentUser.value = User(
      id: userId,
      name: '',
      email: '',
      phone: userId,
      userType: userType ?? 'customer',
    );
    isLoggedIn.value = true;
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().fetchAddressesFromBackend();
    }
  }

  // ─── Getters ────────────────────────────────────────────────────────────
  User? get user => currentUser.value;
  bool get loggedIn => isLoggedIn.value;
  String get userId => currentUser.value?.id ?? '';

  // ─── Navigation Logic ──────────────────────────────────────────────────
  String getInitialRoute() {
    if (!isLoggedIn.value || currentUser.value == null) {
      return AppRoutes.welcome;
    }

    // Role-based routing
    final role = currentUser.value?.userType.toLowerCase() ?? '';
    switch (role) {
      case 'superadmin':
        return AppRoutes.superAdminDashboard;
      case 'admin':
        return AppRoutes.adminDashboard;
      case 'supervisor':
        return AppRoutes.supervisorDashboard;
      case 'customer':
        return AppRoutes.customerDashboard;
      case 'employee':
        return AppRoutes.employeeDashboard;
      default:
        return AppRoutes.customerDashboard;
    }
  }
}
