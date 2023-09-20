import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/auth/vendor_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorLogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await _auth.signOut();
      print('working');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VendorLoginPage(),
        ),
      );
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => _logout(context),
        // onPressed: () async {
        //   await _auth.signOut();
        //   //Navigator.of(context).pop();
        //   if (_auth.currentUser == null) {
        //     // Navigate to the specific page after sign-out
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (context) =>
        //             VendorLoginPage(), // Replace with the specific page you want to navigate to after logout
        //       ),
        //     );
        //   }
        // },
        child: Text('Signout'),
      ),
    );
  }
}
