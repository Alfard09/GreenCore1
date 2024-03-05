// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:intl/intl.dart';

// class OrdersReportPage extends StatefulWidget {
//   @override
//   _OrdersReportPageState createState() => _OrdersReportPageState();
// }

// class _OrdersReportPageState extends State<OrdersReportPage> {
//   late Stream<QuerySnapshot> _ordersStream;
//   String _selectedTimeRange = 'All'; // Default value

//   @override
//   void initState() {
//     super.initState();
//     _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Color(0xff42275a),
//         title: Text(
//           'Orders Report',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           DropdownButton<String>(
//             value: _selectedTimeRange,
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedTimeRange = newValue!;
//               });
//             },
//             items: <String>['All', '7 Days', '30 Days', '6 Months']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _getOrdersData(),
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
//           final orders = _filterOrders(snapshot.data as List<DocumentSnapshot>);
//           if (orders.isEmpty) {
//             return Center(
//               child: Text('No orders found.'),
//             );
//           }
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               var order = orders[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 4,
//                   color: Color.fromARGB(236, 66, 39, 90),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(16.0),
//                     title: Text(
//                       order['productName'],
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 8.0),
//                         Text(
//                           'Buyer Email: ${order['email']}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Quantity: ${order['selectedQuantity']}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Total Price: ₹ ${order['totalPrice']}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           'Order Date: ${DateFormat('yyyy-MM-dd').format(order['orderDate'].toDate())}',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             color: Colors.white,
//                           ),
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

//   Future<List<DocumentSnapshot>> _getOrdersData() async {
//     final querySnapshot = await _ordersStream.first;
//     return querySnapshot.docs;
//   }

//   List<DocumentSnapshot> _filterOrders(List<DocumentSnapshot> orders) {
//     if (_selectedTimeRange == 'All') {
//       return orders;
//     }

//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     DateTime startDate;
//     if (_selectedTimeRange == '7 Days') {
//       startDate = today.subtract(Duration(days: 7));
//     } else if (_selectedTimeRange == '30 Days') {
//       startDate = today.subtract(Duration(days: 30));
//     } else if (_selectedTimeRange == '6 Months') {
//       startDate = today.subtract(Duration(days: 180));
//     } else {
//       // Default to all orders if the selected time range is invalid
//       return orders;
//     }

//     return orders.where((order) {
//       final orderDate = (order['orderDate'] as Timestamp).toDate();
//       return orderDate.isAfter(startDate);
//     }).toList();
//   }

//   Future<void> _saveAsPdf(BuildContext context) async {
//     final pdf = pw.Document();

//     final orders = await _getOrdersData();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Column(
//               children: [
//                 pw.Text(
//                   'GreenCore',
//                   style: pw.TextStyle(
//                       fontSize: 22, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                   'Orders Report',
//                   style: pw.TextStyle(
//                       fontSize: 20, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.TableHelper.fromTextArray(
//                   border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
//                   cellAlignment: pw.Alignment.center,
//                   headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//                   headerHeight: 35,
//                   cellHeight: 30,
//                   cellAlignments: {
//                     0: pw.Alignment.centerLeft,
//                     1: pw.Alignment.centerLeft,
//                     2: pw.Alignment.centerLeft,
//                     3: pw.Alignment.centerLeft,
//                     4: pw.Alignment.centerLeft,
//                   },
//                   headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   data: <List<String>>[
//                     <String>[
//                       'Product Name',
//                       'Buyer Email',
//                       'Quantity',
//                       'Total Price',
//                       'Order Date'
//                     ],
//                     for (var order in orders)
//                       <String>[
//                         order['productName'],
//                         order['email'],
//                         order['selectedQuantity'].toString(),
//                         "₹" + " " + '${order['totalPrice']}',
//                         DateFormat('yyyy-MM-dd')
//                             .format(order['orderDate'].toDate()),
//                       ]
//                   ],
//                 ),
//               ],
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
  String _selectedTimeRange = 'All'; // Default value

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff42275a),
        title: Text(
          'Orders Report',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedTimeRange,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTimeRange = newValue!;
              });
            },
            items: <String>['All', '7 Days', '30 Days', '6 Months']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      color: Colors.black), // Change text color to white
                ),
              );
            }).toList(),
          ),
        ],
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
          final orders = _filterOrders(snapshot.data as List<DocumentSnapshot>);
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
                  color: Color.fromARGB(236, 66, 39, 90),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      order['productName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          'Buyer Email: ${order['email']}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Quantity: ${order['selectedQuantity']}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Total Price: ₹ ${order['totalPrice']}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Order Date: ${DateFormat('yyyy-MM-dd').format(order['orderDate'].toDate())}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
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

  List<DocumentSnapshot> _filterOrders(List<DocumentSnapshot> orders) {
    if (_selectedTimeRange == 'All') {
      return orders;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime startDate;
    if (_selectedTimeRange == '7 Days') {
      startDate = today.subtract(Duration(days: 7));
    } else if (_selectedTimeRange == '30 Days') {
      startDate = today.subtract(Duration(days: 30));
    } else if (_selectedTimeRange == '6 Months') {
      startDate = today.subtract(Duration(days: 180));
    } else {
      // Default to all orders if the selected time range is invalid
      return orders;
    }

    return orders.where((order) {
      final orderDate = (order['orderDate'] as Timestamp).toDate();
      return orderDate.isAfter(startDate);
    }).toList();
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
                  'GreenCore',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
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
                  headerHeight: 35,
                  cellHeight: 30,
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
                        DateFormat('yyyy-MM-dd')
                            .format(order['orderDate'].toDate()),
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
