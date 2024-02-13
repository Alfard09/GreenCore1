import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:intl/intl.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetailScreen({super.key, this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  // bool _plantSpecification = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productCategoryController =
      TextEditingController();
  DateTime? _existingScheduleDate;
  //TextEditingController _specialFeatureController = TextEditingController();
  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brandName'];
      _quantityController.text = widget.productData['quantity'].toString();
      _productPriceController.text =
          widget.productData['productPrice'].toString();
      _productDescriptionController.text = widget.productData['description'];
      _productCategoryController.text = widget.productData['category'];
      _existingScheduleDate = widget.productData['scheduleDate'].toDate();

      //_plantSpecification = widget.productData['isPlantSpecification'];
      //_specialFeatureController.text = widget.productData['specialFeatures'];
    });
    super.initState();
  }

  double? productPrice;
  int? quantity;
  DateTime? _scheduleDate;

  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');

    final outputDate = outputDateFormate.format(date);

    return outputDate;
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
                onChanged: (value) {
                  quantity = int.parse(value);
                },
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  productPrice = double.parse(value);
                  productPrice = double.parse(productPrice!.toStringAsFixed(2));
                },
                controller: _productPriceController,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 5,
                maxLength: 20000,
                controller: _productDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextFormField(
                enabled: false,
                controller: _productCategoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(3000),
                      ).then((value) {
                        setState(() {
                          _scheduleDate = value;
                        });
                      });
                    },
                    child: Text("Schedule"),
                  ),
                  if (_scheduleDate != null)
                    Text(
                      formatedDate(_scheduleDate!),
                    )
                  else if (_existingScheduleDate != null)
                    Text(formatedDate(_existingScheduleDate))
                ],
              ),
              SizedBox(height: 60),
              // _plantSpecification == true
              //     ? Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Plant Specifications',
              //             style: TextStyle(
              //               fontSize: 15,
              //               fontWeight: FontWeight.w500,
              //               color: Color(0xff42275a),
              //             ),
              //           ),
              //           SizedBox(height: 10),
              //           TextFormField(
              //             maxLines: 5,
              //             maxLength: 10000,
              //             controller: _specialFeatureController,
              //             decoration: InputDecoration(
              //               labelText: 'Special Feature',
              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //         ],
              //       )
              //     : Container(),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () async {
            if (productPrice != null &&
                quantity != null &&
                _scheduleDate != null) {
              EasyLoading.show(status: "UPDATING...");
              await _firestore
                  .collection('products')
                  .doc(widget.productData['productId'])
                  .update({
                'productName': _productNameController.text,
                'brandName': _brandNameController.text,
                'quantity': quantity,
                'productPrice': productPrice,
                'description': _productDescriptionController.text,
                'category': _productCategoryController.text,
                'scheduleDate': _scheduleDate,
              }).whenComplete(() {
                EasyLoading.dismiss();
              });
            } else {
              showErrorSnack(context, 'Update the Price & quantity & Date');
            }
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xff42275a),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'UPDATE PRODUCT',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
