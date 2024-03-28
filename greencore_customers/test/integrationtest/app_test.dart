import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
//import 'package:introduction/main.dart';

//import 'package:flutter_test/flutter_test.dart';

void main() {
  enableFlutterDriverExtension();
  group('Login Test', () {
    FlutterDriver? driver; // Change to nullable

    // Device ID and port from the VM service URL
    final deviceId = "oWcGuDF0mp8=";
    final port = "60256";
    // final deviceId = "WWeIDqXKr6I=";
    // final port = "64173";

    setUpAll(() async {
      // Construct the VM service URL
      String vmServiceUrl = 'http://127.0.0.1:$port/$deviceId';
      //dartVmServiceUrl: vmServiceUrl
      // Connect to Flutter driver using the VM service URL
      driver = await FlutterDriver.connect(dartVmServiceUrl: vmServiceUrl);
      assert(driver != null, 'Could not connect to the Flutter driver');
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver!.close(); // Use null-aware operator
      }
    });

    test('check flutter driver health', () async {
      Health health = await driver!.checkHealth();
      print(health.status);
    });

    test('Login with email and password', () async {
      assert(driver != null, 'Flutter Driver is not initialized');

      // Your test code here

      // Navigate to the login screen
      await driver!.waitFor(find.text("Login Customer's Account"));
      await driver!.tap(find.byValueKey('email_textfield'));
      await driver!.enterText('buyer1@gmail.com');
      await driver!.tap(find.byValueKey('password_textfield'));
      await driver!.enterText('buyer123');
      await driver!.tap(find.byValueKey('login_button'));

      // Wait for a while to ensure the transition is complete
      await driver!.tap(find.byValueKey('home_icon'));

      // Wait for a while to ensure the transition is complete
      await driver!.waitFor(find.text('HOME'));

      // Validate that navigation to HOME was successful
      expect(await driver!.getText(find.text('HOME')), 'HOME');
    });
  });
}

// // flutter test
// // flutter drive --target=test_driver/app_test.dart
// // URL "http://127.0.0.1:60256/WWeIDqXKr6I=/":60256
