// lib/controllers/cart_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import '../../services/api_service.dart';
import '../utils/constants.dart';
import 'order_controller.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final cart = Rxn<Cart>();
  final isLoading = false.obs;
  final savedAddresses = <Address>[].obs;
  final selectedAddress = Rxn<Address>();
  final addressErrorMessage = ''.obs;
  final selectedDeliveryType = 'standard'.obs;
  final selectedPaymentMethod = Rxn<PaymentMethod>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCart();
  }

  void _initializeCart() {
    final auth = Get.find<AuthController>();
    final uid = auth.userId.isNotEmpty ? auth.userId : 'guest';
    cart.value = Cart(userId: uid, items: []);

    // Default payment method (mock for now)
    selectedPaymentMethod.value = PaymentMethod(
      id: 'pm_1',
      type: 'Visa',
      lastFour: '5496',
      cardholderName: 'User',
    );

    // Load addresses from server for this user
    fetchAddressesFromBackend();
  }

  /// Fetch saved addresses from backend via GET.
  /// If server returns addresses, use them. Otherwise start empty.
  Future<void> fetchAddressesFromBackend() async {
    try {
      isLoading.value = true;
      addressErrorMessage.value = '';
      final auth = Get.find<AuthController>();
      final userId = int.tryParse(auth.userId) ?? 0;
      if (userId <= 0) return;

      final addresses = await ApiService.getUserAddresses(userId);
      savedAddresses.assignAll(addresses);

      if (addresses.isNotEmpty) {
        // Prioritize default address, otherwise first available
        final defaultAddress = addresses.firstWhereOrNull((a) => a.isDefault);
        selectedAddress.value = defaultAddress ?? savedAddresses.first;
      } else {
        selectedAddress.value = null;
      }
    } catch (e) {
      addressErrorMessage.value =
          e.toString().replaceAll('ApiException:', '').trim();
      // Only keep local if any, but backend is truth
      if (savedAddresses.isEmpty) {
        savedAddresses.clear();
      }
    } finally {
      isLoading.value = false;
    }
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

  /// Add a new address.
  /// 1. POST to server to persist it in the database.
  /// 2. On success, add to local list and select it.
  /// 3. On failure, show the error (address did NOT reach the server).
  Future<bool> addNewAddress(Address address) async {
    try {
      isLoading.value = true;
      final auth = Get.find<AuthController>();
      final userId = int.tryParse(auth.userId) ?? 0;

      // POST to server first
      await ApiService.addAddress(userId: userId, address: address);

      // Re-fetch everything from backend to stay in sync
      await fetchAddressesFromBackend();

      // Ensure the newly added address (or at least SOME address) is selected
      if (selectedAddress.value == null && savedAddresses.isNotEmpty) {
        selectedAddress.value = savedAddresses.first;
      }

      Get.snackbar('Success', 'Address saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white);
      return true;
    } catch (e) {
      // Address did NOT reach the server — tell the user
      final msg = e.toString().replaceAll('ApiException', '').trim();
      Get.snackbar('Error', 'Failed to save address: $msg',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing address locally and on server.
  Future<bool> updateAddress(Address address) async {
    try {
      isLoading.value = true;
      final auth = Get.find<AuthController>();
      final userId = int.tryParse(auth.userId) ?? 0;

      if (userId > 0) {
        // If update fails, we should stop and show error
        await ApiService.updateAddress(userId: userId, address: address);

        // Re-fetch from backend to stay in sync
        await fetchAddressesFromBackend();

        Get.snackbar('Success', 'Address saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white);
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete an address.
  /// 1. Call DELETE on server.
  /// 2. Remove from local list.
  Future<void> deleteAddress(Address address) async {
    try {
      isLoading.value = true;

      // Try to delete from server
      final response = await ApiService.deleteAddress(address.id);

      // Re-fetch from backend to stay in sync
      await fetchAddressesFromBackend();

      Get.snackbar(
          'Success', response['message'] ?? 'Address deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<Order?> placeOrder() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (cart.value == null || cart.value!.items.isEmpty) {
        errorMessage.value = 'Cart is empty';
        return null;
      }

      if (selectedAddress.value == null) {
        errorMessage.value = 'Please add a delivery address first';
        return null;
      }

      if (selectedPaymentMethod.value == null) {
        errorMessage.value = 'Please select payment method';
        return null;
      }

      final auth = Get.find<AuthController>();
      final userId = int.tryParse(auth.userId) ?? 0;

      // Call API to create order
      Map<String, dynamic> response = {};
      try {
        if (userId > 0) {
          response = await ApiService.createOrder(
            userId: userId,
            items: cart.value!.items,
            address: selectedAddress.value!,
            totalAmount: cart.value!.total,
            deliveryCharge: cart.value!.deliveryCharge,
            paymentMethod: selectedPaymentMethod.value?.type ?? 'COD',
            userRole: auth.currentUser.value?.userType,
          );

          if (kDebugMode) {
            print('DEBUG: Create Order Response: $response');
          }
        } else {
          errorMessage.value = 'User not logged in';
          return null;
        }
      } catch (e) {
        if (kDebugMode) print('DEBUG: Place Order Error: $e');
        errorMessage.value =
            'Failed to create order on server: ${e.toString()}';
        Get.snackbar('Order Failed', errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white);
        return null;
      }

      final orderData = response['data']?['order'];
      final orderId = orderData?['order_id']?.toString() ??
          orderData?['id']?.toString() ??
          response['order_id']?.toString() ??
          response['id']?.toString();

      if (orderId == null) {
        errorMessage.value = 'Server did not return a valid order ID';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.BOTTOM);
        return null;
      }

      final order = Order(
        id: orderId,
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

      final orderController = Get.isRegistered<OrderController>()
          ? Get.find<OrderController>()
          : Get.put(OrderController());
      orderController.addOrder(order);

      // Add a small delay to allow backend to process the order
      // before we refresh the list
      await Future.delayed(const Duration(seconds: 2));

      // Immediately refresh orders from backend to ensure real-time consistency
      orderController.fetchOrders(userId.toString());

      clearCart();

      return order;
    } catch (e) {
      errorMessage.value = 'Failed to place order: ${e.toString()}';
      return null;
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
