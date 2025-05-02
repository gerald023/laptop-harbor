import 'package:aptech_project/route/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/constants.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';
import 'components/flash_sale.dart';
import 'components/best_sellers.dart';
import 'components/most_popular.dart';
// import 'package:aptech_project/route/screen_export.dart';
import 'package:aptech_project/components/Banner/S/banner_s_style_1.dart';

import 'package:aptech_project/components/Banner/S/banner_s_style_5.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            SliverToBoxAdapter(child: PopularProducts()),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // While loading use 👇
                  // const BannerMSkelton(),
                  BannerSStyle1(
                    title: "New \narrival",
                    subtitle: "SPECIAL OFFER",
                    discountParcent: 50,
                    image: 'https://res.cloudinary.com/dbjehxk0f/image/upload/v1745369026/products/r7xeb6vtrli3cn4qubhf.webp',
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: 'ad25a081-b618-4f0f-bc44-d002d24892b3');
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                  // We have 4 banner styles, all in the pro version
                ],
              ),
            ),
            const SliverToBoxAdapter(child: FlashSale()),
            SliverToBoxAdapter(child: PopularProducts()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),

                  const SizedBox(height: defaultPadding / 4),
                  // While loading use 👇
                  // const BannerSSkelton(),
                  BannerSStyle5(
                    title: "Black \nfriday",
                    subtitle: "50% Off",
                    image: 'https://i.postimg.cc/FK3rNf0t/black-laptop-is-stage-with-bright-neon-sign-that-says-black-friday-sale-569412-825.jpg',
                    bottomText: "Collection".toUpperCase(),
                    press: () {
                      // Navigator.pushNamed(context, '/onSaleScreenRoute');
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}