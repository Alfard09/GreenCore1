import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/auth/vendor_login_screen.dart';
import '../screens/landing_screen.dart';
import 'auth_service.dart';

class VendorAuthScreen extends StatefulWidget {
  const VendorAuthScreen({super.key});

  @override
  State<VendorAuthScreen> createState() => _VendorAuthScreenState();
}

class _VendorAuthScreenState extends State<VendorAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // return SignInScreen(
          // providers: [
          //   EmailAuthProvider(),
          //   GoogleAuthProvider(
          //     clientId: "935977688778-1nh13upophlkqiekd0ic99ir4vmk2p9h.apps.googleusercontent.com";
          //   );
          //   PhoneAuthProvider();
          // ],
          // );

          return VendorLoginPage();
        }
        //return VendorRegistrationScreen();
        return LandingScreen();
        //return VendorLoginPage();
      },
    );
  }
}
