import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/auth/login_screen.dart';
import 'package:greencore_1/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:greencore_1/views/buyers/inner_screens/orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatelessWidget {
  // const AccountScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _logout(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await _auth.signOut();
      print('working');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    // return _auth.currentUser == null?
    // Scaffold(
    //         appBar: AppBar(
    //           elevation: 0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(
    //               15,
    //             ),
    //           ),
    //           backgroundColor: Colors.lightGreen.shade700,
    //           title: Text(
    //             'Profile',
    //             style: TextStyle(letterSpacing: 4),
    //           ),
    //           centerTitle: true,
    //           actions: [
    //             Padding(
    //               padding: const EdgeInsets.all(14.0),
    //               child: Icon(Icons.nightlight_round_outlined),
    //             )
    //           ],
    //         ),
    //         body: Column(
    //           // mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             SizedBox(height: 25),
    //             Center(
    //               child: CircleAvatar(
    //                 radius: 64,
    //                 backgroundColor: Color.fromARGB(255, 181, 187, 181),
    //                 child: Icon(Icons.person),
    //              ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 ""
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Login Account access profile"
    //                 style: TextStyle(
    //                   fontSize: 15,
    //                   fontWeight: FontWeight.w400,
    //                 ),
    //               ),
    //             ),
    //             InkWell(
    //               onTap: () {
    //
    //               },
    //               child: Container(
    //                 height: 40,
    //                 width: MediaQuery.of(context).size.width - 200,
    //                 decoration: BoxDecoration(
    //                   color: Colors.green.shade600,
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 child: Center(
    //                   child: Text(
    //                     'Login Account',
    //                     style: TextStyle(
    //                         color: Colors.white,
    //                         fontWeight: FontWeight.w600,
    //                         letterSpacing: 1),
    //                   ),
    //                 ),
    //               ),
    //             ),

    //
    //             ),
    //           ],
    //         ),
    //       ):

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  0,
                ),
              ),
              backgroundColor: Colors.white,
              title: Text(
                'Profile',
                style:
                    TextStyle(letterSpacing: 2, color: Colors.green.shade600),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(Icons.nightlight_round_outlined),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(data['profileImage']),
                      backgroundColor: Color.fromARGB(255, 181, 187, 181),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['fullName'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['email'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditProfileScreen(
                          userData: data,
                        );
                      }));
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 200,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.settings),
                  //   title: Text(
                  //     'Settings',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.phone),
                  //   title: Text(
                  //     'Phone',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.shopping_cart_checkout),
                  //   title: Text(
                  //     'Cart',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  ListTile(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CustomerOrderScreen();
                      }));
                    },
                    leading: Icon(CupertinoIcons.shopping_cart),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => _logout(context),
                    // onTap: () async {
                    //   // await _auth.signOut();
                    //   // //Navigator.of(context).pop();
                    //   // if (_auth.currentUser == null) {
                    //   //   // Navigate to the specific page after sign-out
                    //   //   Navigator.of(context).pushReplacement(
                    //   //     MaterialPageRoute(
                    //   //       builder: (context) => LoginScreen(),
                    //   //     ),
                    //   //   );
                    //   // }

                    //   print("Logout tapped"); // Check if this message is printed

                    //   try {
                    //     await _auth.signOut();
                    //     print('working');

                    //     // Navigate to the login screen only if the user is successfully signed out
                    //     if (_auth.currentUser == null) {
                    //       Navigator.of(context).pushReplacement(
                    //         MaterialPageRoute(
                    //           builder: (context) => LoginScreen(),
                    //         ),
                    //       );
                    //     }
                    //   } catch (e) {
                    //     print("Logout failed: $e");
                    //     // Handle logout failure if needed
                    //   }
                    // },
                    leading: Icon(Icons.logout),
                    title: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
