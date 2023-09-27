import 'package:flutter/material.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetailScreen({super.key, this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  bool _plantSpecification = false;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController _specialFeatureController = TextEditingController();
  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brandName'];
      _quantityController.text = widget.productData['quantity'].toString();
      _plantSpecification = widget.productData['isPlantSpecification'];
      _specialFeatureController.text = widget.productData['specialFeatures'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff42275a),
        elevation: 1,
        title: Text(widget.productData['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Prdouct Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _brandNameController,
                decoration: InputDecoration(labelText: 'Brand Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              SizedBox(height: 20),
              _plantSpecification == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plant Specifications',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff42275a),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          maxLines: 5,
                          maxLength: 10000,
                          controller: _specialFeatureController,
                          decoration: InputDecoration(
                            labelText: 'Special Feature',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
