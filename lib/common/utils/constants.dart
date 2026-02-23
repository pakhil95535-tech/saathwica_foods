// lib/utils/constants.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF146B2C); // Brand Green
  static const Color primaryDark = Color(0xFF27214D); // Dark Purple
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Secondary Colors
  static const Color success = Color(0xFF56A25F); // Green
  static const Color error = Color(0xFFE74C3C); // Red
  static const Color warning = Color(0xFFF39C12); // Orange
  static const Color info = Color(0xFF3498DB); // Blue
  static const Color teal = Color(0xFF26A69A); // Teal for drawer icons

  // Neutral Colors
  static const Color lightGray = Color(0xFF888888);
  static const Color mediumGray = Color(0xFFF3F1F1);
  static const Color darkGray = Color(0xFF666666);
  static const Color cream = Color(0xFFFFFAEB); // Cream background

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  // Shadows
  static const Color shadowColor = Color(0x1A000000);
}

class AppSizes {
  // Padding & Margin
  static const double paddingXXSmall = 4.0;
  static const double paddingXSmall = 8.0;
  static const double paddingSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingXLarge = 24.0;
  static const double paddingXXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Button Sizes
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  // Image Sizes
  static const double imageSmall = 80.0;
  static const double imageMedium = 120.0;
  static const double imageLarge = 200.0;
  static const double imageXLarge = 300.0;

  // Input Field
  static const double inputHeight = 50.0;
  static const double inputBorderRadius = 12.0;
}

class AppTextStyles {
  // Headline Styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  // Subtitle Styles
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  // Caption Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    fontFamily: 'Poppins',
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    fontFamily: 'Poppins',
  );

  // Price Style
  static const TextStyle priceStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    color: AppColors.success,
    fontFamily: 'Poppins',
  );
}

class AppDurations {
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 400);
  static const Duration animationDurationLong = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration transitionDuration = Duration(milliseconds: 500);
}

class AppStrings {
  // App Name
  static const String appName = 'Grand Taste'; // Default / Customer
  static const String brandLife = 'Grand Life'; // Employee / Supervisor / Admin
  static const String newBrandName = 'Grand Life'; // Keep for backward compatibility if needed, but prefer brandLife

  // Auth Screens
  static const String loginTitle = 'Login';
  static const String registerTitle = 'Register';
  static const String userId = 'User ID';
  static const String password = 'Password';
  static const String enterUserId = 'ENTER USER ID';
  static const String enterPassword = 'ENTER PASSWORD';
  static const String letsContinue = "Let's Continue";
  static const String dontHaveAccount = "Don't have an account yet? ";
  static const String registerLink = 'Register';

  // User Types
  static const String supervisor = 'Supervisor';
  static const String employee = 'Employee';
  static const String customer = 'Customer';

  // Home Screen
  static const String searchPlaceholder = 'Search for latest offers';
  static const String myBasket = 'My basket';
  static const String recommendedItems = 'Recommended Items';
  static const String latest = 'Latest';
  static const String popular = 'Popular';
  static const String newCombo = 'New combo';
  static const String top = 'Top';

  // Product Screen
  static const String addToCart = 'Add to Cart';
  static const String aboutThisProduct = 'About this product';
  static const String readMore = 'Read More';
  static const String totalPrice = 'Total Price';
  static const String perUnit = 'per unit';

  // Cart Screen
  static const String myCart = 'My Cart';
  static const String goToCheckout = 'Go to checkout';
  static const String subtotal = 'Subtotal';
  static const String delivery = 'Delivery';
  static const String total = 'Total';

  // Checkout Screen
  static const String checkout = 'Checkout';
  static const String orderSummary = 'Order Summary';
  static const String deliveryAddress = 'Delivery Address';
  static const String deliveryType = 'Delivery Type';
  static const String standard = 'Standard';
  static const String standardDays = '1-2 days';
  static const String express = 'Express';
  static const String sameDay = 'Same day';
  static const String schedule = 'Schedule';
  static const String chooseTime = 'Choose time';
  static const String paymentMethod = 'Payment Method';
  static const String placeOrder = 'Place order';

  // Order Confirmation
  static const String congratulations = 'Congratulations!!!';
  static const String orderTaken =
      'Your order have been taken\nand is being attended to';
  static const String trackOrder = 'Track order';
  static const String continueShopping = 'Continue shopping';

  // Tracking
  static const String deliveryStatus = 'Delivery Status';
  static const String orderTakenStatus = 'Order Taken';
  static const String orderPreparing = 'Order Is Being Prepared';
  static const String orderDelivering = 'Order Is Being Delivered';
  static const String deliveryAgentComing = 'Your delivery agent is coming';
  static const String orderReceived = 'Order Received';

  // Bottom Navigation
  static const String home = 'Home';
  static const String profile = 'Profile';
  static const String cart = 'Cart';

  // Common
  static const String items = 'items';
  static const String noData = 'No Data Found';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String tryAgain = 'Try Again';
  static const String success = 'Success';
}

class AppEndpoints {
  static const String _devBase =
      'https://single-vendor-e-commerce-node-1.onrender.com';
  static String get baseUrl {
    if (kIsWeb) return _devBase;
    try {
      if (Platform.isAndroid) {
        return 'https://single-vendor-e-commerce-node-1.onrender.com';
      }
      return _devBase;
    } catch (_) {
      return _devBase;
    }
  }

  static String get createUser => '$baseUrl/auth/create-users';
  static String get createCustomer => '$baseUrl/auth/create-customer';
  static String get createEmployee => '$baseUrl/auth/create-employee';
  static String get createSupervisor => '$baseUrl/auth/create-supervisor';
  static String get loginUser => '$baseUrl/auth/login-user';
  static String get adminSignup => '$baseUrl/auth/signup-admin';
  static String get userDetails => '$baseUrl/user/user-details';
  static String get userOrders => '$baseUrl/user';
  static String get products => '$baseUrl/products';
  static String get productDetail => '$baseUrl/products';
  static String get categories => '$baseUrl/categories';
  static String get search => '$baseUrl/products/search';
  static String get cart => '$baseUrl/cart';
  static String get addToCart => '$baseUrl/cart/add';
  static String get updateCart => '$baseUrl/cart/update';
  static String get removeCart => '$baseUrl/cart/remove';
  static String get orders => '$baseUrl/orders';
  static String get orderDetail => '$baseUrl/update-order';
  static String get tracking => '$baseUrl/orders/tracking';
  static String get payment => '$baseUrl/payment';
  static String get paymentMethods => '$baseUrl/payment-methods';
  static String get addAddress => '$baseUrl/add-address';
  static String get updateAddress => '$baseUrl/user/update-address';
  static String get deleteAddress => '$baseUrl/delete-address';
  static String get getUserAddresses => '$baseUrl/get-addresses';
  static String get fetchProducts => '$baseUrl/product/fetch-products';
  static String get createOrder => '$baseUrl/order/place-order';
}

class AppValidations {
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final RegExp pincodeRegex = RegExp(r'^[0-9]{6}$');
}

class AppAssets {
  static const String logo = 'assets/icons/new_logo.png'; // Grand Taste Logo
  static const String grandTasteLogo = 'assets/icons/new_logo.png';
  static const String grandLifeLogo = 'assets/icons/grand_life.png';
  static const String appLogo = 'assets/icons/grand_life.png'; // Default for internal dashboards
  
  // Role-specific logos
  static const String customerLogo = 'assets/images/customerlogo.png';
  static const String supervisorLogo = 'assets/images/supervisorlogo.png';
  static const String employeeLogo = 'assets/images/employeelogo.png';
}
