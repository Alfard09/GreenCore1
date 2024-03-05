// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:timeline_tile/timeline_tile.dart';
// import 'package:intl/intl.dart';

// class OrderTrackingCustomer extends StatefulWidget {
//   final String orderId;

//   const OrderTrackingCustomer({Key? key, required this.orderId})
//       : super(key: key);

//   @override
//   _OrderTrackingCustomerState createState() => _OrderTrackingCustomerState();
// }

// class _OrderTrackingCustomerState extends State<OrderTrackingCustomer> {
//   late FirebaseFirestore _firestore;

//   @override
//   void initState() {
//     super.initState();
//     _firestore = FirebaseFirestore.instance;
//   }

//   String _formatDate(Timestamp timestamp) {
//     DateTime date = timestamp.toDate();
//     return '${date.day}-${date.month}-${date.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.green.shade700,
//         title: Text(
//           "Order Details",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _firestore.collection('orders').doc(widget.orderId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final data = snapshot.data!.data() as Map<String, dynamic>;
//             String currentStatus = data['status'] ?? "Order Placed";
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   topDetails(data),
//                   Divider(),
//                   buildTimeline(currentStatus),
//                   SizedBox(height: 30),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }

//   Widget topDetails(Map<String, dynamic> data) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: ListTile(
//                 leading: Image.network(
//                   data['productImage'][0],
//                   fit: BoxFit.fill,
//                 ),
//                 title: Text(
//                   data['productName'],
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 subtitle: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Quantity:', style: TextStyle(fontSize: 14)),
//                         Text(data['selectedQuantity'].toString())
//                       ],
//                     ),
//                     data['accepted'] == true
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('Delivery Date:'),
//                               Text(_formatDate(data['scheduleDate'])),
//                             ],
//                           )
//                         : Container(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ListTile(
//           title: Text('Detail:'),
//           subtitle: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Name:'),
//                   Text(data['fullName']),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Email:'),
//                   Text(data['email']),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Address'),
//                   Text(data['address']),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildTimeline(String currentStatus) {
//     return Column(
//       children: [
//         TimelineTile(
//           alignment: TimelineAlign.manual,
//           isFirst: true,
//           lineXY: 0.1,
//           indicatorStyle: IndicatorStyle(
//             color: currentStatus == "Order Placed" ? Colors.green : Colors.grey,
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: currentStatus == "Order Placed"
//                     ? Colors.green
//                     : Colors.grey,
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           afterLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           startChild: SizedBox(width: 30),
//           endChild: Container(
//             padding: EdgeInsets.all(8.0),
//             color: Colors.grey[300],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Order Placed"),
//                 Text("Details of Order Placed"),
//               ],
//             ),
//           ),
//         ),
//         TimelineTile(
//           alignment: TimelineAlign.manual,
//           lineXY: 0.1,
//           indicatorStyle: IndicatorStyle(
//             color:
//                 currentStatus == "Shipped" ? Colors.green : Color(0xff42275a),
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: currentStatus == "Shipped" ? Colors.green : Colors.grey,
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           afterLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           startChild: SizedBox(width: 30),
//           endChild: Container(
//             padding: EdgeInsets.all(8.0),
//             color: Colors.grey[300],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Shipped"),
//                 Text("Details of Shipped"),
//               ],
//             ),
//           ),
//         ),
//         TimelineTile(
//           alignment: TimelineAlign.manual,
//           lineXY: 0.1,
//           indicatorStyle: IndicatorStyle(
//             color: currentStatus == "Out for Delivery"
//                 ? Colors.green
//                 : Colors.grey,
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: currentStatus == "Out for Delivery"
//                     ? Colors.green
//                     : Colors.grey,
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           afterLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           startChild: SizedBox(width: 30),
//           endChild: Container(
//             padding: EdgeInsets.all(8.0),
//             color: Colors.grey[300],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Out for Delivery"),
//                 Text("Details of Out for Delivery"),
//               ],
//             ),
//           ),
//         ),
//         TimelineTile(
//           alignment: TimelineAlign.manual,
//           lineXY: 0.1,
//           isLast: true,
//           indicatorStyle: IndicatorStyle(
//             color: currentStatus == "Delivered" ? Colors.green : Colors.grey,
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color:
//                     currentStatus == "Delivered" ? Colors.green : Colors.grey,
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           afterLineStyle: LineStyle(
//             color: Colors.grey,
//           ),
//           startChild: SizedBox(width: 30),
//           endChild: Container(
//             padding: EdgeInsets.all(8.0),
//             color: Colors.grey[300],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Delivered"),
//                 Text("Details of Delivered"),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeline_tile/timeline_tile.dart';
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
                  SizedBox(height: 30),
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
