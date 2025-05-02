class BasicInfo {
  final String productName;
  final double price;
  final int stockQuantity;

  BasicInfo({
    required this.productName,
    required this.price,
    required this.stockQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'price': price,
      'stockQuantity': stockQuantity
    };
  }

  factory BasicInfo.fromMap(Map<String, dynamic> map) {
    return BasicInfo(
      productName: map['productName'],
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stockQuantity'],
    );
  }
}

class Battery {
  final String type;
  final int capacityWh;
  final double backupHours;
  final String chargingType;

  Battery({
    required this.type,
    required this.capacityWh,
    required this.backupHours,
    required this.chargingType,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'capacityWh': capacityWh,
      'backupHours': backupHours,
      'chargingType': chargingType
    };
  }

  factory Battery.fromMap(Map<String, dynamic> map) {
    return Battery(
      type: map['type'],
      capacityWh: map['capacityWh'],
      backupHours: (map['backupHours'] as num).toDouble(),
      chargingType: map['chargingType'],
    );
  }
}

class OperatingSystem {
  final String name;
  final String version;

  OperatingSystem({
    required this.name,
    required this.version,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'version': version
    };
  }

  factory OperatingSystem.fromMap(Map<String, dynamic> map) {
    return OperatingSystem(
      name: map['name'],
      version: map['version'],
    );
  }
}

class BuildAndDesign {
  final String material;
  final String color;

  BuildAndDesign({
    required this.material,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'material': material,
      'color': color
    };
  }

  factory BuildAndDesign.fromMap(Map<String, dynamic> map) {
    return BuildAndDesign(
      material: map['material'],
      color: map['color'],
    );
  }
}

class Memory {
  final int sizeGB;
  final String type;
  final bool expandable;

  Memory({
    required this.sizeGB,
    required this.type,
    required this.expandable,
  });

  Map<String, dynamic> toMap() {
    return {
      'sizeGB': sizeGB,
      'type': type,
      'expandable': expandable
    };
  }

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      sizeGB: map['sizeGB'],
      type: map['type'],
      expandable: map['expandable'],
    );
  }
}

class Processor {
  final String model;
  final double baseSpeedGHz;

  Processor({
    required this.model,
    required this.baseSpeedGHz,
  });

  Map<String, dynamic> toMap() {
    return {
      'model': model,
      'baseSpeedGHz': baseSpeedGHz
    };
  }

  factory Processor.fromMap(Map<String, dynamic> map) {
    return Processor(
      model: map['model'],
      baseSpeedGHz: (map['baseSpeedGHz'] as num).toDouble(),
    );
  }
}

class Display {
  final double sizeInches;
  final String resolution;
  final String type;

  Display({
    required this.sizeInches,
    required this.resolution,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'sizeInches': sizeInches,
      'resolution': resolution,
      'type': type
    };
  }

  factory Display.fromMap(Map<String, dynamic> map) {
    return Display(
      sizeInches: (map['sizeInches'] as num).toDouble(),
      resolution: map['resolution'],
      type: map['type'],
    );
  }
}

class ProductDetailsModel {
    final String? productDetailsID;
   final String? productId;
  final BasicInfo basicInfo;
  final Battery battery;
  final OperatingSystem operatingSystem;
  final BuildAndDesign buildAndDesign;
  final Memory memory;
  final Processor processor;
  final Display display;

 ProductDetailsModel({this.productDetailsID, 
   this.productId, required this.basicInfo, required this.battery, required this.operatingSystem, required this.buildAndDesign, required this.memory, required this.processor, required this.display});

  Map<String, dynamic> toMap() {
    return {
      'productDetailsID': productDetailsID,
      'productId': productId,
      'basicInfo': basicInfo.toMap(),
      'battery': battery.toMap(),
      'operatingSystem': operatingSystem.toMap(),
      'buildAndDesign': buildAndDesign.toMap(),
      'memory': memory.toMap(),
      'processor': processor.toMap(),
      'display': display.toMap(),
    };
  }

  factory ProductDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailsModel(
      productDetailsID: map['productDetailsID'] ?? '',
   productId: map['productId'] ?? '',
        basicInfo: BasicInfo.fromMap(map['basicInfo']) , 
   battery: Battery.fromMap(map['batteryInfo']) , 
   operatingSystem: OperatingSystem.fromMap(map['OSInfo']), 
   buildAndDesign: BuildAndDesign.fromMap(map['designInfo'] ), 
   memory: Memory.fromMap(map['memoryInfo']), 
   processor: Processor.fromMap(map['processorInfo']), 
   display: Display.fromMap(map['displayInfo']) , 
    );
  }
}
