
// import 'package:aptech_project/components/textField_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:aptech_project/data/product_form_data.dart';

// class ProductBasicinfoForm extends StatefulWidget {
//   final TextEditingController nameController;
//   final TextEditingController priceController;
//   final TextEditingController quantityController;
//   final TextEditingController batteryType;
//   final TextEditingController batteryCapacity;
//   final TextEditingController batteryBackupHours;
//   final TextEditingController chargingType;
//   String? selectedCharger;
//   String? selectedBatteryType;
//   String? selectedBatteryCapacity;
//   String? selectedBackupHours;

//    ProductBasicinfoForm({super.key, required this.nameController, required this.priceController, required this.quantityController, required this.batteryType, required this.batteryCapacity, required this.batteryBackupHours, required this.chargingType, this.selectedCharger, this.selectedBatteryType, this.selectedBatteryCapacity, this.selectedBackupHours});
  

//   @override
//   State<ProductBasicinfoForm> createState() => _ProductBasicinfoFormState();
  
// }


// class _ProductBasicinfoFormState extends State<ProductBasicinfoForm> {
  
  

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(2),
//       child: Column(
//         children: [
//           Column(
//             children: [
//               const Text('Basic Product Info',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),),
//               TextfieldWidget(
//                 controller: widget.nameController,
//                 placeholder: 'Product Name',
//                  prefixIcon: const Icon(
//                           Icons.shopping_cart_outlined,
//                           color: Colors.grey,
//                           size: 21,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter the product\'s name';
//                           } else if (value.trim().length < 3) {
//                             return 'Product\'s name cannot be less than 3 characters';
//                           }
//                           return null;
//                         },
//                 ),
//                 SizedBox(height: 20,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: TextfieldWidget(
//                         controller: widget.priceController,
//                         placeholder: 'Product Price',
//                         prefixIcon: const Icon(
//                                 Icons.attach_money,
//                                 color: Colors.grey,
//                                 size: 21,
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter the Product\'s price';
//                                 } else if (int.parse(value) < 200) {
//                                   return 'Product\'s price cannot be less than \$200';
//                                 }
//                                 return null;
//                               },
//                       ),
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         keyboardType: TextInputType.number,
//                         controller: widget.quantityController,
//                         decoration: InputDecoration(
//                           hintText: '100',
//                           labelText: 'Quantity',
//                           filled: true,
//                     fillColor: const Color(0xFFF5FCF9),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
//                     border: const OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       borderRadius: BorderRadius.all(Radius.circular(50)),
//                     ),
//                     hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: Colors.grey,
//                         ),
//                         prefixIcon: Icon(
//                           Icons.numbers_rounded
//                         )
//                         ),
//                         validator: (value){
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter the quantity of the product';
//                           }
//                           else if(int.parse(value) < 20) 
//                           {
//                             return 'products can not be less than 20';
//                           }
//                           return null;
//                         },
//                       )
//                     )
//                   ],
//                 )
//             ],
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           Column(
//             children: [
//               const Text('Battery Info',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//                         Container(
//                           child: DropdownButtonFormField(
//                                           decoration: const InputDecoration(
//                                             labelText: 'Battery Type',
//                                             // border: OutlineInputBorder(),
//                                           ),
//                                           value: widget.selectedBatteryType,
//                                           items: batteryType.map((String value){
//                                             return DropdownMenuItem(
//                           value: value,
//                           child: Text(value)
//                                             );
//                                           }).toList(), 
//                                            validator: (value) =>
//                             value == null ? 'Please select an option' : null,
//                                           onChanged: (String? value){
//                           setState(() {
//                             widget.selectedBatteryType = value;
//                             widget.batteryType.text = value ?? '';
//                           });
//                                           }
//                                         ),
//                         ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                    Container(
//                     width: 170,
//                     child: DropdownButtonFormField(
//                                     decoration: InputDecoration(
//                     labelText: 'Capacity',
//                     // border: OutlineInputBorder(),
//                                     ),
//                                     value: widget.selectedBatteryCapacity,
//                                     items: batteryCapacity.map((String value){
//                     return DropdownMenuItem(
//                       value: value,
//                       child: Text(value)
//                     );
//                                     }).toList(), 
//                                      validator: (value) =>
//                         value == null ? 'Please select an option' : null,
//                                     onChanged: (String? value){
//                       setState(() {
//                         widget.selectedBatteryCapacity = value;
//                         widget.batteryCapacity.text  = value ?? '';
//                       });
//                                     }
//                                   ),
//                   ),
//                    Container(
//                       width: 170,
//                       child: DropdownButtonFormField(
//                                       decoration: InputDecoration(
//                                         labelText: 'Backup Hours',
//                                         // border: OutlineInputBorder(),
//                                       ),
//                                       value: widget.selectedBackupHours,
//                                       items: backupHours.map((String value){
//                                         return DropdownMenuItem(
//                       value: value,
//                       child: Text(value)
//                                         );
//                                       }).toList(), 
//                                        validator: (value) =>
//                         value == null ? 'Please select an option' : null,
//                                       onChanged: (String? value){
//                       setState(() {
//                         widget.selectedBackupHours = value;
//                         widget.batteryBackupHours.text = value ?? '';
//                       });
//                                       }
//                                     ),
//                     ),
//                   SizedBox(width: 10,),
                     
//                 ]
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Container(
//                       child: DropdownButtonFormField(
//                                       decoration: InputDecoration(
//                                         labelText: 'Charger type',
//                                         // border: OutlineInputBorder(),
//                                       ),
//                                       value: widget.selectedCharger,
//                                       items: chargerTypes.map((String value){
//                                         return DropdownMenuItem(
//                       value: value,
//                       child: Text(value)
//                                         );
//                                       }).toList(), 
//                                        validator: (value) =>
//                         value == null ? 'Please select an option' : null,
//                                       onChanged: (String? value){
//                       setState(() {
//                         widget.selectedCharger = value;
//                         widget.chargingType.text = value ?? '';
//                       });
//                                       }
//                                     ),
//                     ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }