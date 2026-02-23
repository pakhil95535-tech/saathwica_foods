// lib/models/models.dart

import 'package:uuid/uuid.dart';

// User Model
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType; // customer, employee, supervisor
  final String? referralId;
  final List<String> addresses;
  final String? profileImage;
  final bool isVerified;
  final DateTime createdAt;

  User({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.referralId,
    this.addresses = const [],
    this.profileImage,
    this.isVerified = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _safeString(json['id']),
      name: _safeString(json['name']),
      email: _safeString(json['email']),
      phone: _safeString(json['phone']),
      userType: _safeString(json['userType'], 'customer'),
      referralId:
          json['referralId'] != null ? _safeString(json['referralId']) : null,
      addresses: List<String>.from(json['addresses'] ?? []),
      profileImage: json['profileImage'] != null
          ? _safeString(json['profileImage'])
          : null,
      isVerified: _safeBool(json['isVerified']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'userType': userType,
        'referralId': referralId,
        'addresses': addresses,
        'profileImage': profileImage,
        'isVerified': isVerified,
        'createdAt': createdAt.toIso8601String(),
      };

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? userType,
    String? referralId,
    List<String>? addresses,
    String? profileImage,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      referralId: referralId ?? this.referralId,
      addresses: addresses ?? this.addresses,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Address Model
class Address {
  final String id;
  final String fullName; // Maps to 'name'
  final String hNo; // New field
  final String street; // New field
  final String addressLine1; // Maps to 'address' (Landmark/Area)
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final bool isDefault;

  Address({
    String? id,
    required this.fullName,
    this.hNo = '',
    this.street = '',
    required this.addressLine1,
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    required this.pincode,
    required this.phone,
    this.isDefault = false,
  }) : id = id ?? const Uuid().v4();

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: _safeString(json['address_id'] ?? json['id'], const Uuid().v4()),
      fullName: _safeString(json['name'] ?? json['fullName']),
      hNo: _safeString(json['h_no']),
      street: _safeString(json['street']),
      addressLine1: _safeString(
          json['address'] ?? json['addressLine1'] ?? json['address1']),
      addressLine2: _safeString(json['addressLine2'] ?? json['address2']),
      city: _safeString(json['city'], 'Hyderabad'),
      state: _safeString(json['state'], 'Telangana'),
      pincode: _safeString(json['pincode']),
      phone: _safeString(json['phone']),
      isDefault: _safeBool(json['isDefault']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': fullName,
        'h_no': hNo,
        'street': street,
        'address': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
        'pincode': pincode,
        'phone': phone,
        'isDefault': isDefault,
      };

  Address copyWith({
    String? id,
    String? fullName,
    String? hNo,
    String? street,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? phone,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      hNo: hNo ?? this.hNo,
      street: street ?? this.street,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

// Safe numeric converter for JSON values that may be strings
double _safeDouble(dynamic value, [double fallback = 0.0]) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? fallback;
}

int _safeInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

String _safeString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  return value.toString();
}

bool _safeBool(dynamic value, [bool fallback = false]) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is String) {
    final lower = value.toLowerCase();
    return lower == 'true' || lower == '1';
  }
  if (value is num) {
    return value == 1;
  }
  return fallback;
}

// Product Model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final String image;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String? sku;
  final String? size;
  final List<String>? tags;
  final String unit;
  final DateTime createdAt;
  final List<String>? instructions;
  final double? price1; // Admin Price
  final double? price2; // Employee Price
  final double? price3; // Supervisor Price
  final double? price4; // Customer Price

  Product({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice = 0.0,
    this.discountPercentage = 0.0,
    required this.image,
    this.images = const [],
    required this.category,
    this.unit = 'kg', // Default unit
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.sku,
    this.size,
    this.tags,
    this.instructions,
    this.price1,
    this.price2,
    this.price3,
    this.price4,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    final price = _safeDouble(json['selling_price'] ?? json['price']);
    final originalPrice = _safeDouble(
        json['mrp'] ?? json['originalPrice'] ?? json['price'], price);
    double discount =
        _safeDouble(json['discount'] ?? json['discountPercentage']);
    if (discount == 0.0 && originalPrice > price && originalPrice > 0) {
      discount = ((originalPrice - price) / originalPrice) * 100;
    }

    return Product(
      id: (json['id'] ?? json['product_id'] ?? json['pr_id'] ?? '').toString(),
      name: (json['name'] ?? json['product_name'] ?? '').toString(),
      description: (json['description'] ?? json['desc'] ?? json['about'] ?? '')
          .toString(),
      price: price,
      originalPrice: originalPrice,
      discountPercentage: discount,
      image:
          (json['image'] ?? json['image_url'] ?? json['url'] ?? '').toString(),
      images: List<String>.from(
          json['images'] ?? [json['image'] ?? json['url'] ?? '']),
      category: (json['category'] ?? json['type'] ?? '').toString(),
      unit: (json['unit'] ?? 'kg').toString(),
      rating: _safeDouble(json['rating']),
      reviewCount: _safeInt(json['reviewCount'] ?? json['reviews']),
      isAvailable: _safeBool(json['isAvailable'], true),
      sku: json['sku']?.toString(),
      size: json['size']?.toString(),
      tags: List<String>.from(json['tags'] ?? []),
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : null,
      price1: _safeDouble(json['price1']),
      price2: _safeDouble(json['price2']),
      price3: _safeDouble(json['price3']),
      price4: _safeDouble(json['price4']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'discountPercentage': discountPercentage,
        'image': image,
        'images': images,
        'category': category,
        'unit': unit,
        'rating': rating,
        'reviewCount': reviewCount,
        'isAvailable': isAvailable,
        'sku': sku,
        'size': size,
        'tags': tags,
        'instructions': instructions,
        'price1': price1,
        'price2': price2,
        'price3': price3,
        'price4': price4,
        'createdAt': createdAt.toIso8601String(),
      };
}

// Cart Item Model
class CartItem {
  final String id;
  final Product product;
  int quantity;
  DateTime addedAt;

  CartItem({
    String? id,
    required this.product,
    this.quantity = 1,
    DateTime? addedAt,
  })  : id = id ?? const Uuid().v4(),
        addedAt = addedAt ?? DateTime.now();

  double get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: (json['id'] ?? json['order_item_id'] ?? '').toString(),
      product: Product.fromJson({
        ...(json['product'] ?? json['Product'] ?? {}),
        if (json['price'] != null) 'selling_price': json['price'],
      }),
      quantity: _safeInt(json['quantity'], 1),
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'quantity': quantity,
        'addedAt': addedAt.toIso8601String(),
      };
}

// Cart Model
class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double deliveryCharge;
  final DateTime updatedAt;

  Cart({
    String? id,
    required this.userId,
    this.items = const [],
    this.deliveryCharge = 50.0,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now();

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + deliveryCharge;
  int get itemCount => items.length;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'] ?? '',
      items: (json['items'] as List?)
              ?.map<CartItem>((item) => CartItem.fromJson(item))
              .toList() ??
          <CartItem>[],
      deliveryCharge: _safeDouble(json['deliveryCharge'], 50.0),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'deliveryCharge': deliveryCharge,
        'updatedAt': updatedAt.toIso8601String(),
      };
}

// Order Model
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final Address deliveryAddress;
  final String deliveryType; // standard, express, schedule
  final String paymentMethod;
  final String
      status; // pending, confirmed, preparing, delivered, completed, cancelled
  final double subtotal;
  final double deliveryCharge;
  final double total;
  final DateTime orderDate;
  final DateTime? expectedDelivery;
  final String? trackingId;
  final Map<String, dynamic>? tracking;
  final String? userRole;

  Order({
    String? id,
    required this.userId,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryType,
    required this.paymentMethod,
    this.status = 'pending',
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    DateTime? orderDate,
    this.expectedDelivery,
    this.trackingId,
    this.tracking,
    this.userRole,
  })  : id = id ?? const Uuid().v4(),
        orderDate = orderDate ?? DateTime.now();

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['id'] ?? json['order_id'] ?? json['order_number'] ?? '')
          .toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      items: (json['items'] ?? json['OrderItems'] as List?)
              ?.map<CartItem>((item) => CartItem.fromJson(item))
              .toList() ??
          <CartItem>[],
      deliveryAddress: json['deliveryAddress'] != null
          ? Address.fromJson(json['deliveryAddress'])
          : (json['Addresses'] != null &&
                  (json['Addresses'] as List).isNotEmpty)
              ? Address.fromJson(json['Addresses'][0])
              : Address(
                  fullName: 'N/A',
                  hNo: '',
                  street: '',
                  addressLine1: '',
                  city: '',
                  state: '',
                  pincode: '',
                  phone: ''),
      deliveryType: json['deliveryType'] ?? json['delivery_type'] ?? 'standard',
      paymentMethod: json['paymentMethod'] ??
          json['payment_mode'] ??
          json['payment_method'] ??
          '',
      status: (json['status'] ?? 'pending').toString().toLowerCase(),
      subtotal:
          _safeDouble(json['subtotal'] ?? json['sub_total'] ?? json['amount']),
      deliveryCharge: _safeDouble(json['deliveryCharge'] ??
          json['delivery_charge'] ??
          json['delivery_fee']),
      total: _safeDouble(json['total'] ?? json['total_amount']),
      orderDate: (json['orderDate'] ??
                  json['order_date'] ??
                  json['orderon'] ??
                  json['created_at']) !=
              null
          ? DateTime.parse((json['orderDate'] ??
                  json['order_date'] ??
                  json['orderon'] ??
                  json['created_at'])
              .toString())
          : DateTime.now(),
      expectedDelivery: json['expectedDelivery'] != null
          ? DateTime.parse(json['expectedDelivery'])
          : null,
      trackingId: json['trackingId'],
      tracking: json['tracking'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'deliveryAddress': deliveryAddress.toJson(),
        'deliveryType': deliveryType,
        'paymentMethod': paymentMethod,
        'status': status,
        'subtotal': subtotal,
        'deliveryCharge': deliveryCharge,
        'total': total,
        'orderDate': orderDate.toIso8601String(),
        'expectedDelivery': expectedDelivery?.toIso8601String(),
        'trackingId': trackingId,
        'tracking': tracking,
      };
}

// Payment Method Model
class PaymentMethod {
  final String id;
  final String type; // credit_card, debit_card, wallet, upi
  final String lastFour;
  final String cardholderName;
  final bool isDefault;

  PaymentMethod({
    String? id,
    required this.type,
    required this.lastFour,
    required this.cardholderName,
    this.isDefault = false,
  }) : id = id ?? const Uuid().v4();

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'] ?? '',
      lastFour: json['lastFour'] ?? '',
      cardholderName: json['cardholderName'] ?? '',
      isDefault: _safeBool(json['isDefault']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'lastFour': lastFour,
        'cardholderName': cardholderName,
        'isDefault': isDefault,
      };
}

// Wishlist Model
class WishlistItem {
  final String id;
  final String productId;
  final String userId;
  final DateTime addedAt;

  WishlistItem({
    String? id,
    required this.productId,
    required this.userId,
    DateTime? addedAt,
  })  : id = id ?? const Uuid().v4(),
        addedAt = addedAt ?? DateTime.now();

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'userId': userId,
        'addedAt': addedAt.toIso8601String(),
      };
}
