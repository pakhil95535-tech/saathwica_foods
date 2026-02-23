import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/auth_controller.dart';
import '../../common/models/models.dart';
import '../../services/api_service.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final _authController = Get.find<AuthController>();
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, dynamic> _userDetails = {};
  List<dynamic> _orders = [];
  bool _ordersLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchOrders();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userId = _authController.userId;
      final userIdInt = int.tryParse(userId);

      if (userIdInt == null) {
        setState(() {
          _errorMessage = 'Invalid user ID';
          _isLoading = false;
        });
        return;
      }

      final response = await ApiService.getUserDetails(userIdInt);
      final userData = response['user'] ?? response['data'] ?? response;

      setState(() {
        _userDetails = userData is Map<String, dynamic> ? userData : {};
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchOrders() async {
    setState(() => _ordersLoading = true);
    try {
      final userId = _authController.userId;
      final userIdInt = int.tryParse(userId);
      if (userIdInt == null) return;

      final response = await ApiService.getUserOrders(userIdInt);

      setState(() {
        _orders = response;
        _ordersLoading = false;
      });
    } catch (_) {
      setState(() => _ordersLoading = false);
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([_fetchUserDetails(), _fetchOrders()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF146B2C)))
          : _errorMessage.isNotEmpty
              ? _buildErrorView()
              : RefreshIndicator(
                  color: const Color(0xFF146B2C),
                  onRefresh: _refreshAll,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      _buildSliverAppBar(),
                      SliverToBoxAdapter(child: _buildBody()),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSliverAppBar() {
    final name = _userDetails['name']?.toString() ?? 'User';
    final role =
        (_userDetails['role'] ?? 'customer').toString().capitalizeFirst!;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            const SizedBox(height: 20),

            // Quick Actions
            _buildQuickActions(),

            const SizedBox(height: 20),

            // Personal Info
            _buildSectionTitle('Personal Information'),
            _buildInfoCard(),

            const SizedBox(height: 20),

            // Address
            _buildSectionTitle('Address'),
            _buildAddressCard(),

            const SizedBox(height: 20),

            // Recent Orders
            _buildSectionTitle('Recent Orders'),
            _buildOrdersSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildActionChip(
            Icons.inventory_2_outlined,
            'My Orders',
            () => Get.toNamed(AppRoutes.orders),
          ),
          const SizedBox(width: 12),
          _buildActionChip(
            Icons.favorite_outline,
            'Wishlist',
            () => Get.toNamed(AppRoutes.wishlist),
          ),
          const SizedBox(width: 12),
          _buildActionChip(
            Icons.home_outlined,
            'Home',
            () => Get.offAllNamed(AppRoutes.home),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF146B2C), size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
              Icons.person_outline, 'Name', _userDetails['name'] ?? '-'),
          const Divider(height: 24),
          _buildInfoRow(
              Icons.phone_outlined, 'Phone', _userDetails['phone'] ?? '-'),
          const Divider(height: 24),
          _buildInfoRow(Icons.badge_outlined, 'Role',
              (_userDetails['role'] ?? '-').toString().capitalizeFirst!),
          const Divider(height: 24),
          _buildInfoRow(Icons.tag, 'Referral ID',
              _userDetails['refferel_id']?.toString() ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF146B2C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF146B2C), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.location_on_outlined, 'Address Line 1',
              _userDetails['address1'] ?? '-'),
          const Divider(height: 24),
          _buildInfoRow(Icons.location_on_outlined, 'Address Line 2',
              _userDetails['address2'] ?? '-'),
          const Divider(height: 24),
          _buildInfoRow(Icons.pin_drop_outlined, 'Pincode',
              _userDetails['pincode'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    if (_ordersLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF146B2C)),
        ),
      );
    }

    if (_orders.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            const Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.offAllNamed(AppRoutes.home),
              child: const Text(
                'Start Shopping',
                style: TextStyle(
                  color: Color(0xFF146B2C),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show up to 3 most recent orders
    final recentOrders = _orders.take(3).toList();

    return Column(
      children: [
        ...recentOrders.map((order) => _buildOrderCard(order)),
        if (_orders.length > 3)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.toNamed(AppRoutes.orders),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF146B2C)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'View All Orders',
                  style: TextStyle(
                    color: Color(0xFF146B2C),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderCard(dynamic orderData) {
    if (orderData is! Order) {
      // If for some reason it's still a Map, try to parse it
      if (orderData is Map<String, dynamic>) {
        try {
          orderData = Order.fromJson(orderData);
        } catch (_) {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    }

    final Order order = orderData;
    final orderId = order.id;
    final status = order.status;
    final total = order.total;
    final totalStr = '₹${total.toStringAsFixed(2)}';
    final date = order.orderDate;
    final dateStr = '${date.day}/${date.month}/${date.year}';

    Color statusColor;
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        statusColor = const Color(0xFF146B2C);
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      case 'preparing':
      case 'confirmed':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.info;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Order icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.receipt_long, color: statusColor, size: 22),
          ),
          const SizedBox(width: 14),
          // Order details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #$orderId',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          // Status & total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.capitalizeFirst!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalStr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchUserDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF146B2C),
              foregroundColor: AppColors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
