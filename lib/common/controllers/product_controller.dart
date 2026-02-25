// Product controller (development: uses local assets only)
import 'package:get/get.dart';
import '../models/models.dart';

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

  void _loadMockProducts() {
    products.value = [
  Product(
    id: 'p1',
    name: 'Mango Pickle Mix Powder',
    description: 'A traditional and aromatic spice blend crafted to prepare authentic mango pickle at home.Made with carefully selected premium spices to deliver the perfect balance of spice, tanginess, and rich flavor.Enhances the natural taste of raw mango pieces while giving a homemade pickle aroma.Easy to use – simply mix with fresh mango pieces and oil for a delicious, traditional pickle.Free from artificial colors and preservatives.Perfect to enjoy with hot rice, dosa, chapati, curd rice, or any Indian meal.',
    price: 129.0,
    originalPrice: 150.0,
    discountPercentage: 10,
    image: 'assets/images/Mango pickle mix powder.png',
    images: ['assets/images/Mango pickle mix powder.png','assets/images/WhatsApp Image 2026-02-20 at 20.11.42 (1).jpeg'],
    category: 'Pickles',
    unit: '500g',
  ),

  Product(
    id: 'p2',
    name: 'Non Veg Fry Powder',
    description: 'A bold and flavorful spice blend specially crafted for perfectly seasoned non-veg fries.Made with a balanced mix of premium spices to enhance the natural taste of chicken, mutton, fish, or prawns.Delivers a rich aroma, vibrant color, and authentic homemade flavor in every bite.Ideal for shallow fry, deep fry, or pan roast preparations.Easy to use – simply marinate with ginger-garlic paste and salt, coat evenly, and fry to perfection.Free from artificial colors and preservatives.Perfect for serving as a starter, side dish, or party special.',
    price: 249.0,
    originalPrice: 300.0,
    discountPercentage: 10,
    image: 'assets/images/Non veg Fry Powder.png',
    images: ['assets/images/Non veg Fry Powder.png','assets/images/WhatsApp Image 2026-02-20 at 20.11.52 (2).jpeg'],
    category: 'Masalas',
    unit: '500g',
  ),

  Product(
    id: 'p3',
    name: 'Chicken Pickle Mix Powder',
    description: 'Perfect blend for chicken pickle.A rich and aromatic spice blend specially crafted to prepare authentic chicken pickle at home.Made with carefully selected premium spices to deliver the perfect balance of heat, tanginess, and bold flavor.Enhances the natural taste of chicken while giving a traditional homemade pickle aroma.Easy to use – simply mix with cooked chicken pieces and oil to create a delicious, long-lasting pickle.Free from artificial colors and preservatives.Perfect to enjoy with hot rice, chapati, dosa, or as a spicy side dish for any meal.',
    price: 210.0,
    originalPrice: 240.0,
    discountPercentage: 12,
    image: 'assets/images/Chickek Pickle Mix Powder.png',
    images: ['assets/images/Chickek Pickle Mix Powder.png','assets/images/WhatsApp Image 2026-02-20 at 20.11.52.jpeg'],
    category: 'Pickles',
    unit: '500g',
  ),

  Product(
    id: 'p4',
    name: 'Cher Taste Ghee Biryani Kit',
    description: 'Complete kit for hotel-style biryani.A complete and aromatic biryani kit crafted to prepare rich and flavorful ghee biryani with ease.Carefully blended premium spices deliver an authentic taste, royal aroma, and perfect balance of flavors.Infused with the richness of ghee to enhance every grain of rice with traditional biryani essence.Ideal for preparing chicken, mutton, or veg ghee biryani at home.',
    price: 299.0,
    originalPrice: 349.0,
    discountPercentage: 14,
    image: 'assets/images/Cher Taste Ghee Biryani Kit.png',
    images: ['assets/images/Cher Taste Ghee Biryani Kit.png','assets/images/WhatsApp Image 2026-02-20 at 20.11.52 (1).jpeg'],
    category: 'Biryani Kits',
    unit: '1kg',
  ),

  Product(
    id: 'p5',
    name: 'Non-Veg Gravy Powder',
    description: 'Rich spice mix for meat gravies.A rich and aromatic spice blend specially crafted to prepare delicious non-veg gravies with authentic taste.Made from carefully selected premium spices to deliver a perfect balance of flavor, color, and aroma.Enhances the natural taste of chicken, mutton, fish, or prawns with a smooth and flavorful gravy base.Free from artificial colors and preservatives.Perfect for everyday meals and special occasions.',
    price: 189.0,
    originalPrice: 220.0,
    discountPercentage: 13,
    image: 'assets/images/Non veg Fry Powder.png',
    images: ['assets/images/Non veg Fry Powder.png','assets/images/non_veg_gravy_info.jpg'],
    category: 'Masalas',
    unit: 'per unit',
  ),

  Product(
    id: 'p6',
    name: 'Prawns pickle mix Powder',
    description: 'A flavorful and aromatic spice blend specially crafted for preparing authentic and delicious prawns pickle at home.A rich and aromatic spice blend specially formulated to prepare authentic prawns pickle with ease.Made from carefully selected premium spices to deliver a perfect balance of heat, tanginess, and depth of flavor.Enhances the natural taste of prawns while giving a traditional homemade pickle aroma.',
    price: 199.0,
    originalPrice: 230.0,
    discountPercentage: 14,
    image: 'assets/images/Prawns pickle mix Powder.png',
    images: ['assets/images/Prawns pickle mix Powder.png','assets/images/PPMP.jpeg'],
    category: 'Masalas',
    unit: 'per unit',
  ),

  Product(
    id: 'p7',
    name: 'Cashew & Poppy Non Gravy Powder',
    description: 'Cashew & Poppy Non Gravy Powder is a rich and aromatic spice blend crafted to prepare creamy and flavorful non-veg gravies with ease. Made with premium-quality cashew and poppy seeds along with carefully selected spices, it delivers a smooth texture, mild sweetness, and authentic taste. This blend enhances the richness of chicken, mutton, or other non-veg dishes, giving them a restaurant-style finish at home. Easy to use and perfectly balanced in flavor, it helps create thick, delicious gravies that pair wonderfully with rice, roti, chapati, or biryani. Free from artificial colors and preservatives.',
    price: 179.0,
    originalPrice: 210.0,
    discountPercentage: 15,
    image: 'assets/images/Cashew & Poppy Non Gravy Powder.png',
    images: ['assets/images/Cashew & Poppy Non Gravy Powder.png','assets/images/WhatsApp Image 2026-02-20 at 20.11.52.jpeg'],
    category: 'Masalas',
    unit: 'per unit',
  ),
  Product(
    id: 'p8',
    name: 'Cashew & Poppy Non Gravy Powder',
    description: 'Cashew & Poppy Non Gravy Powder is a rich and aromatic spice blend crafted to prepare creamy and flavorful non-veg gravies with ease. Made with premium-quality cashew and poppy seeds along with carefully selected spices, it delivers a smooth texture, mild sweetness, and authentic taste. This blend enhances the richness of chicken, mutton, or other non-veg dishes, giving them a restaurant-style finish at home. Easy to use and perfectly balanced in flavor, it helps create thick, delicious gravies that pair wonderfully with rice, roti, chapati, or biryani. Free from artificial colors and preservatives.',
    price: 179.0,
    originalPrice: 210.0,
    discountPercentage: 15,
    image: 'assets/images/Cashew & Poppy Non Gravy Powder.png',
    images: ['assets/images/Cashew & Poppy Non Gravy Powder.png','assets/images/WhatsApp Image 2026-02-20 at 20.11.52.jpeg'],
    category: 'Masalas',
    unit: 'per unit',
  ),
];

    filteredProducts.value =
        products.where((p) => p.category == selectedCategory.value).toList();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    _loadMockProducts();
    isLoading.value = false;
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
