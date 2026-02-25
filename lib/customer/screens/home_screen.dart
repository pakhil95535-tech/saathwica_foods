// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/product_controller.dart';
import '../../common/controllers/cart_controller.dart';
import '../../common/widgets/bottom_navigation_bar.dart';
import '../../common/widgets/product_card.dart';
import '../../common/widgets/latest_product_card.dart';
import '../widgets/customer_drawer.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../common/widgets/shared_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();
  int _currentNavIndex = 1;

  final List<String> categories = [
    'Curries',
    'Snacks',
    'Gravies',
    'Masalas',
    'Pickles',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this, initialIndex: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        Get.toNamed(AppRoutes.customerProfile);
        break;
      case 1:
        // Already on home
        break;
      case 2:
        Get.toNamed(AppRoutes.cart);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.grandTasteLogo,
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primary, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
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
      drawer: const CustomerDrawer(),
      body: RefreshIndicator(
        onRefresh: () => productController.fetchProducts(),
        child: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Area
                SizedBox(
                  height: 220, // Height for banner + overlap
                  child: Stack(
                    children: [
                      // Banner Image
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: const BoxDecoration(
                          color: AppColors.mediumGray,
                        ),
                        child: Image.asset(
                          'assets/images/home_banner.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: AppColors.darkGray),
                          ),
                        ),
                      ),

                      // Search Bar (Overlapping)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Obx(() => SharedSearchBar(
                              hintText: AppStrings.searchPlaceholder,
                              onChanged: (q) =>
                                  productController.setSearchQuery(q),
                              onFilterTap: () =>
                                  _showFilterBottomSheet(context),
                              activeFilterCount:
                                  productController.activeFilterCount,
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Recommended Items Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    AppStrings.recommendedItems, // "Recommended Items"
                    style: TextStyle(
                      fontSize: 20, // Headline 4 size
                      fontWeight: FontWeight.w800, // Extra Bold
                      color: AppColors.primaryDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Recommended Items List (Horizontal)
                SizedBox(
                  height: 260, // Increased height for new card style
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
                                width: 180, // Wider card
                                margin: const EdgeInsets.only(
                                    right: 15, bottom: 10),
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

                // Latest Section Heading & Tabs
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
                      // Tabs
                      SizedBox(
                        height: 30,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor: Colors.transparent, // No underline
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

                // Latest Grid (Vertical) with LatestProductCard
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
                      final mediaWidth = MediaQuery.of(context).size.width;
                      int crossAxisCount = 2;
                      if (mediaWidth >= 1024) {
                        crossAxisCount = 4;
                      } else if (mediaWidth >= 720) {
                        crossAxisCount = 3;
                      }
                      const horizontalPadding = 20.0;
                      const spacing = 15.0;
                      final tileWidth = (mediaWidth - (horizontalPadding * 2) - (spacing * (crossAxisCount - 1))) / crossAxisCount;
                      final tileHeight = tileWidth * 1.40;
                      final aspectRatio = tileWidth / tileHeight;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: aspectRatio,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                        ),
                        itemCount: productController.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product =
                              productController.filteredProducts[index];
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: LatestProductCard(
                                  product: product,
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
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
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

                  // Price Range
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

                  // Category Chips
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
                            // Also update the tab
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

                  // Availability Toggle
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

                  // Apply Button
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
