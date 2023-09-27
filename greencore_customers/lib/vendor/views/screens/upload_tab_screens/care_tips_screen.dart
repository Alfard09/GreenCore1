import 'package:flutter/material.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CareTips extends StatefulWidget {
  const CareTips({super.key});

  @override
  State<CareTips> createState() => _CareTipsState();
}

class _CareTipsState extends State<CareTips>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  bool? _isCareTip = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CheckboxListTile(
              title: Text(
                'Plant Care Tip? ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                ),
              ),
              value: _isCareTip,
              onChanged: (value) {
                setState(() {
                  _isCareTip = value;
                  _productProvider.getFormData(isCareTip: _isCareTip);
                });
              },
            ),
            if (_isCareTip == true)
              Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter care tips';
                      } else {
                        return null;
                      }
                    },
                    maxLines: 5,
                    maxLength: 20000,
                    onChanged: (value) {
                      _productProvider.getFormData(plantCaretip: value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Plant Care Tips',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
