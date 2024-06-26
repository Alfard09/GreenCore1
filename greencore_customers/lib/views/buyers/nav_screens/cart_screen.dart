import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:greencore_1/utils/float_notification.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:greencore_1/views/buyers/inner_screens/checkout_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Center(
          child: Text(
            'Cart Screen',
            style: TextStyle(color: Colors.green.shade600),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartProvider.removeAllItem();
              //  showSnack(context, 'All Item removed from cart');
            },
            icon: Icon(
              CupertinoIcons.delete_solid,
              color: Colors.red.shade900,
            ),
          ),
        ],
      ),
      body: _cartProvider.getCartItem.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: ((context, index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Card(
                      elevation: 2,
                      child: SizedBox(
                        height: 150,
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(cartData.imageUrl[0]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: Text(
                                        cartData.productName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      "₹" +
                                          " " +
                                          cartData.price.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    if (cartData.productSize != null &&
                                        cartData.productSize!.isNotEmpty)
                                      Container(
                                        height: 25,
                                        width: 50,
                                        child: OutlinedButton(
                                          onPressed: null,
                                          child: Text(
                                            cartData.productSize.toString(),
                                            style: TextStyle(
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.w600),
                                            // Use an empty string if null
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 140,
                                          decoration: BoxDecoration(
                                            //  color: Colors.green.shade900,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: IconButton(
                                                    key: Key('decrementKey'),
                                                    onPressed:
                                                        cartData.quantity == 1
                                                            ? null
                                                            : () {
                                                                _cartProvider
                                                                    .decrement(
                                                                        cartData);
                                                              },
                                                    icon: Icon(
                                                      CupertinoIcons.minus,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(
                                                thickness: 1,
                                                color: Colors.grey.shade500,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    cartData.quantity
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green.shade800),
                                                  ),
                                                ),
                                              ),
                                              VerticalDivider(
                                                thickness: 1,
                                                color: Colors.grey.shade500,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: IconButton(
                                                    key: Key('incrementKey'),
                                                    onPressed: cartData
                                                                .productQuantity <= //it was ==
                                                            cartData.quantity
                                                        ?
                                                        // null
                                                        () {
                                                            showErrorSnack(
                                                                context,
                                                                'Product quantity limit reached');
                                                            // ScaffoldMessenger.of(
                                                            //         context)
                                                            //     .showSnackBar(
                                                            //   SnackBar(
                                                            //     content: Text(
                                                            //         'Product quantity limit reached'),
                                                            //     duration: Duration(
                                                            //         seconds: 2),
                                                            //   ),
                                                            // );
                                                          }
                                                        : () {
                                                            _cartProvider
                                                                .increment(
                                                                    cartData);
                                                          },
                                                    icon: Icon(
                                                      CupertinoIcons.plus,
                                                      //Added code
                                                      color: cartData
                                                                  .productQuantity ==
                                                              cartData.quantity
                                                          ? Colors
                                                              .grey // Disable button color
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _cartProvider
                                                .removeItem(cartData.productId);

                                            showErrorSnack(context,
                                                'Item removed from cart');

                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(
                                            //   SnackBar(
                                            //     content:
                                            //         Text('Item removed from cart'),
                                            //     duration: Duration(seconds: 2),
                                            //   ),
                                            // );
                                          },
                                          icon: Icon(
                                            CupertinoIcons.delete_simple,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // if (cartData.productQuantity != null &&
                                    //     cartData.productQuantity ==
                                    //         cartData.quantity)
                                    //   showErrorSnack(context,
                                    //       'Product Limit has been reached'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Shopping Cart is Empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MainScreen();
                      }));
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        color: Colors.green.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Continue Shopping ',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomSheet: _cartProvider.getCartItem.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                key: Key('button_to_checkout'),
                onTap: _cartProvider.totalPrice == 0.00
                    ? null
                    : () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CheckoutScreen();
                        }));
                      },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _cartProvider.totalPrice == 0.00
                        ? Colors.grey
                        : Colors.green.shade700,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      "₹" +
                          " " +
                          _cartProvider.totalPrice.toStringAsFixed(2) +
                          "  " +
                          'CHECKOUT',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
