import '../models/laptop.dart';
import '../models/review.dart';

class LaptopRepository {
  static final List<Laptop> allLaptops = [
    // Dell Laptops
    Laptop(
      productId: "1", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "2", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "3", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    
    // HP Laptops
    Laptop(
      productId: "4", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "5", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "6", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),

    // Alienware Laptops
    Laptop(
      productId: "7", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "8", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "9", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),

    // Apple Laptops
    Laptop(
      productId: "10", // Original MacBook Air M2
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "11", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "12", // Original ID kept
      productName: "MacBook Air M2",
      productInfo: "Processor: Apple M2, RAM: 8GB, Storage: 512GB SSD, Screen: 13.6-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/71f5Eu5lJSL._AC_SL1500_.jpg",
      category: "Apple",
      price: 1199.99,
      discountedPrice: 1149.99,
      discountPercent: 4,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
  ];

  List<Laptop> getAllLaptops() {
    return List.from(allLaptops);
  }

  List<String> getAllBrands() {
    return allLaptops.map((e) => e.category).toSet().toList();
  }

  List<int> getAllRamSizes() {
    // Extract RAM values from productInfo string
    List<int> ramSizes = [];
    for (var laptop in allLaptops) {
      if (laptop.productInfo.contains('RAM:')) {
        String ramInfo = laptop.productInfo.split('RAM:')[1].split(',')[0].trim();
        int ramValue = int.parse(ramInfo.replaceAll(RegExp(r'[^0-9]'), ''));
        ramSizes.add(ramValue);
      }
    }
    return ramSizes.toSet().toList()..sort();
  }
  
  List<Laptop> getLaptopsByBrand(String brand) {
    return allLaptops.where((laptop) => laptop.category == brand).toList();
  }
  
  List<Laptop> getLaptopsByPriceRange(double minPrice, double maxPrice) {
    return allLaptops.where((laptop) => 
      laptop.price >= minPrice && laptop.price <= maxPrice).toList();
  }
  
  Laptop? getLaptopById(String id) {
    try {
      return allLaptops.firstWhere((laptop) => laptop.productId == id);
    } catch (e) {
      return null;
    }
  }
  
  // New methods for the updated model
  List<Laptop> getLaptopsByAvailability(bool isAvailable) {
    return allLaptops.where((laptop) => laptop.isProductAvailable == isAvailable).toList();
  }
  
  List<Laptop> getLaptopsByDiscount(int minDiscountPercent) {
    return allLaptops.where((laptop) => laptop.discountPercent >= minDiscountPercent).toList();
  }
  
  List<Laptop> getRecentlyAddedLaptops(int days) {
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    return allLaptops.where((laptop) => laptop.createdAt.isAfter(cutoffDate)).toList();
  }
}