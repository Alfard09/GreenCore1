import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final Function(PaymentSuccessResponse) onPaymentSuccess;
  final Function(PaymentFailureResponse) onPaymentError;
  final Function(ExternalWalletResponse) onExternalWallet;

  PaymentPage({
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.onExternalWallet,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, widget.onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, widget.onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, widget.onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'your_razorpay_api_key',
      'amount': (amount * 100)
          .toInt(), // amount in the smallest currency unit (e.g., paise)
      'name': 'Your App Name',
      'description': 'Payment for Order',
      'prefill': {
        'contact': '9876543210',
        'email': 'example@example.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error in Razorpay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace 100.0 with the actual total amount from your cart
            _openCheckout(100.0);
          },
          child: Text('Proceed to Payment'),
        ),
      ),
    );
  }
}
