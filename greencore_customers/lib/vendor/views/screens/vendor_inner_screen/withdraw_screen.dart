import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late String amount;

  late String name;

  late String mobile;

  late String bankName;

  late String bankAccountName;

  late String bankAccountNumber;

  late String email;

  late String username;
  late String password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //mail funtion
  void sendEmail(
    String recipientEmail,
    String name,
    String bankAccountName,
    String amount,
  ) async {
    username = 'alfardkoshy2024@mca.ajce.in';
    password = 'alfardkoshy1507';
    // username = dotenv.env['EMAIL_ADDRESS'].toString();
    // password = dotenv.env['EMAIL_PASSWORD'].toString();

    final smtpServer = gmail(username, password);
    //creating mail

    final message = Message()
      ..from = Address(username, 'GreenCore Admin')
      ..recipients.add(recipientEmail)
      ..subject = 'Withdrawal Confirmation'
      ..text =
          'Hello $name,\n\nYour withdrawal request for ₹ $amount has been successfully processed to your bank account $bankAccountName.\n\nThank you for using our service.';

    try {
      final sendReport = await send(message, smtpServer);
      print('mssg sent' + sendReport.toString());
    } on MailerException catch (e) {
      print('Mssg not send');
      for (var p in e.problems) {
        print('Problem: ${p.code}:${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3f1651),
        title: Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'phone must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'email must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Bank Name must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Account name must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Account Name',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Account number must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      EasyLoading.show();
                      //store data in cloud firestore
                      await _firestore
                          .collection('withdrawal')
                          .doc(Uuid().v4())
                          .set({
                        'amount': amount,
                        'name': name,
                        'mobile': mobile,
                        'email': email,
                        'bankname': bankName,
                        'bankaccountname': bankAccountName,
                        'bankaccountnumber': bankAccountNumber,
                      });
                      //update firebase value
                      // Update balance in vendor collection
                      final vendorId = FirebaseAuth.instance.currentUser!.uid;
                      final DocumentSnapshot vendorSnapshot =
                          await FirebaseFirestore.instance
                              .collection('vendors')
                              .doc(vendorId)
                              .get();
                      final double currentBalance = vendorSnapshot['balance'];
                      final double withdrawnAmount = double.parse(amount);
                      final double newBalance =
                          currentBalance - withdrawnAmount;
                      await FirebaseFirestore.instance
                          .collection('vendors')
                          .doc(vendorId)
                          .update({'balance': newBalance});

                      //send email
                      sendEmail(email, name, bankAccountName, amount);

                      //reset form
                      _formkey.currentState!.reset();

                      // Wait for a few seconds
                      await Future.delayed(Duration(
                          seconds: 1)); // Change the duration as needed
                      EasyLoading.dismiss();
                      // Navigate to the previous page
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    'Get Cash',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//2
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:uuid/uuid.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// class WithdrawalScreen extends StatefulWidget {
//   @override
//   State<WithdrawalScreen> createState() => _WithdrawalScreenState();
// }

// class _WithdrawalScreenState extends State<WithdrawalScreen> {
//   late String amount;
//   late String name;
//   late String mobile;
//   late String bankName;
//   late String bankAccountName;
//   late String bankAccountNumber;
//   late String email;

//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to get user email from Firebase Authentication using user UID
//   Future<String?> getUserEmail(String uid) async {
//     try {
//       // Get the user using the user ID (UID)
//       User? user = await FirebaseAuth.instance.currentUser;

//       // Check if user is found
//       if (user != null) {
//         // Return the user's email
//         return user.email;
//       } else {
//         // User not found
//         return null;
//       }
//     } catch (e) {
//       // Error occurred while fetching user
//       print('Error fetching user: $e');
//       return null;
//     }
//   }

//   // Mail function
//   void sendEmail(
//     String recipientEmail,
//     String name,
//     String bankAccountName,
//     String amount,
//   ) async {
//     // Get email and password for sending email
//     String? username = 'alfardkoshy2024@mca.ajce.in'; // Your Gmail username
//     String? password = 'alfardkoshy1507'; // Your Gmail password

//     final smtpServer = gmail(username, password);

//     final message = Message()
//       ..from = Address(username, 'GreenCore Admin')
//       ..recipients.add(recipientEmail)
//       ..subject = 'Withdrawal Confirmation'
//       ..text =
//           'Hello, \n\nYour withdrawal request for $amount has been successfully processed to your bank account $bankAccountName.\n\nThank you for using our service.';

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: $sendReport');
//     } on MailerException catch (e) {
//       print('Email sending failed: ${e.message}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff3f1651),
//         title: Text(
//           'Withdraw',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formkey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Amount must not be empty';
//                     } else {
//                       return null;
//                     }
//                   },
//                   onChanged: (value) {
//                     amount = value;
//                   },
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Amount',
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 // Other form fields
//                 // Add TextFormField widgets for other form fields
//                 // Similar to the 'Amount' field above
//                 TextButton(
//                   onPressed: () async {
//                     if (_formkey.currentState!.validate()) {
//                       EasyLoading.show();

//                       // Store data in Cloud Firestore
//                       await _firestore
//                           .collection('withdrawal')
//                           .doc(Uuid().v4())
//                           .set({
//                         'amount': amount,
//                         // Add other form field values to Firestore document
//                         // Example:
//                         // 'name': name,
//                         // 'mobile': mobile,
//                         // 'email': email,
//                         // 'bankname': bankName,
//                         // 'bankaccountname': bankAccountName,
//                         // 'bankaccountnumber': bankAccountNumber,
//                       });

//                       // Update Firebase value
//                       final vendorId = FirebaseAuth.instance.currentUser!.uid;
//                       final DocumentSnapshot vendorSnapshot =
//                           await FirebaseFirestore.instance
//                               .collection('vendors')
//                               .doc(vendorId)
//                               .get();
//                       final double currentBalance = vendorSnapshot['balance'];
//                       final double withdrawnAmount = double.parse(amount);
//                       final double newBalance =
//                           currentBalance - withdrawnAmount;
//                       await FirebaseFirestore.instance
//                           .collection('vendors')
//                           .doc(vendorId)
//                           .update({'balance': newBalance});

//                       // Send email
//                       // Ensure to uncomment and provide necessary values
//                       String? userUid =
//                           'NlFiZJVXqMa8YF7wfrrkCzFIWAq2'; // Replace with user UID
//                       String? recipientEmail = await getUserEmail(userUid);
//                       if (recipientEmail != null) {
//                         sendEmail(
//                             recipientEmail, 'alfard', 'Alfard Koshy', amount);
//                       } else {
//                         print('User email not found');
//                       }

//                       // Reset form
//                       _formkey.currentState!.reset();

//                       // Wait for a few seconds
//                       await Future.delayed(Duration(seconds: 1));

//                       EasyLoading.dismiss();

//                       // Navigate to the previous page
//                       Navigator.of(context).pop();
//                     }
//                   },
//                   child: Text(
//                     'Get Cash',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
