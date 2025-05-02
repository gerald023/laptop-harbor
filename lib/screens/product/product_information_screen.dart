import 'package:aptech_project/constants.dart';
 import 'package:aptech_project/types/product_types.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter_svg/flutter_svg.dart';
 
 class ProductInformationScreen extends StatefulWidget {
   final ProductDetailsModel productDetails;
   const ProductInformationScreen({super.key, required this.productDetails});
 
   @override
   State<ProductInformationScreen> createState() => _ProductInformationScreenState();
 }
 
 class _ProductInformationScreenState extends State<ProductInformationScreen> {
   late List<Map<String, dynamic>?> basicInfo;
   late List<Map<String, dynamic>?> batteryInfo;
   late List<Map<String, dynamic>?> osInfo;
   late List<Map<String, dynamic>?> designInfo;
   late List<Map<String, dynamic>?> memoryInfo;
   late List<Map<String, dynamic>?> processorInfo;
   late List<Map<String, dynamic>?> displayInfo;
 
   @override
   void initState() {
     super.initState();
     basicInfo = [
       {'name': 'Name', 'value': widget.productDetails.basicInfo.productName, 'icon': 'icons/boxIcon.svg'},
       {'name': 'Quantity',  'value': widget.productDetails.basicInfo.stockQuantity.toString(), 'icon': 'icons/stockIcon.svg'}
     ];
     batteryInfo = [
       {'name': 'Battery Type', 'icon': 'icons/batteryType.svg', 'value': widget.productDetails.battery.type},
       {'name': 'Battery Capacity', 'icon': 'icons/batteryCapacity.svg', 'value': widget.productDetails.battery.capacityWh.toString()},
       {'name': 'Backup Hours', 'icon': 'icons/batteryHours.svg', 'value': widget.productDetails.battery.backupHours.toString()},
       {'name': 'Charger Type', 'icon': 'icons/batteryCharger.svg', 'value': widget.productDetails.battery.chargingType},
     ];
     osInfo = [
       {'name': 'Operating System', 'value': widget.productDetails.operatingSystem.name, 'icon': 'icons/osIcon.svg'},
       {'name': 'Version', 'value': widget.productDetails.operatingSystem.version, 'icon': 'icons/osVersion.svg'}
     ];
     designInfo = [
       {'name': 'Material', 'value': widget.productDetails.buildAndDesign.material, 'icon': 'icons/material.svg'},
       {'name': 'Color', 'value': widget.productDetails.buildAndDesign.color, 'icon': 'icons/color.svg'}
     ];
     memoryInfo = [
       {'name': 'Memory Size', 'value': widget.productDetails.memory.sizeGB.toString(), 'icon': 'icons/memorySize.svg'},
       {'name': 'Memory Type', 'value': widget.productDetails.memory.type, 'icon': 'icons/memoryType.svg'},
     ];
     processorInfo = [
       {'name': 'Processor Model', 'value': widget.productDetails.processor.model, 'icon': ''},
       {'name': 'Speed', 'value': widget.productDetails.processor.baseSpeedGHz.toString(), 'icon': ''}
     ];
     displayInfo = [
       {'name': 'Screen Size', 'value': widget.productDetails.display.sizeInches.toString(), 'icon': 'icons/screenSize.svg'},
       {'name': 'Resolution', 'value': widget.productDetails.display.resolution, 'icon': 'icons/screenType.svg'},
       {'name': 'Screen Type', 'value': widget.productDetails.display.type, 'icon': 'icons/screenType.svg'}
     ];
   }
 
   @override
   Widget build(BuildContext context) {
     return  Scaffold(
       body: SafeArea(
         child: Column(
           children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
               child: Row(
                 children: [
                   const SizedBox(
                     width: 40,
                     child: BackButton(),
                   ),
                   SizedBox(
                     width: 200,
                   ),
                    Text(
                     "Details",
                     style: Theme.of(context).textTheme.titleSmall,
                   ),
                   const SizedBox(height: 40),
                 ],
               ),
             ),
             Expanded(
               child: CustomScrollView(
                 slivers: [
                   SliverToBoxAdapter(
                     child: Padding(
                       padding: const EdgeInsets.all(20.0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Text("Basic Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: basicInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = basicInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
                           const SizedBox(height: 10,),
                           const Text("Battery Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: batteryInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = batteryInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
 
                           const SizedBox(height: 10,),
                           const Text("Operating System Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: osInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = osInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
                           const SizedBox(height: 10,),
                           const Text("Design Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: designInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = designInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
                           const SizedBox(height: 10,),
                           const Text("Memory Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: memoryInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = memoryInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
                           const SizedBox(height: 10,),
                           const Text("Processor Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: processorInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = processorInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
                           const SizedBox(height: 10,),
                           const Text("Display Information",
                             style: TextStyle(
                               fontSize: 19,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListView.builder(
                               itemCount: displayInfo.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                               itemBuilder: (context, index){
                                 final item = displayInfo[index];
                                 return productInformationList(
                                   name: item?['name'],
                                   value: item?['value'],
                                   svgSrc: item?['icon'],
                                 );
                               },
                             ),
                           ),
                         ],
                       ),
                     )
                   )
                 ],
               ),
             )
           ],
         )
       ),
     );
   }
 }
 
 class productInformationList extends StatelessWidget {
   
   const productInformationList({
     super.key, required this.svgSrc, required this.name, required this.value,
   });
   final String svgSrc;
   final String name;
   final String value;
 
   @override
   Widget build(BuildContext context) {
     return Container(
       height: 30,
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                svgSrc,
                height: 12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              const SizedBox(width: 10,),
              Text('$name: $value',
               style: const TextStyle(
                 fontSize: 14,
                 // fontWeight: FontWeight.bold
               ),
              )
            ],
          )
        ],
      ),
     );
   }
 }