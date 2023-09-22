import 'package:flutter/material.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:provider/provider.dart';

class OfferScreen extends StatefulWidget {
  //const OfferScreen({super.key});

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _discount = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          CheckboxListTile(
            title: Text("Discount?"),
            value: _discount,
            onChanged: (value) {
              setState(() {
                _discount = value;
                _productProvider.getFormData(discount: _discount);
              });
            },
          ),
          if (_discount == true)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Discount price!!';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(discountPrice: int.parse(value));
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Discounted New Price'),
              ),
            )
        ],
      ),
    );
  }
}
