import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/utils/constants.dart';
import '../../common/models/models.dart';
import '../../common/controllers/cart_controller.dart';

class AddAddressScreen extends StatefulWidget {
  final Address? address;
  const AddAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _hNoController;
  late final TextEditingController _streetController;
  late final TextEditingController _addressController; // Landmark/Area
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  final CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.address?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _pincodeController =
        TextEditingController(text: widget.address?.pincode ?? '');
    _hNoController = TextEditingController(text: widget.address?.hNo ?? '');
    _streetController =
        TextEditingController(text: widget.address?.street ?? '');
    _addressController =
        TextEditingController(text: widget.address?.addressLine1 ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _hNoController.dispose();
    _streetController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final newAddress = Address(
        id: widget.address?.id, // Preserve ID if editing
        fullName: _nameController.text,
        phone: _phoneController.text,
        pincode: _pincodeController.text,
        hNo: _hNoController.text,
        street: _streetController.text,
        addressLine1: _addressController.text,
        addressLine2: '',
        city: _cityController.text.isNotEmpty
            ? _cityController.text
            : 'Hyderabad',
        state: _stateController.text.isNotEmpty
            ? _stateController.text
            : 'Telangana',
      );

      bool success;
      if (widget.address != null) {
        // Edit mode
        success = await cartController.updateAddress(newAddress);
      } else {
        // Add mode
        success = await cartController.addNewAddress(newAddress);
      }

      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address != null ? 'Edit Address' : 'Add New Address',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Contact Details'),
              const SizedBox(height: AppSizes.paddingSmall),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v?.length != 10 ? 'Enter valid 10-digit number' : null,
              ),
              const SizedBox(height: AppSizes.paddingLarge),
              _buildSectionTitle('Address Details'),
              const SizedBox(height: AppSizes.paddingSmall),
              _buildTextField(
                controller: _hNoController,
                label: 'House No. / Building Name',
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              _buildTextField(
                controller: _streetController,
                label: 'Road Name / Area / Colony',
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              _buildTextField(
                controller: _addressController,
                label: 'Landmark / Address Line 1',
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _pincodeController,
                      label: 'Pincode',
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v?.length != 6 ? 'Invalid Pincode' : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingMedium),
              _buildTextField(
                controller: _stateController,
                label: 'State',
              ),
              const SizedBox(height: AppSizes.paddingXLarge),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeightMedium,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                  child: Obx(() => cartController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2))
                      : const Text('Save Address',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.subtitle1.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
      ),
    );
  }
}
