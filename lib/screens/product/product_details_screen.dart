import 'package:aptech_project/components/skleton/product/products_skelton.dart';
import 'package:aptech_project/models/product_models.dart';
import 'package:aptech_project/types/product_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aptech_project/components/buy_full_ui_kit.dart';
import 'package:aptech_project/components/cart_button.dart';
import 'package:aptech_project/components/custom_modal_bottom_sheet.dart';
import 'package:aptech_project/components/product/product_card.dart';
import 'package:aptech_project/constants.dart';
import 'package:aptech_project/screens/product/product_returns_screen.dart';
import 'package:aptech_project/route/screen_export.dart';
import 'package:aptech_project/services/product_services.dart';
import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../components/review_card.dart';
import 'product_buy_now_screen.dart';
import './product_information_screen.dart';


class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId });

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductDetailsModel? productDetails;
  ProductModels? _productModels;
  List<String>? _productImages;

  Future<void> getProductDetails () async{
    try {
      final data = await ProductService().getProductDetail(widget.productId);
      final product = await ProductService().getProductById(widget.productId);
      // print(product);
      print('product Id: ${widget.productId}');
      // print(data!.buildAndDesign);
      print( 'product details:  ${data!.basicInfo.productName}');
      setState(() {
        productDetails = data;
        _productModels = product;
        _productImages = product!.images;
      });
    } catch (e) {
      print('error while getting product Id: $e');
    }
  }
  
  @override
  void initState() {
    super.initState();
    getProductDetails();
  }
   
  @override
  Widget build(BuildContext context) {
    if (productDetails == null) {
      return const ProductsSkelton();
    }
    // final productId = ModalRoute.of(context)!.settings.arguments as String;
    // print(productId);
    // getProductDetails(productId);
    else {
      return Scaffold(
      bottomNavigationBar: true
          ? CartButton(
              price: 140,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductBuyNowScreen(),
                );
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
            ProductImages(
              images: _productImages ?? []
            ),
            ProductInfo(
              brand: "",
              title: _productModels!.productName,
              isAvailable: true,
              description: _productModels!.productInfo,
              rating: 4.4,
              numOfReviews: 126,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                child:   ProductInformationScreen(productDetails: productDetails!,)
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child:  const ProductReturnsScreen(),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.3,
                  numOfReviews: 128,
                  numOfFiveStar: 80,
                  numOfFourStar: 30,
                  numOfThreeStar: 5,
                  numOfTwoStar: 4,
                  numOfOneStar: 1,
                ),
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(context, productReviewsScreenRoute);
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == 4 ? defaultPadding : 0),
                    child: ProductCard(
                      image: productDemoImg2,
                      title: "Sleeveless Tiered Dobby Swing Dress",
                      brandName: "LIPSY LONDON",
                      price: 24.65,
                      priceAfetDiscount: index.isEven ? 20.99 : null,
                      dicountpercent: index.isEven ? 25 : null,
                      press: () {},
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
    }
  }
}
