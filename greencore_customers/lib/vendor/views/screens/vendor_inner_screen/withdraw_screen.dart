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

  late double currentBalance; // Declaring currentBalance variable

  @override
  void initState() {
    super.initState();
    fetchCurrentBalance(); // Fetching current balance when the screen initializes
  }

  // Fetching current balance from Firestore
  Future<void> fetchCurrentBalance() async {
    final vendorId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .get();
    setState(() {
      currentBalance = vendorSnapshot['balance'];
    });
  }

  //mail funtion
  void sendEmail(
    String recipientEmail,
    String name,
    String bankAccountName,
    String amount,
  ) async {
    username = 'alfardkoshy2024@mca.ajce.in';
    password = 'alfardkoshy0307';

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
          //chatgpt validation
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount must not be empty';
                    } else if (!RegExp(r'^[0-9]+(\.[0-9]+)?$')
                        .hasMatch(value)) {
                      return 'Enter a valid amount';
                    } else if (double.parse(value) > currentBalance) {
                      return 'Amount cannot exceed balance';
                    }
                    return null;
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
                    }
                    return null;
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
                      return 'Phone must not be empty';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email must not be empty';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
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
                    }
                    return null;
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
                      return 'Bank Account Name must not be empty';
                    }
                    return null;
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
                    } else if (!RegExp(r'^[0-9]{12,17}$').hasMatch(value)) {
                      return 'Account number must be between 12 and 17 digits';
                    }
                    return null;
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

                      // final DocumentSnapshot vendorSnapshot =
                      //     await FirebaseFirestore.instance
                      //         .collection('vendors')
                      //         .doc(vendorId)
                      //         .get();
                      // final double currentBalance = vendorSnapshot['balance'];

                      final vendorId = FirebaseAuth.instance.currentUser!.uid;
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
