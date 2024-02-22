// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrdersReportPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders Report'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('orders').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           final orders = snapshot.data?.docs;
//           return ListView.builder(
//             itemCount: orders?.length,
//             itemBuilder: (context, index) {
//               var order = orders?[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   color: Color.fromARGB(255, 84, 37, 104),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(16.0),
//                     title: Text(
//                       order?['productName'],
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8.0),
//                         Text(
//                           'Buyer Email: ${order?['email']}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Quantity: ${order?['quantity']}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Total Price: \$${order?['totalPrice']}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Order Date: ${order?['orderDate'].toDate().toString()}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(order?['productImage'][0]),
//                     ),
//                     onTap: () {
//                       // Add onTap functionality if needed
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

//2
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';

// class OrdersReportPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders Report'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('orders').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           final orders = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               var order = orders[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(16.0),
//                     title: Text(
//                       order['productName'],
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8.0),
//                         Text(
//                           'Buyer Email: ${order['email']}',
//                           style: TextStyle(fontSize: 14.0),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Quantity: ${order['quantity']}',
//                           style: TextStyle(fontSize: 14.0),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Total Price: \$${order['totalPrice']}',
//                           style: TextStyle(fontSize: 14.0),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Order Date: ${order['orderDate'].toDate().toString()}',
//                           style: TextStyle(fontSize: 14.0),
//                         ),
//                       ],
//                     ),
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(order['productImage'][0]),
//                     ),
//                     onTap: () {
//                       // Add onTap functionality if needed
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _saveAsPdf(context),
//         child: Icon(Icons.save),
//       ),
//     );
//   }

//   Future<void> _saveAsPdf(BuildContext context) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text(
//               'Orders Report',
//               style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//             ),
//           );
//         },
//       ),
//     );

//     final Directory? directory = await getExternalStorageDirectory();
//     final String path = directory!.path;
//     final File file = File('$path/orders_report.pdf');
//     await file.writeAsBytes(await pdf.save());

//     OpenFile.open(file.path);
//   }
// }

//3
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class OrdersReportPage extends StatefulWidget {
  @override
  _OrdersReportPageState createState() => _OrdersReportPageState();
}

class _OrdersReportPageState extends State<OrdersReportPage> {
  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Report'),
      ),
      body: FutureBuilder(
        future: _getOrdersData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final orders = snapshot.data as List<DocumentSnapshot>;
          if (orders.isEmpty) {
            return Center(
              child: Text('No orders found.'),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      order['productName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          'Buyer Email: ${order['email']}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Quantity: ${order['selectedQuantity']}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Total Price: ₹ ${order['totalPrice']}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 4.0),
                        // Text(
                        //   'Order Date: ${order['orderDate'].toDate().toString()}',
                        //   style: TextStyle(fontSize: 14.0),
                        // ),
                        Text(
                          'Order Date: ${DateFormat('yyyy-MM-dd').format(order['orderDate'].toDate())}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(order['productImage'][0]),
                    ),
                    onTap: () {
                      // Add onTap functionality if needed
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveAsPdf(context),
        child: Icon(Icons.save),
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getOrdersData() async {
    final querySnapshot = await _ordersStream.first;
    return querySnapshot.docs;
  }

  Future<void> _saveAsPdf(BuildContext context) async {
    final pdf = pw.Document();

    final orders = await _getOrdersData();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  'Orders Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
                  cellAlignment: pw.Alignment.center,
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  headerHeight: 25,
                  cellHeight: 25,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.centerLeft,
                    3: pw.Alignment.centerLeft,
                    4: pw.Alignment.centerLeft,
                  },
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  data: <List<String>>[
                    <String>[
                      'Product Name',
                      'Buyer Email',
                      'Quantity',
                      'Total Price',
                      'Order Date'
                    ],
                    for (var order in orders)
                      <String>[
                        order['productName'],
                        order['email'],
                        order['selectedQuantity'].toString(),
                        "₹" + " " + '${order['totalPrice']}',
                        order['orderDate'].toDate().toString(),
                      ]
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    final Directory? directory = await getExternalStorageDirectory();
    final String path = directory!.path;
    final File file = File('$path/orders_report.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }
}
