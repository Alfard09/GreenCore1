import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/widgets/category_widget.dart';
import 'package:uuid/uuid.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '\CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;

  String? fileName;

  late String categoryId;

  late String categoryName;
  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _uploadCategoryBannerToStorage(dynamic image) async {
    final uid = Uuid().v4();
    Reference ref = _storage.ref().child('CategoryImages').child(uid);
    //Reference ref = _storage.ref().child('CategoryImages').child(fileName!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    categoryId = uid;

    return downloadUrl;
  }

  // uploadCategory() async {
  //   if (_image != null && _formKey.currentState!.validate()) {
  //     print('Valid');
  //     EasyLoading.show();
  //     String imageUrl = await _uploadCategoryBannerToStorage(_image);

  //     await _firestore.collection('categories').doc(categoryId).set({
  //       'image': imageUrl,
  //       'categoryName': categoryName,
  //       'categoryId': categoryId,
  //     }).whenComplete(() {
  //       EasyLoading.dismiss();
  //       setState(() {
  //         _image = null;
  //         _formKey.currentState!.reset();
  //       });
  //     });
  //   } else {
  //     if (_formKey.currentState!.validate()) {
  //       print('Please upload an image');
  //       showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: Text("Error"),
  //               content: Text('Please upload an image.'),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('Ok'),
  //                 ),
  //               ],
  //             );
  //           });
  //     } else {
  //       print('Form is not valid');
  //     }
  //   }
  // }
  uploadCategory() async {
    if (_image != null && _formKey.currentState!.validate()) {
      print('Valid');
      EasyLoading.show();
      String imageUrl = await _uploadCategoryBannerToStorage(_image);

      // Check for duplicate category name
      bool isDuplicate = await checkDuplicateCategory(categoryName);
      if (isDuplicate) {
        EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Category name already exists.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Save the category if it's not a duplicate
        await _firestore.collection('categories').doc(categoryId).set({
          'image': imageUrl,
          'categoryName': categoryName,
          'categoryId': categoryId,
        }).whenComplete(() {
          EasyLoading.dismiss();
          setState(() {
            _image = null;
            _formKey.currentState!.reset();
          });
        });
      }
    } else {
      if (_formKey.currentState!.validate()) {
        print('Please upload an image');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please upload an image.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Form is not valid');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Form is not valid.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

// Function to check for duplicate category name in Firebase
  Future<bool> checkDuplicateCategory(String categoryName) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('categories')
        .where('categoryName', isEqualTo: categoryName)
        .get();
    bool isDuplicate = querySnapshot.docs.isNotEmpty;
    print('Duplicate category check result: $isDuplicate');
    return isDuplicate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                ),
              ),
            ),
            Divider(
              color: Colors.lightGreen.shade700,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Container(
                          //the image container box
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            border:
                                Border.all(color: Colors.lightGreen.shade600),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: _image != null
                              ? Image.memory(
                                  //shows the picked image in the box
                                  _image,
                                  fit: BoxFit.fill,
                                )
                              : Center(
                                  child: Text('Categories'),
                                )),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        //add image button
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen.shade600,
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        child: Text(
                          'Upload Image',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  //form category name field and form validator
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      onChanged: (value) {
                        categoryName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Category name ';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Category Name...',
                        hintText: 'Enter Category Name...',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  //save button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen.shade600,
                  ),
                  onPressed: () {
                    uploadCategory();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.lightGreen.shade700,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}




//og  code:
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:greencore1_admin_panel/views/screens/side_bar_screen/widgets/category_widget.dart';

// class CategoryScreen extends StatefulWidget {
//   static const String routeName = '\CategoryScreen';

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   dynamic _image;

//   String? fileName;

//   late String categoryName;
//   _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(allowMultiple: false, type: FileType.image);

//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//         fileName = result.files.first.name;
//       });
//     }
//   }

//   _uploadCategoryBannerToStorage(dynamic image) async {
//   final uid=Uuid().v
//     Reference ref = _storage.ref().child('CategoryImages').child(fileName!);

//     UploadTask uploadTask = ref.putData(image);

//     TaskSnapshot snapshot = await uploadTask;

//     String downloadUrl = await snapshot.ref.getDownloadURL();

//     return downloadUrl;
//   }

//   uploadCategory() async {
//     EasyLoading.show();
//     if (_formKey.currentState!.validate()) {
//       print('Valid');
//       String imageUrl = await _uploadCategoryBannerToStorage(_image);

//       await _firestore.collection('categories').doc(fileName).set({
//         'image': imageUrl,
//         'categoryName': categoryName,
//       }).whenComplete(() {
//         EasyLoading.dismiss();
//         setState(() {
//           _image = null;
//           _formKey.currentState!.reset();
//         });
//       });
//     } else {
//       print('Not Valid');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//         child: Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.topLeft,
//             padding: const EdgeInsets.all(10),
//             child: const Text(
//               'Category',
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 36,
//               ),
//             ),
//           ),
//           Divider(
//             color: Colors.lightGreen.shade700,
//           ),
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(14.0),
//                 child: Column(
//                   children: [
//                     Container(
//                         //the image container box
//                         height: 140,
//                         width: 140,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade400,
//                           border: Border.all(color: Colors.lightGreen.shade600),
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: _image != null
//                             ? Image.memory(
//                                 //shows the picked image in the box
//                                 _image,
//                                 fit: BoxFit.fill,
//                               )
//                             : Center(
//                                 child: Text('Categories'),
//                               )),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     ElevatedButton(
//                       //add image button
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.lightGreen.shade600,
//                       ),
//                       onPressed: () {
//                         _pickImage();
//                       },
//                       child: Text(
//                         'Upload Image',
//                         style: TextStyle(fontWeight: FontWeight.w400),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Flexible(
//                 //form category name field and form validator
//                 child: SizedBox(
//                   width: 300,
//                   child: TextFormField(
//                     onChanged: (value) {
//                       categoryName = value;
//                     },
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter a Category name ';
//                       } else {
//                         return null;
//                       }
//                     },
//                     decoration: InputDecoration(
//                       labelText: 'Enter Category Name...',
//                       hintText: 'Enter Category Name...',
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 30,
//               ),
//               ElevatedButton(
//                 //save button
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightGreen.shade600,
//                 ),
//                 onPressed: () {
//                   uploadCategory();
//                 },
//                 child: Text(
//                   'Save',
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//               )
//             ],
//           ),
//           Divider(
//             color: Colors.lightGreen.shade700,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Categories',
//                 style: TextStyle(
//                   fontSize: 36,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           CategoryWidget(),
//         ],
//       ),
//     ));
//   }
// }


