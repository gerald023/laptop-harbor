class BasicInfo{
  final String productName;
  final double price;
  final int stockQuantity;

  BasicInfo({
    required this.productName,
    required this.price,
    required this.stockQuantity,
  });

  Map<String, dynamic> toMap(){
    return {
      'productName': productName,
      'price': price,
      'stockQuantity': stockQuantity
    };
  }
}

class Battery {
  final String type; // e.g. Lithium-ion
  final int capacityWh; // e.g. 56
  final double backupHours; // e.g. 8.5
  final String chargingType; // e.g. USB-C

  Battery({
    required this.type,
    required this.capacityWh,
    required this.backupHours,
    required this.chargingType,
  });

  Map<String, dynamic> toMap(){
    return{
      'type': type,
      'capacityWh': capacityWh,
      'backupHours': backupHours,
      'chargingType': chargingType
    };
  }
}

class OperatingSystem {
  final String name; // e.g. Windows, macOS, Linux
  final String version; // e.g. Windows 11 Pro

  OperatingSystem({
    required this.name,
    required this.version,
  });

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'version': version
    };
  }
}

class BuildAndDesign {
  final String material; // e.g. Aluminum
  final String color;

  BuildAndDesign({
     required this.material,
    required this.color,
  });

  Map<String, dynamic> toMap(){
    return {
      'material': material,
      'color': color
    };
  }

}

class Memory {
  final int sizeGB; // e.g. 16
  final String type; // e.g. DDR4, LPDDR5
  final bool expandable;

  Memory({
    required this.sizeGB,
    required this.type,
    required this.expandable,
  });

  Map<String, dynamic> toMap(){
    return{
      'sizeGB': sizeGB,
      'type': type,
      'expandable': expandable
    };
  }
}

class Processor {
  final String model; // e.g. Core i7-1255U
  final double baseSpeedGHz;

  Processor({
    required this.model,
    required this.baseSpeedGHz,

  });

  Map<String, dynamic> toMap(){
    return{
      'model': model,
      'baseSpeedGHz': baseSpeedGHz
    };
  }
}

class Display {
  final double sizeInches; // e.g. 15.6
  final String resolution; // e.g. "1920x1080"
  final String type; // e.g. IPS, OLED


  Display({
    required this.sizeInches,
    required this.resolution,
    required this.type,
  });

  Map<String, dynamic> toMap(){
    return {
      'sizeInches': sizeInches,
      'resolution': resolution,
      'type': type
    };
  }
}

class ProductDetailsType{
  final BasicInfo basicInfo;
  final Battery battery;
  final OperatingSystem operatingSystem;
  final BuildAndDesign buildAndDesign;
  final Memory memory;
  final Processor processor;
  final Display display;

  ProductDetailsType({required this.basicInfo, required this.battery, required this.operatingSystem, required this.buildAndDesign, required this.memory, required this.processor, required this.display});


  Map<String, dynamic> toMap(){
    return {
      'basicInfo': basicInfo,
      'battery': battery,
      'operatingSystem': operatingSystem,
      'buildAndDesign': buildAndDesign,
      'memory': memory,
      'processor': processor,
      'display': display
    };
  }

  factory ProductDetailsType.fromMap(Map<String, dynamic> map){
  return ProductDetailsType(
  basicInfo: map['basicInfo'] ?? {}, 
  battery: map['battery'] ?? {}, 
  operatingSystem: map['operatingSystem'] ?? {}, 
  buildAndDesign: map['buildAndDesign'] ?? {}, 
  memory: map['memory']?? {}, 
  processor: map['processor'] ?? {}, 
  display: map['display'] ?? {}, 
  );
}
  
}