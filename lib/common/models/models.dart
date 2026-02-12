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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? 'customer',
      referralId: json['referralId'],
      addresses: List<String>.from(json['addresses'] ?? []),
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? false,
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
}

// Address Model
class Address {
  final String id;
  final String fullName;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final bool isDefault;

  Address({
    String? id,
    required this.fullName,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    this.isDefault = false,
  }) : id = id ?? const Uuid().v4();

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      phone: json['phone'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
        'pincode': pincode,
        'phone': phone,
        'isDefault': isDefault,
      };
}

// Product Model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
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

  Product({
    String? id,
    required this.name,
    required this.description,
    required this.price,
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
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? [json['image']]),
      category: json['category'] ?? '',
      unit: json['unit'] ?? 'kg',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      sku: json['sku'],
      size: json['size'],
      tags: List<String>.from(json['tags'] ?? []),
      instructions: json['instructions'] != null
          ? List<String>.from(json['instructions'])
          : null,
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
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
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
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      deliveryCharge: (json['deliveryCharge'] ?? 50.0).toDouble(),
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
  })  : id = id ?? const Uuid().v4(),
        orderDate = orderDate ?? DateTime.now();

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      deliveryAddress: Address.fromJson(json['deliveryAddress']),
      deliveryType: json['deliveryType'] ?? 'standard',
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? 'pending',
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryCharge: (json['deliveryCharge'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      orderDate: json['orderDate'] != null
          ? DateTime.parse(json['orderDate'])
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
      isDefault: json['isDefault'] ?? false,
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
