import 'package:firebase_core/firebase_core.dart';
import 'package:aptech_project/firebase_options.dart';
import 'package:aptech_project/components/skleton/product/products_skelton.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:aptech_project/components/product/product_card.dart';
// import 'package:aptech_project/models/product_model.dart';
import 'package:aptech_project/route/screen_export.dart';
import 'package:aptech_project/models/product_models.dart';



import '../../../../constants.dart';

class PopularProducts extends StatefulWidget {
   PopularProducts({
    super.key,
  });

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}


class _PopularProductsState extends State<PopularProducts> {
  // final ProductService productService = ProductService();
  List<ProductModels>? popularProductData;

  Future<void> fetchPopularProducts() async{
    
    try{
      final data = await ProductService().getPopularProducts();
      // print(data);
      setState(() {
        popularProductData = data;
      });
    }catch(e){
      print('error in the popular Product section: $e');
    }
  }
  Future<void> getPopularProducts() async {
      await fetchPopularProducts();
  }
@override
void initState() {
  super.initState();
  getPopularProducts();
}


  @override
  Widget build(BuildContext context) {
    if (popularProductData == null) {
      return const ProductsSkelton();
    }
    if (popularProductData!.isEmpty) {
      return const Text('No Popular Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black
          ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        
        // const ProductsSkelton(),
         SizedBox(
          height: 210,
           child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoPopularProducts on models/ProductModel.dart
            itemCount: popularProductData!.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == popularProductData!.length - 1
                    ? defaultPadding
                    : 0,
              ),
              child: ProductCard(
                image: popularProductData![index].images[0],
                brandName: popularProductData![index].productName,
                title: popularProductData![index].productInfo,
                price: popularProductData![index].price,
                priceAfetDiscount: popularProductData![index].discountedPrice,
                dicountpercent: popularProductData![index].discountPercent,
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: popularProductData![index].productId);
                },
              ),
            ),
                   ),
         ),
      ],
    );
  }


}



  