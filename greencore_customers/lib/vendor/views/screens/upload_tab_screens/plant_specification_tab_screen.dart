import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/product_provider.dart';

class SpecificationScreen extends StatefulWidget {
  const SpecificationScreen({super.key});

  @override
  State<SpecificationScreen> createState() => _SpecificationScreenState();
}

class _SpecificationScreenState extends State<SpecificationScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _isPlantSpecification = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                  title: Text(
                    'Plant Specifications? ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  value: _isPlantSpecification,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        _isPlantSpecification = value;
                        _productProvider.getFormData(
                            isPlantSpecification: _isPlantSpecification);
                      });
                    });
                  }),
              if (_isPlantSpecification == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Specifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff42275a),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Plant Height!!';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(plantHeight: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Plant Height',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Plant Spread!!';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(plantSpread: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Plant Spread',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Common Name!!';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(commonName: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Common Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Max reachable height!!';
                        } else if (value.isEmpty) {
                          return 'Enter Not defined';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(maxHeight: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Maximum Reachable Height',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Flower color!!';
                        } else if (value.isEmpty) {
                          return 'Enter Not defined';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(flowerColor: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Flower Color',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Bloom Time!!';
                        } else if (value.isEmpty) {
                          return 'Enter Not defined';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(bloomTime: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Bloom Time',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Difficulty level!!';
                        } else if (value.isEmpty) {
                          return 'Enter Not defined';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(diffLevel: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Difficulty Level',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Scientific Name!!';
                        } else if (value.isEmpty) {
                          return 'Enter Not defined';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _productProvider.getFormData(scientificName: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Scientific Name',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Special Features',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff42275a),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Special features';
                        } else {
                          return null;
                        }
                      },
                      maxLines: 3,
                      maxLength: 10000,
                      onChanged: (value) {
                        _productProvider.getFormData(specialFeatures: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Special features',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Uses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff42275a),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Uses';
                        } else {
                          return null;
                        }
                      },
                      maxLines: 3,
                      maxLength: 10000,
                      onChanged: (value) {
                        _productProvider.getFormData(uses: value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Uses',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
