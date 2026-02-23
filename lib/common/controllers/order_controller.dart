// lib/controllers/order_controller.dart

import 'package:get/get.dart';
import '../models/models.dart';
import '../../services/api_service.dart';

class OrderController extends GetxController {
  final orders = <Order>[].obs;
  final currentOrder = Rxn<Order>();
  final isLoading = false.obs;
  final orderTracking = Rxn<Map<String, dynamic>>();
  final errorMessage = ''.obs;

  Future<void> fetchOrders(String? userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (userId == null || userId.toString().isEmpty) {
        orders.value = [];
        return;
      }

      final userIdInt = int.tryParse(userId.toString());
      if (userIdInt == null) {
        orders.value = [];
        return;
      }

      final fetchedOrders = await ApiService.getUserOrders(userIdInt);

      // Merge logic: Add new orders from server, update existing ones,
      // and keep local orders that haven't reached the server yet.
      final Map<String, Order> mergedMap = {
        for (var o in orders) o.id: o,
      };

      for (var o in fetchedOrders) {
        mergedMap[o.id] = o;
      }

      final mergedList = mergedMap.values.toList();
      // Sort by latest first
      mergedList.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      orders.assignAll(mergedList);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      orders.clear();
    } catch (e) {
      errorMessage.value = 'Failed to fetch orders: ${e.toString()}';
      orders.clear();
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

      final response = await ApiService.trackOrder(orderId);
      orderTracking.value = response;

      // Update order status if it's returned in the tracking data
      if (response['status'] != null) {
        final orderIndex = orders.indexWhere((o) => o.id == orderId);
        if (orderIndex != -1) {
          final updatedOrder = orders[orderIndex];
          orders[orderIndex] = Order(
            id: updatedOrder.id,
            userId: updatedOrder.userId,
            items: updatedOrder.items,
            deliveryAddress: updatedOrder.deliveryAddress,
            deliveryType: updatedOrder.deliveryType,
            paymentMethod: updatedOrder.paymentMethod,
            status: response['status'],
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
      }
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
