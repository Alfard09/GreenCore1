// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:greencore_1/views/buyers/auth/login_screen.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:greencore_1/main.dart' as app;

// void main() {
//   group('login testing', () {
//     IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//     testWidgets('app testing', (tester) async {
//       app.main(); //loading the main app
//       await tester.pumpAndSettle(); //to maintain the app state

//       await tester.pumpAndSettle();
//       // final emailFormField = find.byType(TextFormField).first;
//       // print(emailFormField);
//       // final passwordFormField = find.byType(TextFormField).last;
//       // final loginButton = find.byType(InkWell).last;

//       debugDumpApp();
//       await tester.pumpAndSettle();

//       final emailFormField = find.byKey(Key('email_textfield'));
//       print(emailFormField);

//       final passwordFormField = await find.byKey(Key('password_textfield'));

//       final loginButton = find.byKey(Key('main_button'));

//       // Ensure the widgets are present
//       expect(emailFormField, findsOneWidget);
//       expect(passwordFormField, findsOneWidget);
//       expect(loginButton, findsOneWidget);

//       await tester.enterText(emailFormField, "buyer1@gmail.com");
//       await tester.enterText(passwordFormField, "buyer123");
//       await tester.pumpAndSettle();

//       await tester.tap(loginButton);
//       await tester.pumpAndSettle();
//     });
//   });
// }

// void navigateToLoginScreen(BuildContext context) {
//   Navigator.of(context)
//       .push(MaterialPageRoute(builder: (context) => LoginScreen()));
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencore_1/views/buyers/auth/login_screen.dart';
import 'package:greencore_1/views/buyers/productDetail/product_detail_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:greencore_1/main.dart' as app;

void main() {
  group('login testing', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('app testing', (tester) async {
      app.main(); //loading the main app
      await tester.pumpAndSettle(); //to maintain the app state

      await tester.pumpAndSettle();
      // final emailFormField = find.byType(TextFormField).first;
      // print(emailFormField);
      // final passwordFormField = find.byType(TextFormField).last;
      // final loginButton = find.byType(InkWell).last;

      debugDumpApp();
      await tester.pumpAndSettle(Duration(seconds: 3));

      final emailFormField = find.byKey(Key('email_textfield'));
      print(emailFormField);

      final passwordFormField = await find.byKey(Key('password_textfield'));

      final loginButton = find.byKey(Key('main_button'));

      // Ensure the widgets are present
      expect(emailFormField, findsOneWidget);
      expect(passwordFormField, findsOneWidget);
      expect(loginButton, findsOneWidget);

      await tester.enterText(emailFormField, "buyer1@gmail.com");
      await tester.enterText(passwordFormField, "buyer123");
      await tester.pumpAndSettle(Duration(seconds: 3));

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
//testing part 2 clicking on the first product
      // Find the product by key (assuming it's the first one)
      //final product = find.byKey(Key('product_0'));
      final product = find.byKey(Key('product_0'));

      expect(product, findsOneWidget);

      // Tap on the product to navigate to the product detail screen
      await tester.tap(product);
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify navigation to the product detail screen
      final productDetailScreen = find.byType(ProductDetailScreen);
      expect(productDetailScreen, findsOneWidget);
      await tester.pumpAndSettle(Duration(seconds: 3));
//testing part two ends here

//testing  part 3 -- adding product to cart

      final addToCartButton = find.byKey(Key('add_to_cart_button'));
      expect(addToCartButton, findsOneWidget);

      // Tap on the "Add to Cart" button.
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle(Duration(seconds: 3));
//ends here
//testing part 4 -- checking the cart
      //going to cart
      final incartbutton = find.byKey(Key('In_cart_button'));
      expect(addToCartButton, findsOneWidget);
      await tester.tap(incartbutton);
      await tester.pumpAndSettle(Duration(seconds: 2));

      //cart functionality checking
      final incrementCart = find.byKey(Key('incrementKey'));
      expect(incrementCart, findsOneWidget);

      //tap action
      await tester.pumpAndSettle();
      await tester.tap(incrementCart);
      //tap 2nd time
      await tester.tap(incrementCart);
      await tester.pumpAndSettle(Duration(seconds: 3));

      //cart decrement
      final decrementCart = find.byKey(Key('decrementKey'));
      expect(decrementCart, findsOneWidget);

      await tester.pumpAndSettle();
      await tester.tap(decrementCart);
      await tester.pumpAndSettle(Duration(seconds: 3));

      //button to checkout
      final checkoutButton = find.byKey(Key('button_to_checkout'));
      expect(checkoutButton, findsOneWidget);

      await tester.pumpAndSettle();
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle(Duration(seconds: 3));
    });
  });
}

void navigateToLoginScreen(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => LoginScreen()));
}
