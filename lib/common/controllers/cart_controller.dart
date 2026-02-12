// lib/controllers/cart_controller.dart

import 'package:get/get.dart';
import '../models/models.dart';
import 'order_controller.dart';

class CartController extends GetxController {
  final cart = Rxn<Cart>();
  final isLoading = false.obs;
  final selectedAddress = Rxn<Address>();
  final selectedDeliveryType = 'standard'.obs;
  final selectedPaymentMethod = Rxn<PaymentMethod>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCart();
  }

  void _initializeCart() {
    cart.value = Cart(
      userId: 'user_123', // TODO: Get from auth controller
      items: [],
    );

    // Initialize with mock data to match UI and prevent validation errors
    selectedAddress.value = Address(
      fullName: 'Rama raju',
      addressLine1: 'sree kuteer',
      addressLine2: '',
      city: 'Visakhapatnam',
      state: 'andhra pradesh',
      pincode: '530001',
      phone: '+91 9248 200 200',
    );

    selectedPaymentMethod.value = PaymentMethod(
      id: 'pm_1',
      type: 'Visa',
      lastFour: '5496',
      cardholderName: 'Rama raju',
    );
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      if (cart.value == null) return;

      final existingItem = cart.value!.items.firstWhereOrNull(
        (item) => item.product.id == product.id,
      );

      if (existingItem != null) {
        existingItem.quantity += quantity;
      } else {
        cart.value!.items.add(CartItem(product: product, quantity: quantity));
      }

      cart.refresh();
    } catch (e) {
      errorMessage.value = 'Failed to add product to cart: ${e.toString()}';
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      if (cart.value == null) return;

      cart.value!.items.removeWhere((item) => item.product.id == productId);
      cart.refresh();
    } catch (e) {
      errorMessage.value =
          'Failed to remove product from cart: ${e.toString()}';
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      if (cart.value == null || quantity <= 0) return;

      final item = cart.value!.items.firstWhereOrNull(
        (item) => item.product.id == productId,
      );
      if (item != null) {
        item.quantity = quantity;
        cart.refresh();
      }
    } catch (e) {
      errorMessage.value = 'Failed to update quantity: ${e.toString()}';
    }
  }

  void clearCart() {
    if (cart.value != null) {
      cart.value!.items.clear();
      cart.refresh();
    }
  }

  void setDeliveryType(String type) {
    selectedDeliveryType.value = type;
    _updateDeliveryCharge();
  }

  void _updateDeliveryCharge() {
    if (cart.value == null) return;

    double newDeliveryCharge;
    switch (selectedDeliveryType.value) {
      case 'express':
        newDeliveryCharge = 100.0;
        break;
      case 'schedule':
        newDeliveryCharge = 75.0;
        break;
      default:
        newDeliveryCharge = 50.0;
    }

    // Recreate cart with new delivery charge since it's a final field
    cart.value = Cart(
      userId: cart.value!.userId,
      items: cart.value!.items,
      deliveryCharge: newDeliveryCharge,
    );
  }

  void setSelectedAddress(Address address) {
    selectedAddress.value = address;
  }

  void setSelectedPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  Future<bool> placeOrder() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (cart.value == null || cart.value!.items.isEmpty) {
        errorMessage.value = 'Cart is empty';
        return false;
      }

      if (selectedAddress.value == null) {
        errorMessage.value = 'Please select delivery address';
        return false;
      }

      if (selectedPaymentMethod.value == null) {
        errorMessage.value = 'Please select payment method';
        return false;
      }

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Create order
      final order = Order(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        userId: cart.value!.userId,
        items: List.from(cart.value!.items),
        deliveryAddress: selectedAddress.value!,
        deliveryType: selectedDeliveryType.value,
        paymentMethod: selectedPaymentMethod.value?.type ?? 'Cash',
        subtotal: cart.value!.subtotal,
        deliveryCharge: cart.value!.deliveryCharge,
        total: cart.value!.total,
        orderDate: DateTime.now(),
        status: 'confirmed',
      );

      // Add order to OrderController
      final orderController = Get.isRegistered<OrderController>()
          ? Get.find<OrderController>()
          : Get.put(OrderController());
      orderController.addOrder(order);

      // Clear cart after successful order
      clearCart();

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to place order: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Getters
  int get cartItemCount => cart.value?.itemCount ?? 0;
  int get totalQuantity => cart.value?.totalQuantity ?? 0;
  double get subtotal => cart.value?.subtotal ?? 0.0;
  double get deliveryCharge => cart.value?.deliveryCharge ?? 0.0;
  double get total => cart.value?.total ?? 0.0;
  bool get isCartEmpty => cart.value?.items.isEmpty ?? true;
  List<CartItem> get cartItems => cart.value?.items ?? [];
}
