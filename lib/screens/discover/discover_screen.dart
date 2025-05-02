import 'package:aptech_project/components/product/product_card.dart';
import 'package:aptech_project/models/product_model.dart';
import 'package:aptech_project/models/product_models.dart';
import 'package:aptech_project/route/route_constants.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:aptech_project/theme/input_decoration_theme.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/constants.dart';
import 'package:aptech_project/models/category_model.dart';
import 'package:aptech_project/screens/search/components/search_form.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/expansion_category.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
TextEditingController searchController = TextEditingController();
 List<ProductModels> allProducts = [];

  Future<void> searchProduct(String query)async{
    try{
      final products = await ProductService().searchProduct(query);
      setState(() {
        allProducts = products;
      });
    }catch(e){
      print('error in searching products: $e');
    }
  }

@override
  void initState() {
    super.initState();
    searchProduct(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Form(
                      child: TextFormField(
                autofocus: true,
                controller: searchController,
                focusNode: FocusNode(),
                enabled: true,
                onChanged: (value){
                  searchProduct(value);
                },
                onSaved: (value){
                  searchProduct(value!);
                },
                onFieldSubmitted: (value){
                  searchProduct(value);
                },
                // validator: (value){},
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Find something...",
                  filled: false,
                  border: secodaryOutlineInputBorder(context),
                  enabledBorder: secodaryOutlineInputBorder(context),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(
                      "assets/icons/Search.svg",
                      height: 24,
                      color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 40,
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 24,
                          child: VerticalDivider(width: 1),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: (){},
                            icon: SvgPicture.asset(
                              "assets/icons/Filter.svg",
                              height: 24,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                      ),
                    ),
              ),

                  
                  // While loading use 👇
                  // const Expanded(
                  //   child: DiscoverCategoriesSkelton(),
                  // ),
               
            ),
            SliverPadding(
                     padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                        "Products",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
            ),
                  ),

          if (allProducts.isEmpty)
              const SliverToBoxAdapter(
            child: Center(child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No products found'),
            )),
          )
        else
            SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
                childAspectRatio: 0.66,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ProductCard(
                    image: allProducts[index].images[0],
                    brandName: allProducts[index].productName,
                    title: allProducts[index].productInfo,
                    price: allProducts[index].price,
                    priceAfetDiscount:
                        allProducts[index].discountedPrice,
                    dicountpercent: allProducts[index].discountPercent,
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute,
                        arguments: allProducts[index].productId
                      );
                    },
                  );
                },
                childCount: allProducts.length,
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
