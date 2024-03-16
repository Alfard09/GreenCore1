import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  late FirebaseFirestore _firestore;
  late QRViewController qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.day}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        title: Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('orders').doc(widget.orderId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            String currentStatus = data['status'] ?? "Order Placed";
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  topDetails(data),
                  Divider(),
                  buildTimeline(currentStatus),
                  SizedBox(height: 30),
                  if (currentStatus == 'Out for Delivery')
                    ElevatedButton(
                      onPressed: () {
                        _scanQR();
                      },
                      child: Text(
                        "Scan QRCode",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => _updateStatus(currentStatus),
                      child: Text(
                        "Update Status",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget topDetails(Map<String, dynamic> data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: Image.network(
                  data['productImage'][0],
                  fit: BoxFit.fill,
                ),
                title: Text(
                  data['productName'],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity:', style: TextStyle(fontSize: 14)),
                        Text(data['selectedQuantity'].toString())
                      ],
                    ),
                    data['accepted'] == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Date:'),
                              Text(_formatDate(data['scheduleDate'])),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
        ListTile(
          title: Text('Buyer Detail:'),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name:'),
                  Text(data['fullName']),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email:'),
                  Text(data['email']),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Address'),
                  Text(data['address']),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //vertical
  Widget buildTimeline(String currentStatus) {
    return Column(
      children: [
        _buildTimelineTile("Order Placed", currentStatus == "Order Placed"),
        _buildTimelineTile("Shipped", currentStatus == "Shipped"),
        _buildTimelineTile(
            "Out for Delivery", currentStatus == "Out for Delivery"),
        _buildTimelineTile("Delivered", currentStatus == "Delivered"),
      ],
    );
  }

  Widget _buildTimelineTile(String title, bool isActive) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: title == "Order Placed",
      isLast: title == "Delivered",
      indicatorStyle: IndicatorStyle(
        color: isActive ? Colors.green : Colors.blueGrey,
        width: 30,
        indicator: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.blueGrey,
          ),
        ),
      ),
      beforeLineStyle: LineStyle(color: Colors.blueGrey),
      afterLineStyle: LineStyle(color: Colors.blueGrey),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.grey[300],
          child: Text(title),
        ),
      ),
    );
  }

  void _scanQR() {
    // Add code for QR code scanning
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Center(child: Text('Scan QR')),
        ),
        body: Center(
          child: SizedBox(
            // width: MediaQuery.of(context).size.width *     0.8, // Adjust width as needed
            // height: MediaQuery.of(context).size.width * 1.2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ),
      );
    }));
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      _handleScannedData(scanData.code.toString());
    });
  }

  void _handleScannedData(String scannedData) {
    _updateStatus('Delivered');
    qrController.stopCamera();
    Navigator.of(context).pop();
  }

  void _updateStatus(String currentStatus) async {
    String nextStatus = _getNextStatus(currentStatus);
    try {
      // Update status in the database
      await _firestore.collection('orders').doc(widget.orderId).update({
        'status': nextStatus,
      });

      // Show a message indicating successful update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to $nextStatus")),
      );
    } catch (error) {
      // Show an error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating status: $error")),
      );
    }
  }

  String _getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'Order Placed':
        return 'Shipped';
      case 'Shipped':
        return 'Out for Delivery';
      case 'Out for Delivery':
        return 'Delivered';
      default:
        return 'Delivered';
    }
  }
}
