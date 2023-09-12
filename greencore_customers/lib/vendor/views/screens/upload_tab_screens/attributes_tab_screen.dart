import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:provider/provider.dart';

class AttributesScreen extends StatefulWidget {
  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool? _entered = false;

  final TextEditingController _sizeController = TextEditingController();

  List<String> _sizeList = [];

  final validSizes = ['XL', 'L', 'M', 'S', 'xl', 'l', 'm', 's'];

  bool isSave = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Brand Name!!';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              _productProvider.getFormData(brandName: value);
            },
            decoration: InputDecoration(
              labelText: 'Brand',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  width: 200,
                  child: TextFormField(
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Enter Size!!';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    controller: _sizeController,
                    onChanged: (value) {
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Size',
                    ),
                  ),
                ),
              ),
              _entered == true
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                          0xff42275a,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!validSizes.contains(_sizeController.text))
                            showSnack(context,
                                'Invalid Sizes. Please enter XL, L, M, S');
                          else
                            _sizeList.add(_sizeController.text);
                          _sizeController.clear();
                        });
                        print(_sizeList);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Text(''),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (_sizeList.isNotEmpty)
            Container(
              height: 55,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sizeList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _sizeList.removeAt(index);
                            _productProvider.getFormData(sizeList: _sizeList);
                            isSave = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff734b6d),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _sizeList[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          if (_sizeList.isNotEmpty)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xff42275a,
                ),
              ),
              onPressed: () {
                _productProvider.getFormData(sizeList: _sizeList);
                setState(() {
                  isSave = true;
                });
              },
              child: Text(
                isSave ? 'Saved' : 'Save',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
