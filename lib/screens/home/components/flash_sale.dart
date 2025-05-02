import 'package:aptech_project/components/skleton/product/products_skelton.dart';
import 'package:aptech_project/models/product_models.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/route/route_constants.dart';

import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({
    super.key,
  });

  @override
  State<FlashSale> createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
   List<ProductModels>? popularProductData;

    Future<void> fetchCheapProducts() async{
    
    try{
      final data = await ProductService().getCheapProducts();
      // print(data);
      setState(() {
        popularProductData = data;
      });
    }catch(e){
      print('error in the popular Product section: $e');
    }
  }
  Future<void> getCheapProducts() async {
      await fetchCheapProducts();
  }
@override
void initState() {
  super.initState();
  getCheapProducts();
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
         const SizedBox(height: defaultPadding / 2),
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
