import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/components/custom_button.dart';
import 'package:aptech_project/components/textField_widget.dart';

class CreateProductForm extends StatefulWidget {
  const CreateProductForm({super.key});

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productInfoController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController pricePercentController = TextEditingController();

  bool _isLoading = false;
  bool _productInStock = false;

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final ProductService productService = ProductService();


  Future<void> _pickedImages() async {
    try {
      if (_selectedImages.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('can\'t upload more than three images')),
        );
        return;
      }
      final pickedFiles = await _picker.pickMultiImage();
      _selectedImages.addAll(pickedFiles.map((file) {
        return XFile(file.path);
      }));
        } catch (e) {
      print(e);
    }
  }

  // final productService = ProductService();

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        final productId = await productService.createProduct(
          productName: productNameController.text,
          productInfo: productInfoController.text,
          isProductAvailable: _productInStock,
          images: _selectedImages,
          category: categoryController.text,
          price: double.parse(priceController.text),
          discountPercent: int.parse(pricePercentController.text),
        );
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Added Successfully')),
        );
        _formKey.currentState!.reset();
        _selectedImages.clear();

        Navigator.pushNamed(context, addProductDetailsScreenRoute);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    productInfoController.dispose();
    categoryController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
          key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a new Product',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldWidget(
                  controller: productNameController,
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
                const SizedBox(
                  height: 10,
                ),
                TextfieldWidget(
                  controller: productInfoController,
                  placeholder: 'Product Info',
                  prefixIcon: const Icon(
                    Icons.medical_information_outlined,
                    color: Colors.grey,
                    size: 21,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Product\'s information';
                    } else if (value.trim().length < 10) {
                      return 'Product\'s information cannot be less than 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextfieldWidget(
                  controller: categoryController,
                  placeholder: 'Product Category',
                  prefixIcon: const Icon(
                    Icons.category_outlined,
                    color: Colors.grey,
                    size: 21,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the city\'s name';
                    } else if (value.trim().length < 3) {
                      return 'City\'s name cannot be less than 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
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
                      child: TextfieldWidget(
                        controller: pricePercentController,
                        placeholder: 'Discount (%)',
                        prefixIcon: const Icon(
                          Icons.money_off_csred_outlined,
                          color: Colors.grey,
                          size: 21,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Product\'s discount';
                          } else if (int.parse(value) < 1) {
                            return 'Product\'s discount cannot be less than 1%';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                    title: const Text('Product in stock'),
                    value: _productInStock,
                    onChanged: (value) {
                      setState(() {
                        _productInStock = value;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  onPressed: _pickedImages,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text("Pick Product Images"),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStateColor.transparent,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _selectedImages
                      .map((image) => Stack(
                            children: [
                              Image.network(
                                image.path, // Use the path for Web
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.remove(image);
                                    });
                                  },
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(height: 16.0,),
                CustomButton(
                  onPressed: _addProduct,
                  isLoading: _isLoading,
                  buttonText: 'Add Product'
                )
              ],
            ),
        );
  }
}
