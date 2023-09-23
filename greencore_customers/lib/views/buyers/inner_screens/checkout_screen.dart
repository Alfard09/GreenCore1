import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/show_snackBar.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green.shade600,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.green.shade600, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _cartProvider.getCartItem.length,
        itemBuilder: ((context, index) {
          final cartData = _cartProvider.getCartItem.values.toList()[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
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
                                "\$" + " " + cartData.price.toStringAsFixed(2),
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
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onTap: () {
            //to place order
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return CheckoutScreen();
            // }));
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                // "\$" +
                //     " " +
                //     _cartProvider.totalPrice.toStringAsFixed(2) +
                //     "  " +
                'PLACE ORDER',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
