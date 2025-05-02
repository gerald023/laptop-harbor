import 'package:aptech_project/models/product_models.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:aptech_project/types/product_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aptech_project/components/cart_button.dart';
import 'package:aptech_project/components/custom_modal_bottom_sheet.dart';
import 'package:aptech_project/components/network_image_with_loader.dart';
import 'package:aptech_project/screens/product/added_to_cart_message_screen.dart';
import 'package:aptech_project/screens/product/components/product_list_tile.dart';
import 'package:aptech_project/screens/product/location_permission_store_availability_screen.dart';
import 'package:aptech_project/screens/product/size_guide_screen.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  final ProductModels productModels;
  final ProductDetailsModel productDetailsModel;
  const ProductBuyNowScreen({super.key, required this.productModels, required this.productDetailsModel});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int productQuantity = 1;
  late final double price;
  late final double totalPrice;

  void getCartInfo (){
    setState(() {
      price =  widget.productModels.discountedPrice == 0 ? widget.productModels.price : widget.productModels.discountedPrice;
      totalPrice = price * productQuantity;
    });
  }
  void increaseCartQauntity(bool isIncrease){
    if (isIncrease && productQuantity < widget.productDetailsModel.basicInfo.stockQuantity) {
      setState(() {
      productQuantity++;
    });
    }
    else if(!isIncrease && productQuantity > 1){
      setState(() {
      productQuantity--;
    });
    }
  }
  @override
  void initState() {
    super.initState();
    getCartInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: price,
        title: "Add to cart",
        subTitle: "Total price: $totalPrice",
        press: () async{
          ProductService().addProductToCart(widget.productModels.productId, productQuantity);
          customModalBottomSheet(
            context,
            isDismissible: false,
            
            child: const AddedToCartMessageScreen(),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Text(
                  widget.productModels.productName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                 SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: NetworkImageWithLoader(widget.productModels.images[0]),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: UnitPrice(
                            price: widget.productModels.price,
                            priceAfterDiscount: widget.productModels.discountedPrice,
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: productQuantity,
                          onIncrement: () {
                            increaseCartQauntity(true);
                          },
                          onDecrement: () {
                            increaseCartQauntity(false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: SelectedColors(
                    colors: const [
                      Color(0x00000000),
                      Color.fromARGB(255, 118, 124, 97),
                      Color.fromARGB(255, 209, 68, 3),
                      Color.fromARGB(255, 14, 102, 96),
                      Color.fromARGB(255, 10, 33, 238),
                    ],
                    selectedColorIndex: 2,
                    press: (value) {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: const ["14\"", "15\"", "16\"",],
                    selectedIndex: 1,
                    press: (value) {},
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Size guide",
                    svgSrc: "assets/icons/Sizeguid.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const SizeGuideScreen(),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Select a size to check store availability and In-Store pickup options.")
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Check stores",
                    svgSrc: "assets/icons/Stores.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const LocationPermissonStoreAvailabilityScreen(),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }
}
