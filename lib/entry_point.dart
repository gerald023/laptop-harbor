import 'package:animations/animations.dart';
import 'package:aptech_project/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aptech_project/constants.dart';
import 'package:aptech_project/route/screen_export.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();


  final List _pages = const [
    HomeScreen(),
    DiscoverScreen(),
    BookmarkScreen(),
    // EmptyCartScreen(), // if Cart is empty
    // CartScreen(),
    NewCartScreen(),
    UserProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: Row(
          children: [
            SvgPicture.asset(
              "logo/laptop_harbor.svg",
              colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!, BlendMode.srcIn),
              height: 20,
              width: 100,
            ),
            const Text('LaptopHarbor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Roboto'
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async{
              String? accountId = await _secureStorage.read(key: 'accountId');
                  Navigator.pushNamed(context, fundAccountScreenRoute,
                      arguments: accountId);
              // Navigator.pushNamed(context, notificationsScreenRoute);
              
            },
            icon: SvgPicture.asset(
              "icons/Notification.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
        ],
      ),
      // body: _pages[_currentIndex],
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Shop.svg"),
              activeIcon: svgIcon("assets/icons/Shop.svg", color: primaryColor),
              label: "Shop",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Category.svg"),
              activeIcon:
                  svgIcon("assets/icons/Category.svg", color: primaryColor),
              label: "Discover",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/love.svg"),
              activeIcon:
                  svgIcon("assets/icons/love.svg", color: primaryColor),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Bag.svg"),
              activeIcon: svgIcon("assets/icons/Bag.svg", color: primaryColor),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Profile.svg"),
              activeIcon:
                  svgIcon("assets/icons/Profile.svg", color: primaryColor),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
