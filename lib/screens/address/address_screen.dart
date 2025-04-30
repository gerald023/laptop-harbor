import 'package:flutter/material.dart';
import 'package:aptech_project/services/transactions_service.dart';
import 'add_address_screen.dart';
import 'edit_address_screen.dart';
import 'package:aptech_project/route/route_constants.dart';

class AddressEntryPointScreen extends StatefulWidget {
  const AddressEntryPointScreen({super.key});

  @override
  State<AddressEntryPointScreen> createState() => _AddressEntryPointScreenState();
}

class _AddressEntryPointScreenState extends State<AddressEntryPointScreen> {
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _checkAddressStatus();
  }

  Future<void> _checkAddressStatus() async {
    final address = await _transactionService.getRecentUserAddress();

    if (!mounted) return;

    if (address == null) {
      Navigator.pushNamed(context, addAddressScreenRoute);
    } else {
      Navigator.pushNamed(context, editAddressScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
