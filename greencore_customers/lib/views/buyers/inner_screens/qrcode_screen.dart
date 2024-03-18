import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String orderId;

  const QRCodeScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: generateQRCode(orderId), // Generate QR code with order ID
      ),
    );
  }

  Widget generateQRCode(String orderId) {
    return QrImageView(
      data: orderId, // Embed the order ID as data for the QR code
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}
