import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainVendorScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await _auth.signOut();
          },
          child: Text("Signout"),
        ),
      ),
    );
  }
}
