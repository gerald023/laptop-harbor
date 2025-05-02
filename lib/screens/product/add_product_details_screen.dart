import 'package:flutter/material.dart';
import './components/add_product_details_form.dart';


// class TabPair {
//   final Tab tab;
//   final Widget view;
//   TabPair({required this.tab, required this.view});
// }

// List<TabPair> tabPairs = [
//   TabPair(
//     tab: const Tab(
//       text: 'Intro',
//     ),
//     view: const Center(
//       child: Text(
//         'Intro here',
//         style: TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   ),
//   TabPair(
//     tab: const Tab(
//       text: 'Ingredients',
//     ),
//     view: const Center(
//       child: Text(
//         'Ingredients here',
//         style: TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   ),
//   TabPair(
//     tab: const Tab(
//       text: 'Steps',
//     ),
//     view: const Center(
//       child: Text(
//         'Steps here',
//         style: TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   )
// ];

class AddProductDetailsScreen extends StatefulWidget {
  const AddProductDetailsScreen({super.key});

  @override
  _AddProductDetailsScreenState createState() => _AddProductDetailsScreenState();
}

class _AddProductDetailsScreenState extends State<AddProductDetailsScreen>

    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController batteryType = TextEditingController();
  final TextEditingController batteryCapacity = TextEditingController();
  final TextEditingController batteryBackupHours = TextEditingController();
  final TextEditingController chargingType = TextEditingController();

  String? osName = '';
   String? osVersion = '';
  String? memorySize = '';
  String? memoryType = '';
  bool isMemoryExpandable = true;
  String? laptopMaterial = '';
  String? laptopColor = '';


  // late TabController _tabController;
  // final int totalSteps = 3;
  //       int currentStep = 0;
  //   List<bool> isCompleted = [false, false, false];

  //   void _nextStep() {
  //     print('price: ${priceController.text}');
  //     print('name: ${nameController.text}');
  //     print('quantity: ${quantityController.text}');
  //     print('battery: $batteryType \n capacity: $batteryCapacity. \n charger: $chargingType. \n  backupHours: $batteryBackupHours');
  //     print('osName: $osName \n osVersion: $osVersion \n memorySize: $memorySize, \n memoryType: $memoryType \n isMemoryExpandable: $isMemoryExpandable');
  //   setState(() {
  //     isCompleted[currentStep] = true;
  //     if (currentStep < totalSteps - 1) {
  //       currentStep++;
  //     } else {
  //       _submitForm();
  //     }
  //   });
  // }


  //  void _prevStep() {
  //   setState(() {
  //     if (currentStep > 0) currentStep--;
  //   });
  // }

  // void _submitForm() {
  //   // Implement your submit logic here
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Form submitted successfully!')),
  //   );
  // }

  // Widget _buildStepIndicator(int index) {
  //   bool completed = isCompleted[index];
  //   bool isActive = index == currentStep;

  //   return CircleAvatar(
  //     radius: 20,
  //     backgroundColor: completed
  //         ? Colors.green
  //         : isActive
  //             ? Colors.blue
  //             : Colors.grey.shade300,
  //     child: completed
  //         ? const Icon(Icons.check, color: Colors.white)
  //         : Text(
  //             '${index + 1}',
  //             style: TextStyle(
  //               color: isActive ? Colors.white : Colors.black,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //   );
  // }

  // Widget _buildFormContent() { 
  //   switch (currentStep) {
  //     case 0:
  //       return  ProductBasicinfoForm(nameController: nameController, priceController: priceController, quantityController: quantityController, batteryType: batteryType, batteryCapacity: batteryCapacity, batteryBackupHours: batteryBackupHours, chargingType: chargingType, selectedBackupHours: batteryBackupHours.text, selectedBatteryCapacity: batteryCapacity.text, selectedBatteryType: batteryType.text, selectedCharger: chargingType.text,);
  //     case 1:
  //       return ProductOsMemoryForm(isMemoryExpandable: isMemoryExpandable, osVersion: osVersion, memorySize: memorySize, memoryType: memoryType, laptopMaterial: laptopMaterial, laptopColor: laptopColor);
  //     case 2:
  //       return const Center(child: Text("Step 3: Images & Review"));
  //     default:
  //       return const SizedBox();
  //   }
  // }

  // @override
  // void initState() {
  //   _tabController = TabController(length: tabPairs.length, vsync: this);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _tabController.dispose();
  // }

  @override
   Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('Add Product Details'),
              floating: true,
            ),
            SliverPadding(
              padding: EdgeInsets.all(20.0),
              sliver: SliverToBoxAdapter(
                child: AddProductDetailsForm(),
              )
            )
          ]
        )
      ),
    );
  }
}

