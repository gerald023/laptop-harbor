import '../models/laptop.dart';
import '../models/review.dart';
import '../services/product_services.dart';

class LaptopRepository {
  // Keep fixed products
  static final List<Laptop> _fixedLaptops = [
    Laptop(
      productId: "10", // MacBook Air M2
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
      createdAt: DateTime.now().subtract(const Duration(days: 55)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "AppleFan", rating: 4.8, comment: "Perfect balance of performance and portability."),
        Review(username: "BatteryLife", rating: 4.9, comment: "All-day battery life is truly impressive."),
      ],
    ),
    Laptop(
      productId: "11", 
      productName: "MacBook Pro 16",
      productInfo: "Processor: Apple M2 Pro, RAM: 16GB, Storage: 1TB SSD, Screen: 16-inch",
      isProductAvailable: true,
      images: [
        "https://m.media-amazon.com/images/I/61lYIKPieDL._AC_SL1500_.jpg",
        "https://m.media-amazon.com/images/I/61lYIKPieDL._AC_SL1500_.jpg"
      ],
      displayImage: "https://m.media-amazon.com/images/I/61lYIKPieDL._AC_SL1500_.jpg",
      category: "Apple",
      price: 2499.99,
      discountedPrice: 2299.99,
      discountPercent: 8,
      createdBy: "admin",
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      reviews: [
        Review(username: "ProUser", rating: 4.9, comment: "Incredible performance for creative professionals."),
        Review(username: "DevEnthusiast", rating: 5.0, comment: "Best development machine I've ever used."),
      ],
    ),
  ];

  final ProductService _productService = ProductService();
  List<Laptop>? _cachedLaptops;
  DateTime? _lastFetchTime;
  Duration _cacheLifetime = Duration(minutes: 5);

  // Convert ProductModels to Laptop
  Laptop _productModelToLaptop(dynamic productModel) {
    return Laptop(
      productId: productModel.productId ?? "",
      productName: productModel.productName ?? "",
      productInfo: productModel.productInfo ?? "",
      isProductAvailable: productModel.isProductAvailable ?? true,
      images: List<String>.from(productModel.images ?? []),
      displayImage: productModel.displayImage ?? "",
      category: productModel.category ?? "Unknown",
      price: productModel.price?.toDouble() ?? 0.0,
      discountedPrice: productModel.discountedPrice?.toDouble() ?? 0.0,
      discountPercent: productModel.discountPercent ?? 0,
      createdBy: productModel.createdBy ?? "",
      createdAt: productModel.createdAt?.toDate() ?? DateTime.now(),
      updatedAt: productModel.updatedAt?.toDate() ?? DateTime.now(),
      reviews: [], // Reviews would need to be fetched separately
    );
  }

  // Maintain the original synchronous method signature but implement with async under the hood
  List<Laptop> getAllLaptops() {
    // For compatibility, return fixed laptops when called synchronously
    return List.from(_fixedLaptops);
  }

  // Original synchronous method kept for backward compatibility
  List<String> getAllBrands() {
    return _fixedLaptops.map((e) => e.category).toSet().toList();
  }

  // Original synchronous method kept for backward compatibility
  List<int> getAllRamSizes() {
    List<int> ramSizes = [];
    for (var laptop in _fixedLaptops) {
      if (laptop.productInfo.contains('RAM:')) {
        String ramInfo = laptop.productInfo.split('RAM:')[1].split(',')[0].trim();
        int ramValue = int.parse(ramInfo.replaceAll(RegExp(r'[^0-9]'), ''));
        ramSizes.add(ramValue);
      }
    }
    return ramSizes.toSet().toList()..sort();
  }
  
  // Original synchronous method kept for backward compatibility
  List<Laptop> getLaptopsByBrand(String brand) {
    return _fixedLaptops.where((laptop) => laptop.category == brand).toList();
  }
  
  // Original synchronous method kept for backward compatibility
  List<Laptop> getLaptopsByPriceRange(double minPrice, double maxPrice) {
    return _fixedLaptops.where((laptop) => 
      laptop.price >= minPrice && laptop.price <= maxPrice).toList();
  }
  
  // Original synchronous method kept for backward compatibility
  Laptop? getLaptopById(String id) {
    try {
      return _fixedLaptops.firstWhere((laptop) => laptop.productId == id);
    } catch (e) {
      return null;
    }
  }
  
  // Original synchronous method kept for backward compatibility
  List<Laptop> getLaptopsByAvailability(bool isAvailable) {
    return _fixedLaptops.where((laptop) => laptop.isProductAvailable == isAvailable).toList();
  }
  
  // Original synchronous method kept for backward compatibility
  List<Laptop> getLaptopsByDiscount(int minDiscountPercent) {
    return _fixedLaptops.where((laptop) => laptop.discountPercent >= minDiscountPercent).toList();
  }
  
  // Original synchronous method kept for backward compatibility
  List<Laptop> getRecentlyAddedLaptops(int days) {
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _fixedLaptops.where((laptop) => laptop.createdAt.isAfter(cutoffDate)).toList();
  }
  
  // New async methods - these can be used when you're ready to migrate to async

  // Async version to fetch all laptops from Firebase
  Future<List<Laptop>> fetchAllLaptops() async {
    // Check if cache is valid
    if (_cachedLaptops != null && _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheLifetime) {
      return List.from(_cachedLaptops!);
    }

    try {
      // Get products from FireStore
      final productModels = await _productService.getAllProducts();
      final firebaseLaptops = productModels.map(_productModelToLaptop).toList();
      
      // Combine fixed and Firebase laptops
      _cachedLaptops = [..._fixedLaptops, ...firebaseLaptops];
      _lastFetchTime = DateTime.now();
      
      return List.from(_cachedLaptops!);
    } catch (e) {
      print('Error fetching laptops: $e');
      // Fallback to fixed laptops if fetch fails
      return List.from(_fixedLaptops);
    }
  }

  // Async version to get all brands
  Future<List<String>> fetchAllBrands() async {
    final laptops = await fetchAllLaptops();
    return laptops.map((e) => e.category).toSet().toList();
  }

  // Async version to get all RAM sizes
  Future<List<int>> fetchAllRamSizes() async {
    final laptops = await fetchAllLaptops();
    List<int> ramSizes = [];
    for (var laptop in laptops) {
      if (laptop.productInfo.contains('RAM:')) {
        String ramInfo = laptop.productInfo.split('RAM:')[1].split(',')[0].trim();
        int ramValue = int.parse(ramInfo.replaceAll(RegExp(r'[^0-9]'), ''));
        ramSizes.add(ramValue);
      }
    }
    return ramSizes.toSet().toList()..sort();
  }
  
  // Async version to get laptops by brand
  Future<List<Laptop>> fetchLaptopsByBrand(String brand) async {
    final laptops = await fetchAllLaptops();
    return laptops.where((laptop) => laptop.category == brand).toList();
  }
  
  // Async version to get laptops by price range
  Future<List<Laptop>> fetchLaptopsByPriceRange(double minPrice, double maxPrice) async {
    final laptops = await fetchAllLaptops();
    return laptops.where((laptop) => 
      laptop.price >= minPrice && laptop.price <= maxPrice).toList();
  }
  
  // Async version to get laptop by ID
  Future<Laptop?> fetchLaptopById(String id) async {
    try {
      final laptops = await fetchAllLaptops();
      return laptops.firstWhere((laptop) => laptop.productId == id);
    } catch (e) {
      return null;
    }
  }
  
  // Async version to get laptops by availability
  Future<List<Laptop>> fetchLaptopsByAvailability(bool isAvailable) async {
    final laptops = await fetchAllLaptops();
    return laptops.where((laptop) => laptop.isProductAvailable == isAvailable).toList();
  }
  
  // Async version to get laptops by discount percentage
  Future<List<Laptop>> fetchLaptopsByDiscount(int minDiscountPercent) async {
    final laptops = await fetchAllLaptops();
    return laptops.where((laptop) => laptop.discountPercent >= minDiscountPercent).toList();
  }
  
  // Async version to get recently added laptops
  Future<List<Laptop>> fetchRecentlyAddedLaptops(int days) async {
    final laptops = await fetchAllLaptops();
    DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    return laptops.where((laptop) => laptop.createdAt.isAfter(cutoffDate)).toList();
  }
}