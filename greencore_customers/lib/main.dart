import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/vendor/views/screens/main_vendor_screen.dart';
import 'package:greencore_1/views/buyers/auth/login_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) {
      return ProductProvider();
    }),
    ChangeNotifierProvider(create: (_) {
      return CartProvider();
    }),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 6, 153, 19)),
          //useMaterial3: true,
          fontFamily: 'Pop-Regular'),
      home: LoginScreen(),
      builder: EasyLoading.init(),
      // MainVendorScreen()
      // CustomerRegisterScreen()
      //VendorLoginPage()
      //LoginScreen
    );
  }
}
