import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/components/textField_widget.dart';
import 'package:aptech_project/data/product_form_data.dart';
import 'package:aptech_project/types/product_types.dart';
import 'package:aptech_project/components/custom_button.dart';




class AddProductDetailsForm extends StatefulWidget {
  const AddProductDetailsForm({super.key});

  @override
  State<AddProductDetailsForm> createState() => _AddProductDetailsFormState();
}

class _AddProductDetailsFormState extends State<AddProductDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController laptopMaterial = TextEditingController();
  final TextEditingController laptopColor = TextEditingController();

  
  String? coreController;
  String? baseSpeedGHzController;
  String? sizedInchesController;
  String? resolutionController;
  String? displayTypeController;

  bool isTouchscreen = false;
  String?  batteryTypeController;
  String?  batteryCapacityController;
  String?  batteryBackupHoursController;
  String?  chargingTypeController;
  String osName = 'Windows';
  String osVersion = 'Windows 11';
  String memorySize = '32';
  String memoryType = 'SSD';
  bool isMemoryExpandable = false;
  // Battery? batteryData;
  bool _isLoading = false;


  List<String> osVersionOptions = windowsVersions;

  setSelectedOS(String? value) {
    
    setState(() {
      // _selectedOS = value;
      switch (value!.toLowerCase()) {
        case 'windows':
          setState(() {
            osVersionOptions = windowsVersions;
          });
          break;
        case 'macos':
          setState((){
            osVersionOptions = macOSVersions;
          });
          break;
        case 'linux':
          setState(() {
            osVersionOptions = linuxVersions;
          });
          break;
        default:
          setState(() {
            osVersionOptions = windowsVersions;
          });
      }      
      // osVersionOptions = _selectedOS.toLowerCase() == 'windows' ? windowsVersions : windowsVersions;
    });
  }
  

 ProductDetailsModel _getProductDetailsData(){
    Battery batteryData = Battery(
    chargingType: chargingTypeController!,
    backupHours: double.parse(batteryBackupHoursController!),
    capacityWh: int.parse(batteryCapacityController!),
    type: batteryTypeController!
  );
  BasicInfo basicInfoData = BasicInfo(
    price: double.parse(priceController.text),
    productName: nameController.text,
    stockQuantity: int.parse(quantityController.text),
  );
  OperatingSystem operatingSystemData = OperatingSystem(
    name: osName,
    version: osVersion,
  );
  BuildAndDesign buildAndDesignData = BuildAndDesign(
    color: laptopColor.text,
    material: laptopMaterial.text
  );
  Memory memoryData = Memory(
    expandable: isMemoryExpandable,
    sizeGB: int.parse(memorySize),
    type: memoryType
  );
  Processor processorData = Processor(
    model: coreController!,
    baseSpeedGHz: double.parse(baseSpeedGHzController!),
  );
   Display displayData = Display(
    resolution: resolutionController!,
    type: displayTypeController!,
    sizeInches: double.parse(sizedInchesController!)
  );
  return ProductDetailsModel(
    basicInfo: basicInfoData,
    battery: batteryData,
    buildAndDesign: buildAndDesignData,
    display: displayData,
    memory: memoryData,
    operatingSystem: operatingSystemData,
    processor: processorData,
  );
  

  }

ProductService productService = ProductService();

Future<void> _addProductDetails(BuildContext context)async{
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });
  try{
    final productDetailsData =  _getProductDetailsData();
    final data = await _getProductDetailsData();
    final response = await productService.AddProductDetails(
      OSInfo: data.operatingSystem,
      basicInfo: data.basicInfo,
      batteryInfo: data.battery,
      designInfo: data.buildAndDesign,
      memoryInfo: data.memory,
      processorInfo: data.processor,
      displayInfo: data.display
    );

    print(response);

    setState(() {
      _isLoading = false;
    });

     if (response == null) {
      if (!mounted) return;
      // Navigate to the Login screen
      print('sign up completed i guess');
      // Navigator.pushNamed(context, '/onboarding');
       Navigator.pushNamed(context, homeScreenRoute);
    }else{
      // ToasterUtils.showCustomSnackBar(context, errorMessage);
       showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Already Registered'),
      content: Text('This email is already in use. Would you like to log in instead?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text('Go to Login'),
        ),
      ],
    ),
  );
      print('sign up might had failed');
    }
  }catch(e, stack){
    print('error while add product details $e');
    print('stack trace: $stack');
  }finally{
    if(mounted){
      setState(() {
        _isLoading = false;
      });
    }
  }
}

 

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formKey,
      child: Column(
        children: [
           Column(
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Basic Product Info',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              TextfieldWidget(
                controller: nameController,
                placeholder: 'Product Name',
                 prefixIcon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.grey,
                          size: 21,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product\'s name';
                          } else if (value.trim().length < 3) {
                            return 'Product\'s name cannot be less than 3 characters';
                          }
                          return null;
                        },
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextfieldWidget(
                        controller: priceController,
                        placeholder: 'Product Price',
                        prefixIcon: const Icon(
                                Icons.attach_money,
                                color: Colors.grey,
                                size: 21,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Product\'s price';
                                } else if (int.parse(value) < 200) {
                                  return 'Product\'s price cannot be less than \$200';
                                }
                                return null;
                              },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        decoration: InputDecoration(
                          hintText: '100',
                          labelText: 'Quantity',
                          filled: true,
                    fillColor: const Color(0xFFF5FCF9),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                        prefixIcon: Icon(
                          Icons.numbers_rounded
                        )
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter the quantity of the product';
                          }
                          else if(int.parse(value) < 20) 
                          {
                            return 'products can not be less than 20';
                          }
                          return null;
                        },
                      )
                    )
                  ],
                )
            ],
          ),
          SizedBox(height: 70,),

          /* 
              BATTERY FORM SECTION:
           */

           Column(
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Battery Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
                        Container(
                          child: DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Battery Type',
                                            // border: OutlineInputBorder(),
                                          ),
                                          value: batteryTypeController,
                                          items: laptopBatteryType.map((String value){
                                            return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                                            );
                                          }).toList(), 
                                           validator: (value) =>
                            value == null ? 'Please select an option' : null,
                                          onChanged: (String? value){
                          setState(() {
                            batteryTypeController = value ?? '';
                          });
                                          }
                                        ),
                        ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                    width: 170,
                    child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                    labelText: 'Capacity',
                    // border: OutlineInputBorder(),
                                    ),
                                    value: batteryCapacityController,
                                    items: batteryCapacity.map((String value){
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value + 'WH')
                    );
                                    }).toList(), 
                                     validator: (value) =>
                        value == null ? 'Please select an option' : null,
                                    onChanged: (String? value){
                      setState(() {
                        batteryCapacityController  = value ?? '';
                      });
                                    }
                                  ),
                  ),
                   Container(
                      width: 170,
                      child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Backup Hours',
                                        // border: OutlineInputBorder(),
                                      ),
                                      value: batteryBackupHoursController,
                                      items: backupHours.map((String value){
                                        return DropdownMenuItem(
                      value: value,
                      child: Text(value + 'hrs')
                                        );
                                      }).toList(), 
                                       validator: (value) =>
                        value == null ? 'Please select an option' : null,
                                      onChanged: (String? value){
                      setState(() {
                        batteryBackupHoursController = value ?? '';
                      });
                                      }
                                    ),
                    ),
                  SizedBox(width: 10,),
                     
                ]
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                      child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Charger type',
                                        // border: OutlineInputBorder(),
                                      ),
                                      value: chargingTypeController,
                                      items: chargerTypes.map((String value){
                                        return DropdownMenuItem(
                      value: value,
                      child: Text(value)
                                        );
                                      }).toList(), 
                                       validator: (value) =>
                        value == null ? 'Please select an option' : null,
                                      onChanged: (String? value){
                      setState(() {
                        chargingTypeController = value ?? '';
                      });
                                      }
                                    ),
                    ),
            ],
          ),

          SizedBox(height: 70.0),

          /*
                PRODUCT OS, MEMORY AND DESIGN FORM 
           */

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Operating System',
          style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)
                ),
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    const Text('OS Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5,),
                    DropdownButton<String>(
                  
                  value: osName,
                  
                  selectedItemBuilder: (BuildContext context) {
          return operatingSystem.map((String value) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                osName,
              ),
            );
          }).toList();
        },
        items: operatingSystem.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
            onChanged: (String? value) {
              osName = value!;
              setSelectedOS(value);
              setState(() {
                setSelectedOS(value);
                osName = value;
              });
        },
        underline: const SizedBox(),
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        hint: const Text('Operating System'),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ),
                  ],
                ),
              ),
                   Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)
                ),
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    const Text('OS Version',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(height: 5,),
                    DropdownButton<String>(
                  
                  value: osVersion,
                  selectedItemBuilder: (BuildContext context) {
          return osVersionOptions.map((String value) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                osVersion,
              ),
            );
          }).toList();
        },
        items: osVersionOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
                  onChanged: (String? value) {
                    osVersion = value!;
          setState(() {
            osVersion = value;
          });
        },
        underline: const SizedBox(),
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        hint: const Text('OS Versions'),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ),
                  ],
                )
              ),
              
            ],
          ),
          const SizedBox(height: 70,),

          /*
            MEMORY FORM FIELDS
           */
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('System Memory', 
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)
                ),
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    const Text('RAM Size', 
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(height: 5,),
                    DropdownButton<String>(
                  
                  value: memorySize,
                  selectedItemBuilder: (BuildContext context) {
          return memoryRamSize.map((String value) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                memorySize + 'GB RAM',
              ),
            );
          }).toList();
        },
        items: memoryRamSize.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value + 'GB RAM'),
          );
        }).toList(),
                  onChanged: (String? value) {
                    memorySize = value!;
          setState(() {
            memorySize = value;
          });
        },
        underline: const SizedBox(),
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        // hint: const Text('Memory Size'),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ),
                  ],
                )
              ),
        Container(
                width: 170,
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)
                ),
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    const Text('Memory Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(height: 5,),
                    DropdownButton<String>(
                  
                  value: memoryType,
                  selectedItemBuilder: (BuildContext context) {
          return laptopMemoryType.map((String value) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                memoryType
              ),
            );
          }).toList();
        },
        items: laptopMemoryType.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
                  onChanged: (String? value) {
                    memoryType = value!;
          setState(() {
            memoryType = value;
          });
        },
        underline: const SizedBox(),
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        // hint: const Text('Memory types'),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ),
                  ],
                )
              ),
                ],
              ),
              const SizedBox(height: 20,),
              SwitchListTile(
                    title: const Text('Memory is Expandable'),
                    value: isMemoryExpandable,
                    onChanged: (value) {
                       isMemoryExpandable = value;
                      setState(() {
                        isMemoryExpandable = value;
                      });
                    }),
            ],
          )
        ]
      ),
      SizedBox(height: 70),

      /*
        LAPT0P'S DESIGN FORM FIELD
       */
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Laptop\'s design', 
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 200,
              child: TextFormField(
                controller:  laptopColor,
                decoration: InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter laptop\' color';
                  }
                  return null;
                },
              ),
            ),
            Container(
              width: 200,
              child: TextFormField(
                controller:  laptopMaterial,
                decoration:  const InputDecoration(
                  labelText: 'Material (e.g. Aluminium)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter laptop\' material';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 70),

        /*
            LAPTOP'S PROCESSOR AND DISPLAY FORM FIELDS
         */
        const Text('Laptop\'s Proccessor and Display',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Container(
                    width: 200,
                          child: DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Processor',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: coreController,
                                          items: coreModel.map((String value){
                                            return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                                            );
                                          }).toList(), 
                                           validator: (value) =>
                            value == null ? 'Please select an option' : null,
                                          onChanged: (String? value){
                          setState(() {
                            coreController = value ?? '';
                          });
                                          }
                                        ),
                        ),
                        Container(
                    width: 200,
                          child: DropdownButtonFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Speed',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: baseSpeedGHzController,
                                          items: baseCoreSpeed.map((String value){
                                            return DropdownMenuItem(
                          value: value,
                          child: Text(value + 'GHz')
                                            );
                                          }).toList(), 
                                           validator: (value) =>
                            value == null ? 'Please select an option' : null,
                                          onChanged: (String? value){
                          setState(() {
                            baseSpeedGHzController = value ?? '';
                          });
                                          }
                                        ),
                        ),
              ],
            ),
            SizedBox(height: 50,),
            
              Column(
                children: [
                  Text('Display Information', 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 30,),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Container(
                        width: 200,
                              child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Screen Size',
                                                border: OutlineInputBorder(),
                                              ),
                                              value: sizedInchesController,
                                              items: screenSize.map((String value){
                                                return DropdownMenuItem(
                              value: value,
                              child: Text(value + '"')
                                                );
                                              }).toList(), 
                                               validator: (value) =>
                                value == null ? 'Please select an option' : null,
                                              onChanged: (String? value){
                              setState(() {
                                sizedInchesController = value ?? '';
                              });
                                              }
                                            ),
                            ),
                            // SizedBox(width: 10,),
                            Container(
                        width: 200,
                              child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Resolution',
                                                border: OutlineInputBorder(),
                                              ),
                                              value: resolutionController,
                                              items: screenResolution.map((String value){
                                                return DropdownMenuItem(
                              value: value,
                              child: Text(value)
                                                );
                                              }).toList(), 
                                               validator: (value) =>
                                value == null ? 'Please select an option' : null,
                                              onChanged: (String? value){
                              setState(() {
                                resolutionController = value ?? '';
                              });
                                              }
                                            ),
                            ),
                  ],
                              ),
                              SizedBox(height: 30,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      width: 230,
                                              child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Screen Type',
                                                border: OutlineInputBorder(),
                                              ),
                                              value: displayTypeController,
                                              items: screenType.map((String value){
                                                return DropdownMenuItem(
                                                            value: value,
                                                            child: Text(value)
                                                );
                                              }).toList(), 
                                               validator: (value) =>
                                                              value == null ? 'Please select an option' : null,
                                              onChanged: (String? value){
                                                            setState(() {
                                                              displayTypeController = value ?? '';
                                                            });
                                              }
                                            ),
                                                          ),
                                ],
                              ),
                ],
              ),
            SizedBox(height: 20,),
             
          ],
        ),
        
        ],
        
      ),
      const SizedBox(height: 30,),
      CustomButton(
            onPressed: () {
              _addProductDetails(context);
            },
            buttonText: "Add Details",
            isLoading: _isLoading,
            backgroundColor: Colors.black,
          ),
        ],
      ),

    );
  }
}


