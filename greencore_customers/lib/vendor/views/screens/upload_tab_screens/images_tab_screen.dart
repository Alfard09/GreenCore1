import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ImagesScreen extends StatefulWidget {
  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ImagePicker picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<File> _image = [];

  List<String> _imageUrlList = [];

  bool get canAddMoreImages => _image.length < 5;
  bool canAddImageCheck = true;

  chooseImage() async {
    if (!canAddMoreImages) {
      print("Image limit exceeded. Showing snackbar...");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'You can only add up to 5 images.',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (PickedFile == null) {
      print('No image picked!!!');
    } else {
      setState(() {
        _image.add(File(pickedFile!.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: _image.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 3,
              ),
              itemBuilder: ((context, index) {
                return index == 0
                    ? Container(
                        decoration: BoxDecoration(color: Colors.grey.shade400),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              canAddMoreImages ? chooseImage() : null;
                              setState(() {
                                if (canAddMoreImages == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'You can only add up to 5 images.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              });
                            },
                            // onPressed:
                            //     canAddMoreImages ? () => chooseImage() : null,

                            icon: Icon(Icons.add),
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(
                              _image[index - 1],
                            ),
                          ),
                        ),
                      );
              }),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show(status: 'Uploading Images');
                for (var img in _image) {
                  Reference ref =
                      _storage.ref().child('productImage').child(Uuid().v4());

                  await ref.putFile(img).whenComplete(() async {
                    await ref.getDownloadURL().then((value) {
                      setState(() {
                        _imageUrlList.add(value);
                      });
                    });
                  });
                }
                setState(() {
                  // _image = [];
                  _productProvider.getFormData(imageUrlList: _imageUrlList);
                  EasyLoading.dismiss();
                });
              },
              child: _image.isNotEmpty ? Text('Upload') : Text(''),
            ),
          ],
        ),
      ),
    );
  }
}
