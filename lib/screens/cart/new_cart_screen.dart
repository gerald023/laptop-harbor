import 'package:aptech_project/components/custom_button.dart';
import 'package:aptech_project/models/cart_model.dart';
import 'package:aptech_project/models/transaction_model.dart';
import 'package:aptech_project/route/screen_export.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:aptech_project/services/transactions_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';
// import './components/cart_product_quantity.dart';


const uuid = Uuid();
class NewCartScreen extends StatefulWidget {
  const NewCartScreen({super.key});

  @override
  State<NewCartScreen> createState() => _NewCartScreenState();
}

class _NewCartScreenState extends State<NewCartScreen> {
  Future<CartModel?>? _cartFuture; // Make it a Future that can be null
  bool isLoading = false;

  Future<void> checkout(CartModel cart) async{
    try{
      setState(() {
        isLoading = true;
      });
      final TransactionModel transactionData = TransactionModel(
        amount: cart.totalPrice,
        purpose: 'purchase',
        paymentMethod: 'wallet',
        reference: uuid.v8(),
        currency: 'USD',
        description: 'purchasing cart items.',
        );
        final res = await TransactionService().placeOrder(transactionData, cart);
        switch (res) {
          case 'No delivery address found':
             Navigator.pushNamed(context, addressScreenRoute);
            break;
            case 'Order placed successfully':
             Navigator.pushNamed(context, orderHistoryScreenRoute);
            break;
            case 'Transaction failed':
             Navigator.pushNamed(context, transactionFailedScreenRoute);
            break;
          default:
        }
        print(res);
        setState(() {
        isLoading = false;
      });
    }catch(e){
      print('error while on checkout: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _cartFuture = ProductService().getCartItems(); // Initialize the Future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<CartModel?>(
          future: _cartFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading indicator
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading cart: ${snapshot.error}')); // Show error message
            }else if(!snapshot.hasData || snapshot.data == null || snapshot.data!.cartItems.isEmpty){
              return const EmptyCartScreen();
            } 
            else if (snapshot.hasData && snapshot.data != null) {
              final cartList = snapshot.data!; // Now it's safe to use the null check operator

              return ListView.builder(
                itemCount: cartList.cartItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: Key(cartList.cartItems[index].productId.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async{
                      await ProductService().removeCartItem(cartList.cartItems[index].productId);
                      setState(() {
                        _cartFuture = ProductService().getCartItems();
                      });
                    },
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          SvgPicture.string(trashIcon),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        CartCard(
                          price: cartList.cartItems[index].price,
                          productImage: cartList.cartItems[index].productImage,
                          productName: cartList.cartItems[index].productName,
                          quantity: cartList.cartItems[index].quantity,
                          productId: cartList.cartItems[index].productId,
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Your cart is empty.')); // Show empty cart message
            }
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<CartModel?>(
        future: _cartFuture,
        builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.shrink(); // Don’t show anything while loading
    }else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.cartItems.isEmpty) {
      return const SizedBox.shrink(); // Hide bottom navigation if cart is empty or null
    }
    if (snapshot.hasData && snapshot.data != null) {
            return CheckoutCard(
              totalPrice: snapshot.data!.totalPrice,
              totalQuantity: snapshot.data!.totalItem,
              onPress: () {
                checkout(snapshot.data as CartModel);
              },
              isLoading: isLoading,
            );
          } else {
            return const SizedBox.shrink(); // Or some other placeholder if cart data isn't loaded
          }
        },
      ),
    );
  }
}

// ... (CartCard and CheckoutCard widgets remain the same)

class CartCard extends StatefulWidget {
  const CartCard({
    super.key, required this.productName, required this.productImage, required this.price, required this.quantity, required this.productId,
  });

  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String productId;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  double? unitPrice;
  late int newQuantity;
  final ProductService _productService = ProductService();
  
  Future<void> getProductPrice()async{
    // final data = await ProductService().getProductById(widget.productId);
    // setState(() {
    //   unitPrice = data!.discountedPrice < 1 ? data.price : data.discountedPrice;
    // }); 
     try {
      final product = await _productService.getProductById(widget.productId);
      if (product != null) {
        setState(() {
          unitPrice = product.discountedPrice < 1
              ? product.price
              : product.discountedPrice;
        });
      } else {
        // Handle the case where the product is not found.
        print('Product not found: ${widget.productId}');
        // You might want to show an error message to the user.
      }
    } catch (e) {
      print('Error fetching product price: $e');
      // Handle the error appropriately (e.g., show a snackbar).
    } 
  }

  Future<void> increaseCartQauntity(bool isIncrease) async{
    if (unitPrice == null) return;

    int updatedQuantity = newQuantity; 
     
       if (isIncrease) {
      updatedQuantity++;
    } else {
      updatedQuantity--;
    }
    if (updatedQuantity >= 0) { // Prevent negative quantities.
      try {
        // Await the quantity update and get the new cart data
        final updatedCart = await _productService.updateCartItemQuantity(widget.productId, updatedQuantity);

        if (updatedCart != null) {
           setState(() {
            newQuantity = updatedQuantity;
          });
        }
       
      } catch (e) {
        print('Error updating quantity: $e');
        // Handle the error (e.g., show a snackbar to the user)
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update quantity: $e'), backgroundColor: Colors.red,),
          );
        }
       
      }
    }
  }

  @override
  void initState() {
    super.initState();
    newQuantity = widget.quantity;
    getProductPrice();
  }

  @override
  Widget build(BuildContext context) {
        final totalPrice = unitPrice != null ? unitPrice! * newQuantity : widget.price * newQuantity;
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(widget.productImage),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "unit Price: \$${unitPrice ?? widget.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                
                Text('#${widget.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),

                  const SizedBox(width: 10,),
                  Text('total: \$$totalPrice')
              ],
            )
          ],
        )
      ],
    );
  }
}

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    super.key, required this.totalQuantity, required this.totalPrice, required this.onPress, required this.isLoading,
  });
  final int totalQuantity;
  final double totalPrice;
  final VoidCallback onPress;
  final bool isLoading;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.string(receiptIcon),
                ),
                const Spacer(),
                const Text("Add voucher code"),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.black,
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                 Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Total: $totalQuantity \n",
                      children: [
                        TextSpan(
                          text: "\$ $totalPrice",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    buttonText: 'Checkout',
                    onPressed: onPress,
                    isLoading: isLoading,
                    backgroundColor: Colors.black,
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}






const receiptIcon =
    '''<svg width="16" height="20" viewBox="0 0 16 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M2.18 19.85C2.27028 19.9471 2.3974 20.0016 2.53 20H2.82C2.9526 20.0016 3.07972 19.9471 3.17 19.85L5 18C5.19781 17.8082 5.51219 17.8082 5.71 18L7.52 19.81C7.61028 19.9071 7.7374 19.9616 7.87 19.96H8.16C8.2926 19.9616 8.41972 19.9071 8.51 19.81L10.32 18C10.5136 17.8268 10.8064 17.8268 11 18L12.81 19.81C12.9003 19.9071 13.0274 19.9616 13.16 19.96H13.45C13.5826 19.9616 13.7097 19.9071 13.8 19.81L15.71 18C15.8947 17.8137 15.9989 17.5623 16 17.3V1C16 0.447715 15.5523 0 15 0H1C0.447715 0 0 0.447715 0 1V17.26C0.00368349 17.5248 0.107266 17.7784 0.29 17.97L2.18 19.85ZM9 11.5C9 11.7761 8.77614 12 8.5 12H4.5C4.22386 12 4 11.7761 4 11.5V10.5C4 10.2239 4.22386 10 4.5 10H8.5C8.77614 10 9 10.2239 9 10.5V11.5ZM11.5 8C11.7761 8 12 7.77614 12 7.5V6.5C12 6.22386 11.7761 6 11.5 6H4.5C4.22386 6 4 6.22386 4 6.5V7.5C4 7.77614 4.22386 8 4.5 8H11.5Z" fill="#FF7643"/>
</svg>
''';

const trashIcon =
    '''<svg width="18" height="20" viewBox="0 0 18 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10.7812 15.6604V7.16981C10.7812 6.8566 11.0334 6.60377 11.3438 6.60377C11.655 6.60377 11.9062 6.8566 11.9062 7.16981V15.6604C11.9062 15.9736 11.655 16.2264 11.3438 16.2264C11.0334 16.2264 10.7812 15.9736 10.7812 15.6604ZM6.09375 15.6604V7.16981C6.09375 6.8566 6.34594 6.60377 6.65625 6.60377C6.9675 6.60377 7.21875 6.8566 7.21875 7.16981V15.6604C7.21875 15.9736 6.9675 16.2264 6.65625 16.2264C6.34594 16.2264 6.09375 15.9736 6.09375 15.6604ZM15 16.6038C15 17.8519 13.9903 18.8679 12.75 18.8679H5.25C4.00969 18.8679 3 17.8519 3 16.6038V3.96226H15V16.6038ZM7.21875 1.50943C7.21875 1.30094 7.38656 1.13208 7.59375 1.13208H10.4062C10.6134 1.13208 10.7812 1.30094 10.7812 1.50943V2.83019H7.21875V1.50943ZM17.4375 2.83019H11.9062V1.50943C11.9062 0.677359 11.2331 0 10.4062 0H7.59375C6.76688 0 6.09375 0.677359 6.09375 1.50943V2.83019H0.5625C0.252187 2.83019 0 3.08302 0 3.39623C0 3.70943 0.252187 3.96226 0.5625 3.96226H1.875V16.6038C1.875 18.4764 3.38906 20 5.25 20H12.75C14.6109 20 16.125 18.4764 16.125 16.6038V3.96226H17.4375C17.7488 3.96226 18 3.70943 18 3.39623C18 3.08302 17.7488 2.83019 17.4375 2.83019Z" fill="#FF4848"/>
</svg>
''';
