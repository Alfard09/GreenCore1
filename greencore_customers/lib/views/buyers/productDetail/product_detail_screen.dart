import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen({super.key});
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          productData['productName'],
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
        ],
      ),
    );
  }
}
