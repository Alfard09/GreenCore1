// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class ReviewRatingPage extends StatefulWidget {
//   final String productId;
//   final String orderId;

//   const ReviewRatingPage({
//     Key? key,
//     required this.productId,
//     required this.orderId,
//   }) : super(key: key);

//   @override
//   _ReviewRatingPageState createState() => _ReviewRatingPageState();
// }

// class _ReviewRatingPageState extends State<ReviewRatingPage> {
//   late TextEditingController _reviewController;
//   double _rating = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _reviewController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _reviewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.green.shade700,
//         title: Text(
//           "Leave Review & Rating",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Rate this product:",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Center(
//                 child: RatingBar.builder(
//                   initialRating: _rating,
//                   minRating: 0,
//                   direction: Axis.horizontal,
//                   allowHalfRating: true,
//                   itemCount: 5,
//                   itemSize: 40,
//                   itemBuilder: (context, _) => Icon(
//                     Icons.star,
//                     color: Colors.green,
//                   ),
//                   onRatingUpdate: (rating) {
//                     setState(() {
//                       _rating = rating;
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "Leave a review:",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               _buildReviewTextField(),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   _submitReview();
//                 },
//                 child: Text("Submit"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildReviewTextField() {
//     return TextField(
//       controller: _reviewController,
//       keyboardType: TextInputType.multiline,
//       maxLines: null,
//       decoration: InputDecoration(
//         hintText: "Write your review here...",
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   void _submitReview() {
//     // Get review text from text controller
//     String reviewText = _reviewController.text.trim();

//     // Validate if review text is not empty
//     if (reviewText.isNotEmpty) {
//       // Add review to Firestore
//       FirebaseFirestore.instance
//           .collection('products')
//           .doc(widget.productId)
//           .collection('reviews')
//           .add({
//         'orderId': widget.orderId,
//         'rating': _rating,
//         'review': reviewText,
//         'timestamp': FieldValue.serverTimestamp(),
//       }).then((_) {
//         // Show success message and navigate back
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Review submitted successfully!'),
//         ));
//         Navigator.pop(context);
//       }).catchError((error) {
//         // Show error message if submission fails
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to submit review. Please try again.'),
//         ));
//       });
//     } else {
//       // Show error message if review text is empty
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please write your review before submitting.'),
//       ));
//     }
//   }
// }
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greencore_1/utils/float_notification.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:image_picker/image_picker.dart';

class ReviewRatingPage extends StatefulWidget {
  final String productId;
  final String orderId;

  const ReviewRatingPage({
    Key? key,
    required this.productId,
    required this.orderId,
  }) : super(key: key);

  @override
  _ReviewRatingPageState createState() => _ReviewRatingPageState();
}

class _ReviewRatingPageState extends State<ReviewRatingPage> {
  late TextEditingController _reviewController;
  double _rating = 0.0;
  List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade700,
        title: Text(
          "Leave Review & Rating",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rate this product:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.green,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Leave a review:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReviewTextField(),
              SizedBox(height: 20),
              _buildImagePicker(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitReview();
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewTextField() {
    return TextField(
      controller: _reviewController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Write your review here...",
        border: OutlineInputBorder(),
      ),
    );
  }

  //
  Widget _buildImagePicker() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _selectedImages.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(image.path),
                              width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.image,
            color: Colors.green,
          ),
          onPressed: () {
            _pickImage();
          },
        ),
      ],
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (_selectedImages.length < 3) {
          _selectedImages.add(pickedFile);
        } else {
          showErrorSnack(context, "Can't pick more than 3 image");
        }
      });
    }
  }

  void _submitReview() async {
    // Get review text from text controller
    String reviewText = _reviewController.text.trim();

    // Validate if review text is not empty
    if (reviewText.isNotEmpty) {
      // Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImages();

      // Add review to Firestore
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .collection('reviews')
          .add({
        'orderId': widget.orderId,
        'rating': _rating,
        'review': reviewText,
        'imageUrls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        // Show success message and navigate back
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Review submitted successfully!'),
        // ));
        showSnack(context, "Review submitted successfully!");
        Navigator.pop(context);
      }).catchError((error) {
        // Show error message if submission fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit review. Please try again.'),
        ));
      });
    } else {
      // Show error message if review text is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please write your review before submitting.'),
      ));
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];
    for (var image in _selectedImages) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('reviewImages/$imageName');
      UploadTask uploadTask = ref.putFile(File(image.path));
      await uploadTask.whenComplete(() async {
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      });
    }
    return imageUrls;
  }
}
