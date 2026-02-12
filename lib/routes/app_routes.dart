// lib/routes/app_routes.dart

import 'package:get/get.dart';
import '../common/screens/splash_screen.dart';
import '../common/screens/welcome_screen.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/register_type_screen.dart';
import '../auth/screens/customer_registration_screen.dart';
import '../auth/screens/employee_registration_screen.dart';
import '../auth/screens/supervisor_registration_screen.dart';
import '../customer/screens/home_screen.dart';
import '../customer/screens/cart_screen.dart';
import '../customer/screens/checkout_screen.dart';
import '../customer/screens/order_confirmation_screen.dart';
import '../customer/screens/order_tracking_screen.dart';
import '../customer/screens/product_details_screen.dart';
import '../customer/screens/my_orders_screen.dart';
import '../admin/screens/admin_dashboard_screen.dart';
import '../common/screens/notifications_screen.dart';
import '../supervisor/screens/supervisor_dashboard_screen.dart';
import '../employee/screens/employee_dashboard_screen.dart';
import '../employee/screens/employee_earnings_screen.dart';
import '../employee/screens/employee_jobs_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerSupervisor = '/register-supervisor';
  static const String registerEmployee = '/register-employee';
  static const String registerCustomer = '/register-customer';
  static const String home = '/home';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String adminDashboard = '/admin-dashboard';
  static const String notifications = '/notifications';
  static const String supervisorDashboard = '/supervisor-dashboard';
  static const String employeeDashboard = '/employee-dashboard';
  static const String employeeEarnings = '/employee-earnings';
  static const String employeeJobs = '/employee-jobs';
  static const String customerDashboard = '/customer-dashboard';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: welcome,
      page: () => const WelcomeScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: register,
      page: () => const RegisterTypeScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: registerCustomer,
      page: () => const CustomerRegistrationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: registerEmployee,
      page: () => const EmployeeRegistrationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: registerSupervisor,
      page: () => const SupervisorRegistrationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cart,
      page: () => const CartScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: checkout,
      page: () => const CheckoutScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: orderConfirmation,
      page: () => const OrderConfirmationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: orderTracking,
      page: () => const OrderTrackingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: productDetail,
      page: () => const ProductDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: orders,
      page: () => const MyOrdersScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: adminDashboard,
      page: () => const AdminDashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notifications,
      page: () => const NotificationsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: supervisorDashboard,
      page: () => const SupervisorDashboardScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: employeeDashboard,
      page: () => const EmployeeDashboardScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: employeeEarnings,
      page: () => const EmployeeEarningsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: employeeJobs,
      page: () => const EmployeeJobsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: customerDashboard,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
