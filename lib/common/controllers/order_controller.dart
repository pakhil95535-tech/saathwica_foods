// lib/controllers/order_controller.dart

import 'package:get/get.dart';
import '../models/models.dart';

class OrderController extends GetxController {
  final orders = <Order>[].obs;
  final currentOrder = Rxn<Order>();
  final isLoading = false.obs;
  final orderTracking = Rxn<Map<String, dynamic>>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders({String? userId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock orders data
      final mockOrders = [
        Order(
          id: 'ORD-001',
          userId: userId ?? 'user_123',
          items: [
            CartItem(
              product: Product(
                id: '1',
                name: 'Non-veg Gravy Powder',
                description: 'Test',
                price: 200.0,
                image: 'https://via.placeholder.com/100x100',
                category: 'Masalas',
              ),
              quantity: 2,
            ),
          ],
          deliveryAddress: Address(
            fullName: 'Rama Raju',
            addressLine1: 'Sree Kuteer',
            addressLine2: 'Street 1',
            city: 'Visakhapatnam',
            state: 'Andhra Pradesh',
            pincode: '530001',
            phone: '9248200200',
          ),
          deliveryType: 'standard',
          paymentMethod: 'credit_card',
          status: 'completed',
          subtotal: 400.0,
          deliveryCharge: 50.0,
          total: 450.0,
        ),
      ];

      orders.value = mockOrders;
    } catch (e) {
      errorMessage.value = 'Failed to fetch orders: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderDetails(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      currentOrder.value = orders.firstWhereOrNull((o) => o.id == orderId);
    } catch (e) {
      errorMessage.value = 'Failed to fetch order details: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> trackOrder(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock tracking data
      orderTracking.value = {
        'orderId': orderId,
        'status': 'in_delivery',
        'stages': [
          {
            'stage': 'order_taken',
            'status': 'completed',
            'timestamp': DateTime.now()
                .subtract(const Duration(hours: 2))
                .toIso8601String(),
            'icon': 'assignment',
          },
          {
            'stage': 'preparing',
            'status': 'completed',
            'timestamp': DateTime.now()
                .subtract(const Duration(hours: 1))
                .toIso8601String(),
            'icon': 'assignment_turned_in',
          },
          {
            'stage': 'in_delivery',
            'status': 'in_progress',
            'timestamp': DateTime.now().toIso8601String(),
            'icon': 'two_wheeler',
          },
          {
            'stage': 'delivered',
            'status': 'pending',
            'timestamp': null,
            'icon': 'done_all',
          },
        ],
        'deliveryAgent': {
          'name': 'Raj Kumar',
          'phone': '9876543210',
          'location': {'latitude': 17.6869, 'longitude': 83.2185},
        },
      };
    } catch (e) {
      errorMessage.value = 'Failed to track order: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final orderIndex = orders.indexWhere((o) => o.id == orderId);
      if (orderIndex != -1) {
        // Create a new Order object with updated status
        final updatedOrder = orders[orderIndex];
        orders[orderIndex] = Order(
          id: updatedOrder.id,
          userId: updatedOrder.userId,
          items: updatedOrder.items,
          deliveryAddress: updatedOrder.deliveryAddress,
          deliveryType: updatedOrder.deliveryType,
          paymentMethod: updatedOrder.paymentMethod,
          status: 'cancelled',
          subtotal: updatedOrder.subtotal,
          deliveryCharge: updatedOrder.deliveryCharge,
          total: updatedOrder.total,
          orderDate: updatedOrder.orderDate,
          expectedDelivery: updatedOrder.expectedDelivery,
          trackingId: updatedOrder.trackingId,
          tracking: updatedOrder.tracking,
        );
        orders.refresh();
      }
    } catch (e) {
      errorMessage.value = 'Failed to cancel order: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Getters
  Order? getOrderById(String orderId) =>
      orders.firstWhereOrNull((o) => o.id == orderId);

  List<Order> get completedOrders =>
      orders.where((o) => o.status == 'completed').toList();

  List<Order> get activeOrders => orders
      .where(
        (o) => [
          'pending',
          'confirmed',
          'preparing',
          'in_delivery',
        ].contains(o.status),
      )
      .toList();

  void addOrder(Order order) {
    orders.insert(0, order);
    orders.refresh();
  }

  String getStatusDisplayText(String status) {
    switch (status) {
      case 'pending':
        return 'Order Placed';
      case 'confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Being Prepared';
      case 'in_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
