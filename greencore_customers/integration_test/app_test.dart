import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencore_1/views/buyers/auth/login_screen.dart';
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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();
    });
  });
}

void navigateToLoginScreen(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => LoginScreen()));
}
