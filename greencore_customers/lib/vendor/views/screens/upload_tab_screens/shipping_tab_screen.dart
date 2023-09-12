import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ShippingScreen extends StatefulWidget {
  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargingShipping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
            title: Text(
              'Charge Shipping ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
              ),
            ),
            value: _chargingShipping,
            onChanged: (value) {
              setState(() {
                setState(() {
                  _chargingShipping = value;
                  _productProvider.getFormData(
                      chargeShippping: _chargingShipping);
                });
              });
            }),
        if (_chargingShipping == true)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Shipping Charge!!';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _productProvider.getFormData(shippingCharge: int.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Shipping Charge',
              ),
            ),
          ),
      ],
    );
  }
}
