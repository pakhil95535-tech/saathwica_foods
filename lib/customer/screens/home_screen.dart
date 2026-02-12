// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/controllers/product_controller.dart';
import '../../common/controllers/cart_controller.dart';
import '../../common/widgets/bottom_navigation_bar.dart';
import '../../common/widgets/product_card.dart';
import '../../common/widgets/latest_product_card.dart';
import '../../common/widgets/custom_drawer.dart';
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
    'Pickles'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
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
        Get.toNamed('/profile');
        break;
      case 1:
        // Already on home
        break;
      case 2:
        Get.toNamed('/cart');
        break;
    }
  }

  final List<Color> _pastelColors = [
    const Color(0xFFFFF9E6), // Cream
    const Color(0xFFFCE4EC), // Pink
    const Color(0xFFF3E5F5), // Purple
    const Color(0xFFE8F5E9), // Green
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.white, size: 28),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket, // Solid icon
                    color: AppColors.white,
                    size: 28),
                Text(
                  AppStrings.myBasket,
                  style: TextStyle(fontSize: 10, color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () => productController.fetchProducts(),
        child: AnimationLimiter(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
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
                        const Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: SharedSearchBar(
                            hintText: AppStrings.searchPlaceholder,
                          ),
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
                                    style: AppTextStyles.subtitle1.copyWith(
                                        color: AppColors.textSecondary),
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
                            childAspectRatio:
                                0.85, // Adjust for square-ish look
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: productController.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product =
                                productController.filteredProducts[index];
                            // Cycle through pastel colors
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
    );
  }
}
