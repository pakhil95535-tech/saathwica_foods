// lib/controllers/product_controller.dart

import 'package:get/get.dart';
import '../models/models.dart';
import '../../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString selectedCategory = 'Curries'.obs;
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
    // Mock product data without backend - Food focused
    products.value = [
      // Curries Category
      Product(
        id: '1',
        name: 'Chicken Fry',
        description:
            'Telugu-style spicy chicken fry with authentic masala blend. Our Chicken Fry Masala Powder is a perfect blend of hand-picked spices that gives your chicken a rich aroma and irresistible taste.',
        price: 235.0,
        originalPrice: 260.0,
        discountPercentage: 10.0,
        image: 'assets/images/chicken_fry_pan.png',
        images: [
          'assets/images/chicken_fry_pan.png',
          'https://images.unsplash.com/photo-1626602411112-10742f9a3af8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Curries',
        unit: 'per unit',
        instructions: [
          'పాన్లో ఆయిల్ వేడి చేయండి.',
          'ఉల్లిపాయలు 100g + పచ్చిమిర్చి 50g వేసి స్వర్ణంగా వేయించండి.',
          'తర్వాత అల్లం వెల్లుల్లి పేస్ట్ 100g వేసి పచ్చివాసన పోయే వరకు వేయించండి.',
          'ఇప్పుడు చికెన్ ముక్కలు వేసి బాగా కలిపి పూర్తిగా ఉడికే వరకు మగ్గనివ్వండి.',
          'చికెన్ ఉడికిన తర్వాత 50 గ్రాములు శ్రీ సాత్విక చికెన్ ఫ్రై పౌడర్ వేసి కలపండి',
          'మూడు నాలుగు నిమిషాలకు ఆయిల్ పైకి తేలేంతవరకు వేయించండి అంతే! రెస్టారెంట్ స్టైల్ చికెన్ ఫ్రై రెడీ!',
        ],
      ),
      Product(
        id: '2',
        name: 'Chicken Curry',
        description:
            'Traditional Telugu chicken curry with rich gravy. Slow-cooked with aromatic spices, onions, tomatoes, and our special curry masala blend.',
        price: 250.0,
        originalPrice: 300.0,
        discountPercentage: 16.6,
        image:
            'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Curries',
        unit: 'per unit',
        instructions: [
          'చికెన్ ముక్కలను శుభ్రంగా కడిగి, ఉప్పు, పసుపు వేసి పక్కన పెట్టండి.',
          'పాన్లో నూనె వేడి చేసి, ఉల్లిపాయలు, టమాటాలు వేసి వేయించండి.',
          'అల్లం వెల్లుల్లి పేస్ట్ వేసి బాగా వేయించండి.',
          'చికెన్ ముక్కలు వేసి, కర్రీ పౌడర్ కలిపి ఉడికించండి.',
          'నీరు కలిపి గ్రేవీ రావాలంటే మరింత ఉడికించండి. రుచికరమైన చికెన్ కర్రీ రెడీ!',
        ],
      ),
      Product(
        id: '3',
        name: 'Mutton Curry',
        description:
            'Slow-cooked mutton curry with aromatic spices. Tender mutton pieces cooked in a rich, flavorful gravy with traditional Andhra spices.',
        price: 350.0,
        originalPrice: 400.0,
        discountPercentage: 12.5,
        image:
            'https://images.unsplash.com/photo-1547928576-965be7f5f6a6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1547928576-965be7f5f6a6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Curries',
        unit: 'per unit',
      ),
      Product(
        id: '4',
        name: 'Gongura Chicken',
        description:
            'Tangy Andhra-style chicken with sorrel leaves (gongura). Fresh gongura leaves added to chicken for a unique sour and spicy kick.',
        price: 280.0,
        originalPrice: 320.0,
        discountPercentage: 12.5,
        image:
            'https://images.unsplash.com/photo-1610057099443-fde8c4d29f3d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1610057099443-fde8c4d29f3d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Curries',
        unit: 'per unit',
      ),
      Product(
        id: '5',
        name: 'Royyala Iguru',
        description:
            'Spicy prawn curry with coastal flavors. Fresh prawns cooked until tender in a medium thick gravy with traditional spices.',
        price: 380.0,
        originalPrice: 420.0,
        discountPercentage: 9.5,
        image:
            'https://images.unsplash.com/photo-1559742811-822873691df8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1559742811-822873691df8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Curries',
        unit: 'per unit',
      ),

      // Masalas Category
      Product(
        id: '6',
        name: 'Non-veg Gravy Powder',
        description:
            'Rich spice mix for all meat gravies. Blended with coriander, cumin, cloves, and cinnamon for a perfect restaurant flavor.',
        price: 235.0,
        originalPrice: 250.0,
        discountPercentage: 6.0,
        image: 'assets/images/non_veg_gravy_bottle.png',
        images: [
          'assets/images/non_veg_gravy_bottle.png',
          'assets/images/non_veg_gravy_info.jpg',
          'assets/images/non_veg_process.jpg',
        ],
        category: 'Masalas',
        unit: 'per unit',
      ),
      Product(
        id: '7',
        name: 'Non-Veg Pickle Powder',
        description:
            'Special spice mix for meat pickles. Perfectly balance spiciness and tanginess for chicken and mutton pickles.',
        price: 235.0,
        originalPrice: 250.0,
        discountPercentage: 6.0,
        image: 'assets/images/non_veg_pickle_info.jpg',
        images: [
          'assets/images/non_veg_pickle_info.jpg',
          'https://images.unsplash.com/photo-1591814468924-cafb5d1232e1?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Masalas',
        unit: 'per unit',
      ),
      Product(
        id: '8',
        name: 'Biryani Masala',
        description:
            'Secret blend for perfect biryani every time. Highly aromatic and adds a rich gold color to your rice dishes.',
        price: 199.0,
        originalPrice: 250.0,
        discountPercentage: 20.4,
        image:
            'https://images.unsplash.com/photo-1589302168068-964664d93dc0?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Masalas',
        unit: 'per unit',
      ),

      // Snacks Category
      Product(
        id: '9',
        name: 'Chicken 65',
        description:
            'Spicy, deep-fried chicken appetizer. This classic South Indian snack is marinated with ginger-garlic and special spices.',
        price: 220.0,
        originalPrice: 250.0,
        discountPercentage: 12.0,
        image:
            'https://images.unsplash.com/photo-1626082927389-d52b83b46984?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1626082927389-d52b83b46984?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Snacks',
        unit: 'per unit',
      ),
      Product(
        id: '10',
        name: 'Mirchi Bajji Mix',
        description:
            'Traditional Andhra monsoon snack mix. Ready-to-fry masala for spicy chili fritters.',
        price: 150.0,
        originalPrice: 180.0,
        discountPercentage: 16.6,
        image:
            'https://images.unsplash.com/photo-1601050690597-df0568f70950?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Snacks',
        unit: 'per unit',
      ),

      // Pickles Category
      Product(
        id: '11',
        name: 'Gongura Pickle',
        description:
            'Tangy sorrel leaves pickle with garlic. Authentic Andhra style homemade pickle with zero preservatives.',
        price: 180.0,
        originalPrice: 200.0,
        discountPercentage: 10.0,
        image:
            'https://images.unsplash.com/photo-1601050690117-94f5f6fa8bd7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1601050690117-94f5f6fa8bd7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Pickles',
        unit: '250g',
      ),
      Product(
        id: '12',
        name: 'Mango Pickle',
        description:
            'Spicy and tangy sun-dried mango pickle. Made with hand-picked green mangoes and pure mustard oil.',
        price: 199.0,
        originalPrice: 220.0,
        discountPercentage: 9.5,
        image:
            'https://images.unsplash.com/photo-1599307767316-77f6b7d30f5b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1599307767316-77f6b7d30f5b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Pickles',
        unit: '250g',
      ),

      // Gravies Category
      Product(
        id: '13',
        name: 'Tomato Curry Base',
        description:
            'Rich tomato and onion based curry starter. Saves cooking time without compromising on authentic taste.',
        price: 160.0,
        originalPrice: 200.0,
        discountPercentage: 20.0,
        image:
            'https://images.unsplash.com/photo-1596797038530-2c107229654b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1596797038530-2c107229654b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Gravies',
        unit: 'per unit',
      ),

      // Personal Care Category (Mock for Shampoo)
      Product(
        id: '14',
        name: 'Siya Herbal Shampoo',
        description:
            'Herbal Shampoo With Extra Conditioner. Indications - Premature Graying, Falling Hair, Split Ends.',
        price: 180.0,
        originalPrice: 200.0,
        discountPercentage: 10.0,
        image:
            'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        images: [
          'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        ],
        category: 'Personal Care',
        unit: '100ml',
      ),
    ];

    filteredProducts.value =
        products.where((p) => p.category == selectedCategory.value).toList();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetched = await ApiService.fetchProducts();
      products.value = fetched;
      _filterProducts();
    } catch (e) {
      errorMessage.value = 'Failed to load products: ${e.toString()}';
      if (!Get.isSnackbarOpen) {
        Get.snackbar('Error', errorMessage.value);
      }
      _loadMockProducts();
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
