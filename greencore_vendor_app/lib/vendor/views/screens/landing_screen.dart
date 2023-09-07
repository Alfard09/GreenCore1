import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:greencore_vendor_app/vendor/models/vendor_user_models.dart';
import 'package:greencore_vendor_app/vendor/views/auth/vendor_registration_screen.dart';
import 'package:greencore_vendor_app/vendor/views/screens/main_vendor_screen.dart';

class LandingScreen extends StatelessWidget {
  //getting vendors details from the database
  final CollectionReference _vendorsStream =
      FirebaseFirestore.instance.collection('vendors');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: _vendorsStream.doc(_auth.currentUser!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        //checking whether the vendors already exist or it is a new vendor!!!!
        if (!snapshot.data!.exists) {
          return VendorRegistrationScreen();
        }
        // VendorUserModel vendorUserModel =
        //     VendorUserModel.fromJson(snapshot.data!.data()! as dynamic);
        //  VendorUserModel vendorUserModel = VendorUserModel.fromJson(
        // snapshot.data!.data()! as Map<String, dynamic>);
        //  if (vendorUserModel.approved == true) {
        //   return MainVendorScreen();
        // }
        //converting the string dynamic data to json
        Map<String, dynamic> dataMap =
            snapshot.data!.data()! as Map<String, dynamic>;
        // Convert the dataMap to the expected type Map<String, Object>
        Map<String, Object> convertedDataMap = dataMap.cast<String, Object>();
        VendorUserModel vendorUserModel =
            VendorUserModel.fromJson(convertedDataMap);

        if (vendorUserModel.approved == true) {
          return MainVendorScreen();
        }
        //shows vendors shop name and a waiting screen to see wheahther the vendors are approved or not
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                vendorUserModel.storeImage.toString(),
                width: 90,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              vendorUserModel.bussinessName.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Your application has been sent to shop admin\n Admin will get back to you soon',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            //signout button
            TextButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text("Signout"),
            ),
          ],
        ));
      },
    ));
  }
}
