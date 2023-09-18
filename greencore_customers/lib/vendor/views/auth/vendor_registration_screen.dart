import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/vendor/views/auth/vendor_login_screen.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../utils/show_snackBar.dart';
import '../../controllers/vendor_register_controller.dart';

class VendorRegistrationScreen extends StatefulWidget {
  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorController _vendorController = VendorController();

  late String countryValue;
  late String stateValue;
  late String cityValue;

  Uint8List? _image;
  // String? _taxStatus;
  late String bussinessName;
  late String email;
  late String phoneNumber;
  late String taxNumber;

  selectGalleryImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  _saveVendorDetails() async {
    EasyLoading.show(status: 'Please Wait!!');
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        EasyLoading.dismiss();
        showErrorSnack(context, 'Please select an image');
        return;
      }

      await _vendorController
          .registerVendor(
        false,
        bussinessName,
        email,
        phoneNumber,
        countryValue,
        stateValue,
        cityValue,
        taxNumber,
        _image,
      )
          .whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _formKey.currentState!.reset();
          _image = null;
        });
      });
    } else {
      print('Bad');
      EasyLoading.dismiss();
    }
  }

  Future<void> _handleLogout() async {
    // Check if the user is authenticated before attempting to sign out
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      // Navigate to the VendorLoginPage after successful logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VendorLoginPage(),
        ),
      );
    } else {
      print('User is not authenticated.');
    }
  }

  // List<String> _taxOptions = ['YES', 'NO'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            toolbarHeight: 200,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(builder: (context, constraints) {
              return FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        colors: [Color(0xff42275a), Color(0xff734b6d)]),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _handleLogout();
                                // await FirebaseAuth.instance.signOut();
                              },
                              icon: Icon(Icons.logout),
                            ),
                          ],
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _image != null
                              ? Image.memory(
                                  _image!,
                                  fit: BoxFit.fill,
                                )
                              : IconButton(
                                  onPressed: () {
                                    selectGalleryImage();
                                  },
                                  icon: Icon(CupertinoIcons.photo),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        bussinessName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Bussiness name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Business Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Email must not be empty';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Please Enter a Valid Email";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Phone number must not be empty';
                        } else if (value.length != 10) {
                          return 'please enter 10 digit phone number';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        taxNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Tax number must not be empty';
                        } else if (value.length < 10 || value.length > 15) {
                          return 'Please enter a tax number between 10 and 15 digits';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tax Number',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //tax thing
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Tax Registered?',
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       // SizedBox(
                    //       //   width: 10,
                    //       // ),
                    //       Flexible(
                    //         child: Container(
                    //           width: 150,
                    //           child: DropdownButtonFormField(
                    //             hint: Text('Select...'),
                    //             items: _taxOptions
                    //                 .map<DropdownMenuItem<String>>(
                    //                     (String value) {
                    //               return DropdownMenuItem<String>(
                    //                 value: value,
                    //                 child: Text(value),
                    //               );
                    //             }).toList(),
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 _taxStatus = value;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // if (_taxStatus == 'YES')
                    //   Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: TextFormField(
                    //       onChanged: (value) {
                    //         taxNumber = value;
                    //       },
                    //       validator: (value) {
                    //         if (value!.isEmpty) {
                    //           return 'Please Tax number must not be empty';
                    //         } else {
                    //           return null;
                    //         }
                    //       },
                    //       decoration: InputDecoration(
                    //         labelText: 'Tax Number',
                    //       ),
                    //     ),
                    //   ),
                    InkWell(
                      onTap: _saveVendorDetails, //() async {
                      //    _saveVendorDetails();
                      // },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Color(0xff42275a),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
