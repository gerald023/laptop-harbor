import 'package:flutter/material.dart';
import '../../data/laptop_repository.dart';
import '../../models/laptop.dart';
import 'widgets/laptop_grid_item.dart';
import 'laptop_detail_page.dart';

class LaptopListPage extends StatefulWidget {
  @override
  _LaptopListPageState createState() => _LaptopListPageState();
}

class _LaptopListPageState extends State<LaptopListPage> {
  final LaptopRepository _repository = LaptopRepository();
  List<Laptop> filteredLaptops = [];
  String searchQuery = '';
  RangeValues priceRange = RangeValues(500, 3000);
  List<String> selectedBrands = [];
  List<int> selectedRamSizes = [];

  @override
  void initState() {
    super.initState();
    filteredLaptops = _repository.getAllLaptops();
  }

  void filterLaptops() {
    setState(() {
      filteredLaptops = _repository.getAllLaptops().where((laptop) {
        // Check search query
        final nameMatches = laptop.name.toLowerCase().contains(searchQuery.toLowerCase());
        final brandMatches = laptop.brand.toLowerCase().contains(searchQuery.toLowerCase());
        final processorMatches = laptop.processor.toLowerCase().contains(searchQuery.toLowerCase());
        final searchMatches = nameMatches || brandMatches || processorMatches;
        
        // Check price range
        final priceMatches = laptop.price >= priceRange.start && laptop.price <= priceRange.end;
        
        // Check brand filter
        final brandFilterMatches = selectedBrands.isEmpty || selectedBrands.contains(laptop.brand);
        
        // Check RAM filter
        final ramFilterMatches = selectedRamSizes.isEmpty || selectedRamSizes.contains(laptop.ram);
        
        return searchMatches && priceMatches && brandFilterMatches && ramFilterMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laptop Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search laptops',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                filterLaptops();
              },
            ),
          ),
          // Brand quick filters
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: _repository.getAllBrands().map((brand) {
                final isSelected = selectedBrands.contains(brand);
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FilterChip(
                    label: Text(brand),
                    selected: isSelected,
                    selectedColor: Colors.blue.shade100,
                    checkmarkColor: Colors.blue.shade800,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedBrands.add(brand);
                        } else {
                          selectedBrands.remove(brand);
                        }
                        filterLaptops();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: filteredLaptops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.laptop, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No laptops found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              searchQuery = '';
                              priceRange = RangeValues(500, 3000);
                              selectedBrands = [];
                              selectedRamSizes = [];
                              filteredLaptops = _repository.getAllLaptops();
                            });
                          },
                          child: Text('Reset Filters'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: filteredLaptops.length,
                    itemBuilder: (context, index) {
                      final laptop = filteredLaptops[index];
                      return LaptopGridItem(
                        laptop: laptop,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LaptopDetailPage(laptop: laptop),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // Get all available brands and RAM sizes for filter options
    final brands = _repository.getAllBrands();
    final ramSizes = _repository.getAllRamSizes();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Filter Laptops'),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price Range',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${priceRange.start.round()}'),
                          Text('\$${priceRange.end.round()}'),
                        ],
                      ),
                      RangeSlider(
                        values: priceRange,
                        min: 500,
                        max: 3000,
                        divisions: 25,
                        labels: RangeLabels(
                          '\$${priceRange.start.round()}',
                          '\$${priceRange.end.round()}',
                        ),
                        onChanged: (values) {
                          setDialogState(() {
                            priceRange = values;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Brand',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: brands.map((brand) {
                          return FilterChip(
                            label: Text(brand),
                            selected: selectedBrands.contains(brand),
                            selectedColor: Colors.blue.shade100,
                            checkmarkColor: Colors.blue.shade800,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  selectedBrands.add(brand);
                                } else {
                                  selectedBrands.remove(brand);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'RAM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: ramSizes.map((ram) {
                          return FilterChip(
                            label: Text('${ram}GB'),
                            selected: selectedRamSizes.contains(ram),
                            selectedColor: Colors.blue.shade100,
                            checkmarkColor: Colors.blue.shade800,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  selectedRamSizes.add(ram);
                                } else {
                                  selectedRamSizes.remove(ram);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Reset'),
                  onPressed: () {
                    setDialogState(() {
                      priceRange = RangeValues(500, 3000);
                      selectedBrands = [];
                      selectedRamSizes = [];
                    });
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Apply'),
                  onPressed: () {
                    filterLaptops();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}