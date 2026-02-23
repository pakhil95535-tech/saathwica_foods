import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utils/constants.dart';
import '../../routes/app_routes.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/latest_product_card.dart';
import '../widgets/shared_search_bar.dart';
import '../widgets/bottom_navigation_bar.dart';

class ShopNowScreen extends StatefulWidget {
  const ShopNowScreen({super.key});

  @override
  State<ShopNowScreen> createState() => _ShopNowScreenState();
}

class _ShopNowScreenState extends State<ShopNowScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();

  // Navigation state
  int _currentNavIndex = 1; // Default to Home

  final List<String> categories = [
    'Curries',
    'Snacks',
    'Gravies',
    'Masalas',
    'Pickles',
    'Others'
  ];

  final List<Color> _pastelColors = [
    const Color(0xFFFFF9E6),
    const Color(0xFFFCE4EC),
    const Color(0xFFF3E5F5),
    const Color(0xFFE8F5E9),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    productController.fetchProducts();
  }

  void _handleNavigation(int index) {
    if (index == _currentNavIndex) return;

    setState(() => _currentNavIndex = index);

    switch (index) {
      case 0: // Profile
        final role = authController.currentUser.value?.userType.toLowerCase();
        if (role == 'employee') {
          Get.toNamed(AppRoutes.employeeProfile);
        } else if (role == 'supervisor') {
          Get.toNamed(AppRoutes.supervisorProfile);
        } else if (role == 'admin' || role == 'super_admin') {
           Get.toNamed(AppRoutes.superAdminProfile);
        }
        // Reset index to 1 (Home) after navigation so when they return, Home is selected
        // Or keep it if we want to show "Profile" as selected but we are on a different screen?
        // Customer app pattern seems to be: Bottom bar is on Home. 
        // If we navigate away, we are on a new screen without the bottom bar (usually).
        // When we come back, we are back on Home.
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _currentNavIndex = 1);
        });
        break;
      case 1: // Home
        // Already here
        break;
      case 2: // Cart
        Get.toNamed(AppRoutes.cart);
        // Reset index to 1 when returning
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _currentNavIndex = 1);
        });
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          AppStrings.brandLife, // "Grand Life"
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.primary, size: 28),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productController.fetchProducts(),
        child: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Obx(() => SharedSearchBar(
                        hintText: AppStrings.searchPlaceholder,
                        onChanged: (q) =>
                            productController.setSearchQuery(q),
                        onFilterTap: () => _showFilterBottomSheet(context),
                        activeFilterCount:
                            productController.activeFilterCount,
                      )),
                ),

                // Recommended Items
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    AppStrings.recommendedItems,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 260,
                  child: Obx(
                    () => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      itemCount: productController.products.length > 5
                          ? 5
                          : productController.products.length,
                      itemBuilder: (context, index) {
                        final product = productController.products[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                width: 180,
                                margin:
                                    const EdgeInsets.only(right: 15, bottom: 10),
                                child: ProductCard(
                                  product: product,
                                  onTap: () => Get.toNamed(
                                      AppRoutes.productDetail,
                                      arguments: product),
                                  onAddCart: () =>
                                      cartController.addToCart(product),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Latest Products Header & Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.latest,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor: Colors.transparent,
                          labelColor: AppColors.primaryDark,
                          unselectedLabelColor: AppColors.textTertiary,
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          labelPadding: const EdgeInsets.only(right: 25),
                          padding: EdgeInsets.zero,
                          tabs: categories.map((e) => Tab(text: e)).toList(),
                          onTap: (index) {
                            productController.setCategory(categories[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Product Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Obx(
                    () {
                      if (productController.filteredProducts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                const Icon(Icons.search_off,
                                    size: 64, color: AppColors.lightGray),
                                const SizedBox(height: 16),
                                Text(
                                  "No products found",
                                  style: AppTextStyles.subtitle1
                                      .copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: productController.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              productController.filteredProducts[index];
                          final color =
                              _pastelColors[index % _pastelColors.length];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: LatestProductCard(
                                  product: product,
                                  backgroundColor: color,
                                  onTap: () => Get.toNamed(
                                      AppRoutes.productDetail,
                                      arguments: product),
                                  onAddCart: () =>
                                      cartController.addToCart(product),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final pc = productController;
    double tempMin = pc.minPrice.value;
    double tempMax = pc.maxPrice.value;
    bool tempAvailable = pc.filterAvailableOnly.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempMin = 0;
                            tempMax = 10000;
                            tempAvailable = false;
                          });
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${tempMin.round()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          )),
                      Text('₹${tempMax.round()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          )),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(tempMin, tempMax),
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.mediumGray,
                    labels: RangeLabels(
                      '₹${tempMin.round()}',
                      '₹${tempMax.round()}',
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        tempMin = values.start;
                        tempMax = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected =
                          productController.selectedCategory.value == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            productController.setCategory(cat);
                            _tabController.animateTo(categories.indexOf(cat));
                          }
                          setModalState(() {});
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: AppColors.mediumGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'In Stock Only',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Switch(
                        value: tempAvailable,
                        onChanged: (val) {
                          setModalState(() => tempAvailable = val);
                        },
                        activeTrackColor: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        pc.setFilters(
                          min: tempMin,
                          max: tempMax,
                          availableOnly: tempAvailable,
                        );
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Apply Filters${pc.activeFilterCount > 0 ? ' (${pc.activeFilterCount})' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
