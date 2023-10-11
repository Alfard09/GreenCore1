//import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/vendor/views/screens/landing_screen.dart';
import 'package:greencore_1/vendor/views/screens/main_vendor_screen.dart';
import 'package:greencore_1/views/buyers/auth/login_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ProductProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Add this function to get the user type from SharedPreferences
  Future<String?> _getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isCustomerLoggedIn = prefs.getBool('isCustomerLoggedIn') ?? false;
    bool isVendorLoggedIn = prefs.getBool('isVendorLoggedIn') ?? false;

    if (isCustomerLoggedIn) {
      return 'customer';
    } else if (isVendorLoggedIn) {
      return 'vendor';
    } else {
      return null; // No user is logged in
    }
  }
  //changes

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        //navigatorObservers: [NavigatorObserverForTest()],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 6, 153, 19)),
            //useMaterial3: true,
            fontFamily: 'Pop-Regular'),
        //home: LoginScreen(),

        builder: EasyLoading.init(),
        // MainVendorScreen()
        // CustomerRegisterScreen()
        //VendorLoginPage()
        //LoginScreen
        //chnages
        home: FutureBuilder<String?>(
          future: _getUserType(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                home:
                    Scaffold(body: Center(child: CircularProgressIndicator())),
              );
            } else {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                if (snapshot.hasData) {
                  // User is logged in, handle based on the user type (customer or vendor)
                  if (snapshot.data == 'vendor') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LandingScreen()),
                    );
                  } else if (snapshot.data == 'customer') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  } else {
                    // Handle unknown user type or default to a screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                } else {
                  // No user is logged in, navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              });

              return Container(); // Placeholder, you can return any widget you need
            }
          },
        )
        //changes
        );
  }
}
