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
    // print(await productService.getPopularProducts());
    // return await productService.getPopularProducts();
    try{
      // final data = await ProductService().getPopularProducts();
      // print(data);
      setState(() {
        // popularProductData = data;
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
  initializeAndLoad();
}

Future<void> initializeAndLoad() async {
  // Wait until Firebase is ready
  await Future.delayed(Duration.zero); // ensures context is ready if needed

  // Check if Firebase is already initialized (safe for web/mobile)
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await getPopularProducts();
}

  @override
  Widget build(BuildContext context) {
    // if (popularProductData == null) {
    //   return const Text('No Popular Product!');
    // }
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
         ListView.builder(
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
              priceAfetDiscount: popularProductData![index].newDiscountPrice,
              dicountpercent: popularProductData![index].discountPercent,
              press: () {
                Navigator.pushNamed(context, productDetailsScreenRoute,
                    arguments: index.isEven);
              },
            ),
          ),
        ),
      ],
    );
  }

  
}



  