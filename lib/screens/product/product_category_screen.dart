import 'package:aptech_project/components/product/product_card.dart';
import 'package:aptech_project/constants.dart';
import 'package:aptech_project/models/product_models.dart';
import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';


class ProductCategoryScreen extends StatefulWidget {
  final String category;
  const ProductCategoryScreen({super.key, required this.category});
  

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
   List<ProductModels> products = [];
  Future<void> getProductsByCategory(String category) async{
    try{
      final res = await ProductService().getProductsByCategory(category);
      setState(() {
        products = res;
      });
    }catch(e){
      print('error in getting product by category: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Text('No ${widget.category} Laptops');
    }
    return  Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [],
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisExtent: defaultPadding,
                crossAxisSpacing: defaultPadding,
                childAspectRatio: 0.66,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index){
                  return ProductCard(
                    image: products[index].images[0], 
                    brandName: products[index].category,
                    title: products[index].productName, 
                    price: products[index].price,
                    dicountpercent: products[index].discountPercent,
                    priceAfetDiscount: products[index].discountedPrice,
                    press: (){
                      Navigator.pushNamed(context, productDetailsScreenRoute,
                        arguments: products[index].productId
                      );
                    }
                    );
                }
              ),
              ),
          )
        ],
      ),
    );
  }
}