import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class OrderTrackingCustomer extends StatefulWidget {
  final String orderId;

  const OrderTrackingCustomer({Key? key, required this.orderId})
      : super(key: key);

  @override
  _OrderTrackingCustomerState createState() => _OrderTrackingCustomerState();
}

class _OrderTrackingCustomerState extends State<OrderTrackingCustomer> {
  late FirebaseFirestore _firestore;

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
        backgroundColor: Colors.green.shade700,
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
                  Divider(),
                  otherData(data),
                  Divider(),
                  invoiceReport(data),
                  Divider(),
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

  Widget invoiceReport(Map<String, dynamic> data) {
    return InkWell(
      onTap: () {
        _generateAndShowInvoice(data);
      },
      child: Row(
        children: [
          Icon(
            Icons.file_copy,
            color: Colors.green,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            ' Invoice',
            style: TextStyle(fontSize: 14),
          ),
          Spacer(),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  //report
  Future<void> _generateAndShowInvoice(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Add invoice data to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('GreenCore Invoice Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Order ID:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(data['orderId'],
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(_formatDate(data['orderDate']),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Product Details',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                cellHeight: 30,
                headerHeight: 40,
                cellStyle: const pw.TextStyle(),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                data: <List<String>>[
                  <String>['Product', 'Quantity', 'Price', 'Total'],
                  <String>[
                    data['productName'],
                    data['selectedQuantity'].toString(),
                    '₹ ${data['productPrice']}',
                    '₹ ${data['totalPrice']}',
                  ],
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Buyer Details',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Name:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(data['fullName'],
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Email:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(data['email'],
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Phone:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(data['phone'],
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Address',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text(data['address']),
            ],
          );
        },
      ),
    );

    // Save the PDF file
    final Directory? directory = await getExternalStorageDirectory();
    final String path = directory!.path;
    final File file = File('$path/invoice_report.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the saved PDF file
    OpenFile.open(file.path);
  }

  Widget otherData(Map<String, dynamic> data) {
    return Row(
      children: [
        Text(
          'OrderID: ',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        Expanded(
          child: Text(
            data['orderId'],
            style: TextStyle(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

  Widget buildTimeline(String currentStatus) {
    // Define a list of status changes
    List<String> statusChanges = [
      "Order Placed",
      "Shipped",
      "Out for Delivery",
      "Delivered"
    ];
    // Get the index of the current status in the list
    int currentIndex = statusChanges.indexOf(currentStatus);

    // Define a function to check if the status at a specific index is reached
    bool isStatusReached(int index) {
      return index <= currentIndex;
    }

    // Define a function to get the color of the line
    Color getLineColor(int index) {
      return isStatusReached(index) ? Colors.green : Colors.grey;
    }

    // Define a function to get the indicator color
    Color getIndicatorColor(int index) {
      return isStatusReached(index) ? Colors.green : Colors.grey;
    }

    // Build timeline tiles dynamically based on status changes
    return Column(
      children: List.generate(statusChanges.length, (index) {
        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            color: getIndicatorColor(index),
            width: 30,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getIndicatorColor(index),
              ),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: getLineColor(index),
          ),
          afterLineStyle: LineStyle(
            color: getLineColor(index),
          ),
          startChild: SizedBox(width: 30),
          endChild: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusChanges[index]),
                Text("Details of ${statusChanges[index]}"),
              ],
            ),
          ),
        );
      }),
    );
  }
}
