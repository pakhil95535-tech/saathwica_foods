import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
// import 'package:image_picker/image_picker.dart'; // Assuming image_picker is available if needed, but I'll use placeholders for now
import '../../common/utils/constants.dart';
import '../../common/controllers/auth_controller.dart';
import '../../services/api_service.dart';

class ProductCreationScreen extends StatefulWidget {
  const ProductCreationScreen({super.key});

  @override
  State<ProductCreationScreen> createState() => _ProductCreationScreenState();
}

class _ProductCreationScreenState extends State<ProductCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _price1Controller = TextEditingController(); // Admin Price
  final _price2Controller = TextEditingController(); // Employee Price
  final _price3Controller = TextEditingController(); // Supervisor Price
  final _price4Controller = TextEditingController(); // Customer Price
  final _unitController = TextEditingController(text: 'kg');

  String _selectedCategory = 'Curries';
  final List<String> _categories = [
    'Curries',
    'Masalas',
    'Snacks',
    'Pickles',
    'Gravies',
    'Personal Care'
  ];

  bool _isLoading = false;
  File? _imageFile;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _price1Controller.dispose();
    _price2Controller.dispose();
    _price3Controller.dispose();
    _price4Controller.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final productData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'unit': _unitController.text,
        'price1': double.tryParse(_price1Controller.text),
        'price2': double.tryParse(_price2Controller.text),
        'price3': double.tryParse(_price3Controller.text),
        'price4': double.tryParse(_price4Controller.text),
        'image': AppAssets.logo, // Use valid asset path
      };

      final success = await ApiService.createProduct(productData);

      if (success) {
        Get.back();
        Get.snackbar(
          'Success',
          'Product created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role =
        authController.currentUser.value?.userType.toLowerCase() ?? 'customer';
    // Strict requirement: Only Super Admin can create products
    final isSuperAdmin = role == 'superadmin';

    if (!isSuperAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Access Denied')),
        body: const Center(
          child: Text('Only Super Admin can create products.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product',
            style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Picker Placeholder
                    GestureDetector(
                      onTap: () {
                        // Implement image picking logic here
                        Get.snackbar('Note', 'Image picking to be implemented');
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:
                                    Image.file(_imageFile!, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,
                                      size: 50, color: Colors.grey[400]),
                                  const SizedBox(height: 10),
                                  Text('Add Product Photo',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Category Selection
                    const Text('Category',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.mediumGray)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.mediumGray)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primary, width: 2)),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(
                          fontSize: 18, color: AppColors.textPrimary),
                      items: _categories
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val!),
                    ),
                    const SizedBox(height: 25),

                    // Basic Info
                    _buildTextField(
                        _nameController, 'Product Name', 'Enter product name'),
                    _buildTextField(_descriptionController, 'Description',
                        'Enter description',
                        maxLines: 3),
                    _buildTextField(_unitController,
                        'Unit (e.g., kg, 500g, per unit)', 'Enter unit'),

                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text('Role-Based Pricing',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary)),
                    const SizedBox(height: 15),

                    // Pricing Fields
                    _buildPriceField(
                        _price1Controller, 'Admin Sell Price', isSuperAdmin),
                    _buildPriceField(
                        _price2Controller, 'Employee Sell Price', isSuperAdmin),
                    _buildPriceField(
                        _price3Controller, 'Supervisor Sell Price', isSuperAdmin),
                    _buildPriceField(
                        _price4Controller, 'Customer Sell Price', true),

                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('CREATE PRODUCT',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary)),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mediumGray)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mediumGray)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'This field is required' : null,
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildPriceField(
      TextEditingController controller, String label, bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary)),
            if (!isEditable)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('Read-only',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              ),
          ],
        ),
        TextFormField(
          controller: controller,
          enabled: isEditable,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixText: '₹ ',
            prefixStyle: const TextStyle(fontSize: 18, color: Colors.black87),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mediumGray)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.mediumGray)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            filled: !isEditable,
            fillColor: isEditable ? Colors.transparent : Colors.grey[50],
          ),
          validator: (value) {
            if (isEditable && (value == null || value.isEmpty))
              return 'Required';
            return null;
          },
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
