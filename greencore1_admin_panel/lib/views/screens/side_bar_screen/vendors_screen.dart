import 'package:flutter/material.dart';
import 'package:greencore1_admin_panel/views/screens/side_bar_screen/widgets/vendor_widget.dart';

class VendorScreen extends StatelessWidget {
  static const String routeName = '\VendorsScreen';

  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
          ),
          color: Colors.green.shade700,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Manage Vendors",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
          ),
          Row(
            children: [
              _rowHeader('LOGO', 1),
              _rowHeader('BUSINESS NAME', 2),
              _rowHeader('CITY', 2),
              _rowHeader('STATE', 2),
              _rowHeader('ACTION', 1),
              // _rowHeader('VIEW MORE', 1),
            ],
          ),
          VendorWidget(),
        ],
      ),
    );
  }
}
