// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../common/utils/constants.dart';
import '../common/models/models.dart';

class ApiService {
  static String get baseUrl => AppEndpoints.baseUrl;
  static String? authToken;
  static Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (authToken != null && authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    // Added for ngrok support as per user requirement or best practice
    headers['ngrok-skip-browser-warning'] = 'true';
    return headers;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final text = response.body;
    dynamic body;
    try {
      body = text.isNotEmpty ? jsonDecode(text) : null;
    } catch (e) {
      // If response is not JSON (e.g., HTML error page), treat it as an error
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successful status but invalid JSON?
        return <String, dynamic>{
          'message': 'Success but invalid response format'
        };
      }
      throw ApiException(
          'Invalid server response (Status: ${response.statusCode})',
          response.statusCode);
    }

    if (kDebugMode) {
      print('API Response (${response.statusCode}): ${response.request?.url}');
      print('Body: $text');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body == null) return <String, dynamic>{};
      return body is Map<String, dynamic>
          ? body
          : <String, dynamic>{'data': body};
    }
    String message;
    if (body is Map) {
      message = (body['message'] ?? 'Error').toString();
    } else {
      switch (response.statusCode) {
        case 400:
          message = 'Bad request';
          break;
        case 401:
          message = 'Unauthorized';
          break;
        case 404:
          message = 'Not found';
          break;
        default:
          message = 'Server error';
      }
    }
    throw ApiException(message, response.statusCode);
  }

  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    required String pincode,
    required String address1,
    required String? address2,
    required String referralId,
    required String password,
    String role = 'customer',
    String referredBy = '', // Changed from int to String
    double earnings = 0.0,
  }) async {
    // Determine URL based on role
    Uri url;
    if (role.toLowerCase() == 'customer') {
      url = Uri.parse(AppEndpoints.createCustomer);
    } else if (role.toLowerCase() == 'employee') {
      url = Uri.parse(AppEndpoints.createEmployee);
    } else if (role.toLowerCase() == 'supervisor') {
      url = Uri.parse(AppEndpoints.createSupervisor);
    } else if (role.toLowerCase() == 'admin' ||
        role.toLowerCase() == 'superadmin') {
      url = Uri.parse(AppEndpoints.adminSignup);
    } else {
      url = Uri.parse(AppEndpoints.createUser);
    }

    final payload = <String, dynamic>{
      'name': name,
      'phone': phone,
      'pincode': pincode,
      'address1': address1,
      'address2': address2,
      'password': password,
    };

    if (referralId.isNotEmpty || referredBy.isNotEmpty) {
      payload['reffered_by'] = referralId.isNotEmpty ? referralId : referredBy;
    }

    final body = jsonEncode(payload);
    try {
      final response = await http
          .post(url, headers: _getHeaders(), body: body)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse(AppEndpoints.loginUser);
    final body = jsonEncode({
      'phone': phone,
      'password': password,
    });
    try {
      final response = await http
          .post(url, headers: _getHeaders(), body: body)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  static Future<Map<String, dynamic>> getUserDetails(int userId) async {
    final url = Uri.parse('${AppEndpoints.userDetails}/$userId');
    try {
      final response = await http
          .get(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  /// Fetch user orders from backend (GET /user/:userId)
  /// Note: The response is expected to contain order data.
  /// If the current /user/:id endpoint only returns user profile, we may need to
  /// check if there's a nested 'orders' field or if a different endpoint is needed.
  /// Based on verified response `{"success":true,"count":0,"data":[]}`, it returns a list in data.
  static Future<List<Order>> getUserOrders(int userId) async {
    final url = Uri.parse('${AppEndpoints.userOrders}/$userId');
    if (kDebugMode) {
      print('DEBUG: Fetching orders for userId: $userId');
      print('DEBUG: URL: $url');
    }

    try {
      final response = await http
          .get(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('DEBUG: Orders Response Status: ${response.statusCode}');
        print('DEBUG: Orders Response Body: ${response.body}');
      }

      if (response.statusCode == 404) {
        // Backend returns 404 if no orders are found, but we should treat it as an empty list
        return [];
      }

      final body = _handleResponse(response);
      final list = body['data'] ?? body['orders'] ?? (body is List ? body : []);

      if (list is List) {
        return list
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('DEBUG: getUserOrders Error: $e');
      if (e is ApiException) {
        if (e.statusCode == 404) return [];
        rethrow;
      }
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  /// Fetch saved addresses for a user from backend (GET /get-addresses/:userId).
  static Future<List<Address>> getUserAddresses(int userId) async {
    final url = Uri.parse('${AppEndpoints.getUserAddresses}/$userId');
    try {
      final response = await http
          .get(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 404) {
        // 404 is a valid "No addresses found" state
        return [];
      }

      final body = _handleResponse(response);
      final list = body['data'] ?? body['addresses'] ?? body;

      if (list is List) {
        return list
            .map((e) => Address.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // Fallback: If get-addresses is empty, try fetch from user details as backup
      try {
        final userDetails = await getUserDetails(userId);
        final data = userDetails['data'] ?? userDetails['user'] ?? userDetails;

        if (data != null &&
            data['address'] != null &&
            data['address'].toString().isNotEmpty) {
          final address = Address(
            id: data['user_id']?.toString() ??
                data['id']?.toString() ??
                userId.toString(),
            fullName: data['name'] ?? '',
            phone: data['phone'] ?? '',
            pincode: data['pincode'] ?? '',
            addressLine1: data['address'] ?? '',
            addressLine2: data['address2'] ?? '',
            hNo: data['h_no'] ?? '',
            street: data['street'] ?? '',
            city: data['city'] ?? 'Hyderabad',
            state: data['state'] ?? 'Telangana',
            isDefault: true,
          );
          return [address];
        }
      } catch (_) {}

      return [];
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  /// Add address — POST to server. Throws on failure so caller can handle.
  static Future<Map<String, dynamic>> addAddress({
    required int userId,
    required Address address,
    int? orderId,
  }) async {
    final apiPayload = {
      'user_id': userId,
      if (orderId != null) 'order_id': orderId,
      if (address.id.isNotEmpty && int.tryParse(address.id) != null)
        'address_id': address.id,
      'name': address.fullName,
      'h_no': address.hNo,
      'street': address.street,
      'address': address.addressLine1,
      'pincode': address.pincode,
      'phone': address.phone,
      'city': address.city,
      'state': address.state,
    };

    try {
      final url = Uri.parse(AppEndpoints.addAddress);
      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(apiPayload))
          .timeout(const Duration(seconds: 15));

      final body = _handleResponse(response);
      // Ensure we return a success flag as requested by user
      return {
        'success': true,
        'message': body['message'] ?? 'Address added successfully',
        ...body,
      };
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  /// Update address — Use add-address logic if no specific update endpoint.
  static Future<Map<String, dynamic>> updateAddress({
    required int userId,
    required Address address,
  }) async {
    // Since PUT /user/update-address returns 404, fallback to add-address (POST)
    // which likely upserts/overwrites user's address.
    return addAddress(userId: userId, address: address);
  }

  /// Track an order by its ID.
  static Future<Map<String, dynamic>> trackOrder(String orderId) async {
    try {
      final url = Uri.parse('${AppEndpoints.tracking}/$orderId');
      final response = await http
          .get(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  /// Delete an address by its ID.
  static Future<Map<String, dynamic>> deleteAddress(String addressId) async {
    final url = Uri.parse('${AppEndpoints.deleteAddress}/$addressId');
    if (kDebugMode) {
      print('DEBUG: Deleting addressId: $addressId');
      print('DEBUG: URL: $url');
    }

    try {
      final response = await http
          .delete(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('DEBUG: Delete Address Status: ${response.statusCode}');
        print('DEBUG: Delete Address Body: ${response.body}');
      }

      final body = _handleResponse(response);
      return {
        'success': true,
        'message': body['message'] ?? 'Address deleted successfully',
      };
    } catch (e) {
      if (kDebugMode) print('DEBUG: deleteAddress Error: $e');
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  static Future<Map<String, dynamic>> createOrder({
    required int userId,
    required List<CartItem> items,
    required Address address,
    required double totalAmount,
    required double deliveryCharge,
    String paymentMethod = 'COD',
    String? userRole,
  }) async {
    final url = Uri.parse(AppEndpoints.createOrder);

    // Construct payload for order creation
    // This is a guess based on standard e-commerce practices as no payload was provided for order creation
    final payload = {
      'user_id': userId,
      'role': userRole ?? 'customer',
      'items': items
          .map((item) => {
                'pr_id': item.product.id,
                'quantity': item.quantity,
                'price': item.product.price,
              })
          .toList(),
      'amount': totalAmount - deliveryCharge,
      'delivery_fee': deliveryCharge,
      'total_amount': totalAmount,
      'payment_mode': paymentMethod,
      'address': {
        'user_id': userId,
        'name': address.fullName,
        'h_no': address.hNo,
        'street': address.street,
        'address': address.addressLine1,
        'pincode': address.pincode,
        'phone': address.phone,
      }
    };

    if (kDebugMode) {
      print('DEBUG: Create Order URL: $url');
      print('DEBUG: Create Order Payload: ${jsonEncode(payload)}');
    }

    try {
      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(payload))
          .timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('DEBUG: Create Order Response Status: ${response.statusCode}');
        print('DEBUG: Create Order Response Body: ${response.body}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProductsRaw() async {
    final primaryUrl = Uri.parse(AppEndpoints.fetchProducts);
    final headers = {
      ..._getHeaders(),
      'ngrok-skip-browser-warning': 'true',
      'User-Agent': 'saathwica-app',
    };
    try {
      final res = await http.get(primaryUrl, headers: headers).timeout(
            const Duration(seconds: 20),
          );
      return _extractProductsList(res);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }

  static List<Map<String, dynamic>> _extractProductsList(http.Response res) {
    final dynamic body =
        res.body.isNotEmpty ? jsonDecode(res.body) : <String, dynamic>{};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (body is Map<String, dynamic>) {
        final data = body['data'] ?? body['products'] ?? body['items'];
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      } else if (body is List) {
        return body.cast<Map<String, dynamic>>();
      }
      return <Map<String, dynamic>>[];
    }
    String message = 'Server error';
    if (body is Map && body['message'] != null) {
      message = body['message'].toString();
    }
    throw ApiException(message, res.statusCode);
  }

  static Future<List<Product>> fetchProducts() async {
    final raw = await fetchProductsRaw();
    final List<Product> list = [];
    for (var i = 0; i < raw.length; i++) {
      final item = raw[i];
      final id =
          (item['id'] ?? item['product_id'] ?? item['pr_id'] ?? 'prod_$i')
              .toString();
      final name =
          (item['name'] ?? item['product_name'] ?? 'Product').toString();
      final description =
          (item['description'] ?? item['desc'] ?? item['about'] ?? '')
              .toString();

      // Price Logic — safely parse strings or nums
      final sellingPriceNum =
          (item['selling_price'] ?? item['price'] ?? item['mrp'] ?? 0);
      final price = (sellingPriceNum is num)
          ? sellingPriceNum.toDouble()
          : (double.tryParse(sellingPriceNum.toString()) ?? 0.0);

      final mrpNum = (item['mrp'] ?? item['original_price'] ?? sellingPriceNum);
      final originalPrice = (mrpNum is num)
          ? mrpNum.toDouble()
          : (double.tryParse(mrpNum.toString()) ?? price);

      final discountRaw = item['discount'] ?? item['discountPercentage'] ?? 0;
      double discountPercentage = (discountRaw is num)
          ? discountRaw.toDouble()
          : (double.tryParse(discountRaw.toString()) ?? 0.0);
      if (discountPercentage == 0.0 &&
          originalPrice > price &&
          originalPrice > 0) {
        discountPercentage = ((originalPrice - price) / originalPrice) * 100;
      }

      final image =
          (item['image'] ?? item['image_url'] ?? item['url'] ?? '').toString();
      final imagesValue = item['images'];
      final List<String> images = (imagesValue is List)
          ? imagesValue.map((e) => e.toString()).toList()
          : (image.isNotEmpty ? [image] : []);

      // Determine category
      String category = (item['category'] ?? item['type'] ?? '').toString();
      if (category.isEmpty) {
        // Simple heuristic for category assignment if missing
        final nameLower = name.toLowerCase();
        if (nameLower.contains('curry') ||
            nameLower.contains('chicken') ||
            nameLower.contains('mutton')) {
          category = 'Curries';
        } else if (nameLower.contains('masala') ||
            nameLower.contains('powder') ||
            nameLower.contains('elachi') ||
            nameLower.contains('clove') ||
            nameLower.contains('pepper') ||
            nameLower.contains('spice')) {
          category = 'Masalas';
        } else if (nameLower.contains('pickle')) {
          category = 'Pickles';
        } else if (nameLower.contains('gravy')) {
          category = 'Gravies';
        } else {
          category = 'Others'; // Default fallback
        }
      }

      final unit = (item['unit'] ?? item['quantity']?.toString() ?? 'per unit')
          .toString();
      final ratingVal = item['rating'] ?? 0;
      final rating = (ratingVal is num)
          ? ratingVal.toDouble()
          : (double.tryParse(ratingVal.toString()) ?? 0.0);
      final reviewCountVal = item['reviewCount'] ?? item['reviews'] ?? 0;
      final reviewCount = (reviewCountVal is num)
          ? reviewCountVal.toInt()
          : (int.tryParse(reviewCountVal.toString()) ?? 0);
      list.add(Product(
        id: id,
        name: name,
        description: description,
        price: price,
        originalPrice: originalPrice,
        discountPercentage: discountPercentage,
        image:
            image.isNotEmpty ? image : (images.isNotEmpty ? images.first : ''),
        images: images,
        category: category,
        unit: unit,
        rating: rating,
        reviewCount: reviewCount,
      ));
    }
    return list;
  }

  static Future<bool> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppEndpoints.baseUrl}/products'),
            headers: _getHeaders(),
            body: jsonEncode(productData),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to create product: ${response.body}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}', 0);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => 'ApiException($statusCode): $message';
}
