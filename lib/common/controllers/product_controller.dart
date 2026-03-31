// Product controller
import 'package:get/get.dart';
import '../models/models.dart';
import '../../services/api_service.dart';
import 'auth_controller.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString selectedCategory = 'Masalas'.obs;
  final RxString searchQuery = ''.obs;
  final RxSet<String> wishlistIds = <String>{}.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Filter state
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;
  final RxBool filterAvailableOnly = false.obs;
  final RxString filterCategory = ''.obs; // empty = all categories

  int get activeFilterCount {
    int count = 0;
    if (minPrice.value > 0) count++;
    if (maxPrice.value < 10000) count++;
    if (filterAvailableOnly.value) count++;
    if (filterCategory.value.isNotEmpty) count++;
    return count;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void _applyRolePricing(List<Product> list) {
    String role = 'customer';
    if (Get.isRegistered<AuthController>()) {
      final r = Get.find<AuthController>().currentUser.value?.userType;
      if (r != null && r.isNotEmpty) {
        role = r.toLowerCase();
      }
    }
    for (final p in list) {
      double displayPrice = p.price4 ?? p.price;
      if (role == 'admin' || role == 'superadmin') {
        displayPrice = p.price1 ?? p.price;
      } else if (role == 'employee') {
        displayPrice = p.price;
      } else if (role == 'supervisor') {
        displayPrice = p.price3 ?? p.price;
      } else {
        displayPrice = p.price4 ?? p.price;
      }
      final idx = list.indexOf(p);
      list[idx] = Product(
        id: p.id,
        name: p.name,
        description: p.description,
        price: displayPrice,
        originalPrice: p.originalPrice,
        discountPercentage: p.discountPercentage,
        image: p.image,
        images: p.images,
        category: p.category,
        unit: p.unit,
        rating: p.rating,
        reviewCount: p.reviewCount,
        isAvailable: p.isAvailable,
        sku: p.sku,
        size: p.size,
        tags: p.tags,
        instructions: p.instructions,
        price1: p.price1,
        price2: p.price2,
        price3: p.price3,
        price4: p.price4,
        createdAt: p.createdAt,
      );
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await ApiService.fetchProducts();
      _applyRolePricing(list);
      products.value = list;
      _filterProducts(); // Ensure initial filtering
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    _filterProducts();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _filterProducts();
  }

  void _filterProducts() {
    var result = products.where((p) => p.category == selectedCategory.value);

    if (searchQuery.value.isNotEmpty) {
      result = result.where((p) =>
          p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p.description
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()));
    }

    // Apply price filters
    if (minPrice.value > 0) {
      result = result.where((p) => p.price >= minPrice.value);
    }
    if (maxPrice.value < 10000) {
      result = result.where((p) => p.price <= maxPrice.value);
    }

    // Apply availability filter
    if (filterAvailableOnly.value) {
      result = result.where((p) => p.isAvailable);
    }

    filteredProducts.value = result.toList();
  }

  void setFilters({
    double? min,
    double? max,
    bool? availableOnly,
    String? category,
  }) {
    if (min != null) minPrice.value = min;
    if (max != null) maxPrice.value = max;
    if (availableOnly != null) filterAvailableOnly.value = availableOnly;
    if (category != null) filterCategory.value = category;
    _filterProducts();
  }

  void clearFilters() {
    minPrice.value = 0.0;
    maxPrice.value = 10000.0;
    filterAvailableOnly.value = false;
    filterCategory.value = '';
    _filterProducts();
  }

  void toggleWishlist(String productId) {
    if (wishlistIds.contains(productId)) {
      wishlistIds.remove(productId);
    } else {
      wishlistIds.add(productId);
    }
  }

  bool isInWishlist(String productId) {
    return wishlistIds.contains(productId);
  }

  Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
