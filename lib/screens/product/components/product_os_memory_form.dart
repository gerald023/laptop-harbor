// import 'package:flutter/material.dart';
// import 'package:aptech_project/data/product_form_data.dart';

// class ProductOsMemoryForm extends StatefulWidget {
//   String? osName;
//   String? osVersion;
//   String? memorySize;
//   String? memoryType;
//   bool isMemoryExpandable;
//   String? laptopMaterial;
//   String? laptopColor;

//    ProductOsMemoryForm({super.key, required this.isMemoryExpandable, required this.osVersion, required this.memorySize, required this.memoryType, required this.laptopMaterial, required this.laptopColor});

//   @override
//   State<ProductOsMemoryForm> createState() => _ProductOsMemoryFormState();

// }

// class _ProductOsMemoryFormState extends State<ProductOsMemoryForm> {
//   String? _selectedOS = '';

//   List<String> osVersionOptions = windowsVersions;


//   setSelectedOS(String? value) {
//     setState(() {
//       _selectedOS = value;
//       switch (value!.toLowerCase()) {
//         case 'windows':
//           osVersionOptions = windowsVersions;
//           break;
//         case 'macos':
//           osVersionOptions = macOSVersions;
//           break;
//         case 'linux':
//           osVersionOptions = linuxVersions;
//           break;
//         default:
//           osVersionOptions = windowsVersions;
//       }      
//       // osVersionOptions = _selectedOS.toLowerCase() == 'windows' ? windowsVersions : windowsVersions;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  SingleChildScrollView(
//       padding: EdgeInsets.all(3),
//       child: Column(
//         children: [
//           const Text('Operating System',
//           style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             children: [
//               Container(
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(16)
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 2),
//                 child: DropdownButton<String>(
                  
//                   value: _selectedOS,
//                   selectedItemBuilder: (BuildContext context) {
//           return operatingSystem.map((String value) {
//             return Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 _selectedOS!,
//               ),
//             );
//           }).toList();
//         },
//         items: operatingSystem.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//                   onChanged: (String? value) {
//                     widget.osName = value;
//                     setSelectedOS(value);
//           setState(() {
//             widget.osName = value;
//           });
//         },
//         underline: const SizedBox(),
//         isExpanded: true,
//         style: const TextStyle(color: Colors.black),
//         hint: const Text('Operating System'),
//         dropdownColor: Colors.white,
//         icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
//                 ),
//               ),
//                    Container(
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(16)
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 2),
//                 child: DropdownButton<String>(
                  
//                   value: osVersionOptions[0],
//                   selectedItemBuilder: (BuildContext context) {
//           return osVersionOptions.map((String value) {
//             return Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 osVersionOptions[osVersionOptions.indexOf(value)],
//               ),
//             );
//           }).toList();
//         },
//         items: osVersionOptions.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//                   onChanged: (String? value) {
//                     widget.osVersion = value;
//           setState(() {
//             widget.osVersion = value;
//           });
//         },
//         underline: const SizedBox(),
//         isExpanded: true,
//         style: const TextStyle(color: Colors.black),
//         hint: const Text('Versions'),
//         dropdownColor: Colors.white,
//         icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
//                 ),
//               ),
              
//             ],
//           ),
//           const SizedBox(height: 30,),
//           Column(
//             children: [
//               const Text('System Memory'),
//               const SizedBox(height: 20,),
//               Row(
//                 children: [
//                                            Container(
//                 width: 170,
//                 decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(16)
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 2),
//                 child: DropdownButton<String>(
                  
//                   value: memoryRamSize[0],
//                   selectedItemBuilder: (BuildContext context) {
//           return memoryRamSize.map((String value) {
//             return Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 memoryRamSize[memoryRamSize.indexOf(value)],
//               ),
//             );
//           }).toList();
//         },
//         items: memoryRamSize.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//                   onChanged: (String? value) {
//                     widget.memorySize = value;
//           setState(() {
//             widget.memorySize = value;
//           });
//         },
//         underline: const SizedBox(),
//         isExpanded: true,
//         style: const TextStyle(color: Colors.black),
//         hint: const Text('Memory Size'),
//         dropdownColor: Colors.white,
//         icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
//                 ),
//               ),
//         Container(
//                 width: 170,
//                 decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(16)
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 2),
//                 child: DropdownButton<String>(
                  
//                   value: memoryType[0],
//                   selectedItemBuilder: (BuildContext context) {
//           return memoryType.map((String value) {
//             return Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 memoryType[memoryType.indexOf(value)],
//               ),
//             );
//           }).toList();
//         },
//         items: memoryType.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//                   onChanged: (String? value) {
//                     widget.memoryType = value;
//           setState(() {
//             widget.memoryType = value;
//           });
//         },
//         underline: const SizedBox(),
//         isExpanded: true,
//         style: const TextStyle(color: Colors.black),
//         hint: const Text('Memory types'),
//         dropdownColor: Colors.white,
//         icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
//                 ),
//               ),
//                 ],
//               ),
//               const SizedBox(height: 20,),
//               SwitchListTile(
//                     title: const Text('Memory is Expandable'),
//                     value: widget.isMemoryExpandable,
//                     onChanged: (value) {
//                        widget.isMemoryExpandable = value;
//                       setState(() {
//                         widget.isMemoryExpandable = value;
//                       });
//                     }),
//             ],
//           )
//         ]
//       ),
//     );
//   }
// }