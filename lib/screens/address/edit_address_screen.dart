import 'package:flutter/material.dart';
import 'package:aptech_project/models/address_model.dart';
import 'package:aptech_project/services/transactions_service.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final TransactionService _transactionService = TransactionService();

  AddressModel? _address;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final fetchedAddress = await _transactionService.getRecentUserAddress();
    if (fetchedAddress != null) {
      setState(() {
        _address = fetchedAddress;
        _countryController.text = fetchedAddress.country;
        _cityController.text = fetchedAddress.city;
        _postalCodeController.text = fetchedAddress.postalCode;
      });
    }
  }

  Future<void> _updateAddress() async {
    if (_formKey.currentState!.validate() && _address != null) {
      final updatedAddress = AddressModel(
        addressId: _address!.addressId,
        userId: _address!.userId,
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
      );

      final success = await _transactionService.updateAddress(updatedAddress);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Address updated!' : 'Update failed')),
      );

      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Billing Address')),
      body: _address == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                      validator: (value) => value!.isEmpty ? 'Enter country' : null,
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (value) => value!.isEmpty ? 'Enter city' : null,
                    ),
                    TextFormField(
                      controller: _postalCodeController,
                      decoration: const InputDecoration(labelText: 'Postal Code'),
                      validator: (value) => value!.isEmpty ? 'Enter postal code' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateAddress,
                      child: const Text('Update Address'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
