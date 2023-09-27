import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greencore_1/views/buyers/auth/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Email validation', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(LoginScreen());

      // Tap the login button.
      await tester.tap(find.byKey(Key('navigate_to_main_button')));
      await tester.pump();
      // Verify that the validation error for email is shown.
      expect(find.text('please enter the email'), findsOneWidget);

      // Enter a valid email.
      await tester.enterText(
          find.byKey(Key('email_textfield')), 'test@example.com');

      // Tap the login button again.
      await tester.tap(find.byKey(Key('navigate_to_main_button')));
      await tester.pump();

      // Verify that the validation error for email is not shown.
      expect(find.text('please enter the email'), findsNothing);
    });

    testWidgets('Password validation', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(LoginScreen());

      // Tap the login button.
      await tester.tap(find.byKey(Key('navigate_to_main_button')));
      await tester.pump();

      // Verify that the validation error for password is shown.
      expect(find.text('please enter the password'), findsOneWidget);

      // Enter a valid password.
      await tester.enterText(
          find.byKey(Key('password_textfield')), 'strongpassword');

      // Tap the login button again.
      await tester.tap(find.byKey(Key('navigate_to_main_button')));
      await tester.pump();

      // Verify that the validation error for password is not shown.
      expect(find.text('please enter the password'), findsNothing);
    });
  });
}
