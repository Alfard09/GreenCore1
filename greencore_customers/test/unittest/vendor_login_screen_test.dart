import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencore_1/vendor/views/auth/vendor_login_screen.dart';

void main() {
  group('VendorLoginPage', () {
    testWidgets('Email validation', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(VendorLoginPage());

      // Enter an invalid email.
      await tester.enterText(
          find.byKey(Key('email_textfield')), 'invalidemail');

      // Tap the sign-in button.
      await tester.tap(find.byKey(Key('sign_in_button')));
      await tester.pump();

      // Verify that the validation error for email is shown.
      expect(find.text('Please Enter a Valid Email'), findsOneWidget);
    });

    testWidgets('Password validation', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(VendorLoginPage());

      // Enter an invalid password.
      await tester.enterText(find.byKey(Key('password_textfield')), 'short');

      // Tap the sign-in button.
      await tester.tap(find.byKey(Key('sign_in_button')));
      await tester.pump();

      // Verify that the validation error for password is shown.
      expect(find.text('Please enter a password of at least 6 characters'),
          findsOneWidget);
    });
  });
}
