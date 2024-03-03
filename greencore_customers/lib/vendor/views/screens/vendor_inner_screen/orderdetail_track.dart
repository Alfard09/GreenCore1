// import 'package:flutter/material.dart';
// import 'package:order_tracker_zen/order_tracker_zen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderTrackingPage extends StatefulWidget {
//   final String orderId;

//   const OrderTrackingPage({Key? key, required this.orderId}) : super(key: key);

//   @override
//   _OrderTrackingPageState createState() => _OrderTrackingPageState();
// }

// class _OrderTrackingPageState extends State<OrderTrackingPage> {
//   late String _currentStatus;
//   late FirebaseFirestore _firestore;
//   List<TrackerData> _trackerData = [
//     TrackerData(
//       title: "Order Placed",
//       date: "Date",
//       tracker_details: [],
//     )
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = "Order Placed"; // Initial status
//     _firestore = FirebaseFirestore.instance;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Order Tracking"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             OrderTrackerZen(tracker_data: _trackerData),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updateStatus,
//               child: Text("Update Status"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateStatus() async {
//     String nextStatus = _getNextStatus(_currentStatus);
//     try {
//       // Update status in the database
//       await _firestore.collection('orders').doc(widget.orderId).update({
//         'status': nextStatus,
//       });

//       // Update UI
//       setState(() {
//         _currentStatus = nextStatus;
//         _trackerData.add(
//           TrackerData(
//             title: nextStatus,
//             date: DateTime.now().toString(),
//             tracker_details: [],
//           ),
//         );
//       });

//       // Show a message indicating successful update
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status updated to $nextStatus")),
//       );
//     } catch (error) {
//       // Show an error message if update fails
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error updating status: $error")),
//       );
//     }
//   }

//   String _getNextStatus(String currentStatus) {
//     switch (currentStatus) {
//       case 'Order Placed':
//         return 'Shipped';
//       case 'Shipped':
//         return 'Out for Delivery';
//       case 'Out for Delivery':
//         return 'Delivered';
//       default:
//         return 'Delivered';
//     }
//   }
// }

//2
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:timeline_tile/timeline_tile.dart';

// class OrderTrackingPage extends StatefulWidget {
//   final String orderId;

//   const OrderTrackingPage({Key? key, required this.orderId}) : super(key: key);

//   @override
//   _OrderTrackingPageState createState() => _OrderTrackingPageState();
// }

// class _OrderTrackingPageState extends State<OrderTrackingPage> {
//   late String _currentStatus;
//   late FirebaseFirestore _firestore;
//   Map<String, dynamic>? data;

//   @override
//   void initState() {
//     super.initState();
//     _currentStatus = "Order Placed"; // Initial status
//     _firestore = FirebaseFirestore.instance;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Color(0xff42275a),
//         title: Text(
//           "Order Details",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             StreamBuilder<DocumentSnapshot>(
//               stream: _firestore
//                   .collection('orders')
//                   .doc(widget.orderId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   data = snapshot.data!.data() as Map<String, dynamic>;
//                   _currentStatus = data?['status'] ?? "Order Placed";
//                 }
//                 return Column(
//                   children: [
//                     topDetails(),
//                     Divider(),
//                     buildTimeline(),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updateStatus,
//               child: Text("Update Status"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget topDetails() {
//     return Row(
//       children: [
//         Expanded(
//           child: ListTile(
//             leading: Image.network(
//               data?['productImage'][0],
//               fit: BoxFit.fill,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Widget buildTimeline() {
//     return Column(
//       children: [
//         TimelineTile(
//           alignment: TimelineAlign.manual,
//           isFirst: true,
//           lineXY: 0.1,
//           indicatorStyle: IndicatorStyle(
//             color: _currentStatus == "Order Placed"
//                 ? Colors.green
//                 : Color(0xff42275a),
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentStatus == "Order Placed"
//                     ? Colors.green
//                     : Color(0xff42275a),
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
//           ),
//           afterLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
//           ),

//           startChild: SizedBox(width: 30), // Empty space for the timeline
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
//                 _currentStatus == "Shipped" ? Colors.green : Color(0xff42275a),
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentStatus == "Shipped"
//                     ? Colors.green
//                     : Color(0xff42275a),
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
//           ),
//           afterLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
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
//             color: _currentStatus == "Out for Delivery"
//                 ? Colors.green
//                 : Colors.grey,
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentStatus == "Out for Delivery"
//                     ? Colors.green
//                     : Color(0xff42275a),
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
//           ),
//           afterLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
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
//             color: _currentStatus == "Delivered"
//                 ? Colors.green
//                 : Color(0xff42275a),
//             width: 30,
//             indicator: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _currentStatus == "Delivered"
//                     ? Colors.green
//                     : Color(0xff42275a),
//               ),
//             ),
//           ),
//           beforeLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
//           ),
//           afterLineStyle: LineStyle(
//             color: Color(0xff42275a), // Set line color
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

//   void _updateStatus() async {
//     String nextStatus = _getNextStatus(_currentStatus);
//     try {
//       // Update status in the database
//       await _firestore.collection('orders').doc(widget.orderId).update({
//         'status': nextStatus,
//       });

//       // Update UI
//       setState(() {
//         _currentStatus = nextStatus;
//       });

//       // Show a message indicating successful update
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status updated to $nextStatus")),
//       );
//     } catch (error) {
//       // Show an error message if update fails
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error updating status: $error")),
//       );
//     }
//   }

//   String _getNextStatus(String currentStatus) {
//     switch (currentStatus) {
//       case 'Order Placed':
//         return 'Shipped';
//       case 'Shipped':
//         return 'Out for Delivery';
//       case 'Out for Delivery':
//         return 'Delivered';
//       default:
//         return 'Delivered';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
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
        backgroundColor: Color(0xff42275a),
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
                  ElevatedButton(
                    onPressed: () => _updateStatus(currentStatus),
                    child: Text(
                      "Update Status",
                      style: TextStyle(color: Colors.purple),
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

  Widget buildTimeline(String currentStatus) {
    return Column(
      children: [
        TimelineTile(
          alignment: TimelineAlign.manual,
          isFirst: true,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            color: currentStatus == "Order Placed"
                ? Colors.green
                : Color(0xff42275a),
            width: 30,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentStatus == "Order Placed"
                    ? Colors.green
                    : Color(0xff42275a),
              ),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          afterLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          startChild: SizedBox(width: 30),
          endChild: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order Placed"),
                Text("Details of Order Placed"),
              ],
            ),
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            color:
                currentStatus == "Shipped" ? Colors.green : Color(0xff42275a),
            width: 30,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentStatus == "Shipped"
                    ? Colors.green
                    : Color(0xff42275a),
              ),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          afterLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          startChild: SizedBox(width: 30),
          endChild: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Shipped"),
                Text("Details of Shipped"),
              ],
            ),
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            color: currentStatus == "Out for Delivery"
                ? Colors.green
                : Colors.grey,
            width: 30,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentStatus == "Out for Delivery"
                    ? Colors.green
                    : Color(0xff42275a),
              ),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          afterLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          startChild: SizedBox(width: 30),
          endChild: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Out for Delivery"),
                Text("Details of Out for Delivery"),
              ],
            ),
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isLast: true,
          indicatorStyle: IndicatorStyle(
            color:
                currentStatus == "Delivered" ? Colors.green : Color(0xff42275a),
            width: 30,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentStatus == "Delivered"
                    ? Colors.green
                    : Color(0xff42275a),
              ),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          afterLineStyle: LineStyle(
            color: Color(0xff42275a),
          ),
          startChild: SizedBox(width: 30),
          endChild: Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Delivered"),
                Text("Details of Delivered"),
              ],
            ),
          ),
        ),
      ],
    );
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
