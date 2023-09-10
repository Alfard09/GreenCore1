import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        backgroundColor: Colors.lightGreen.shade700,
        title: Text(
          'Profile',
          style: TextStyle(letterSpacing: 4),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Icon(Icons.nightlight_round_outlined),
          )
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Center(
            child: CircleAvatar(
              radius: 64,
              backgroundColor: Color.fromARGB(255, 181, 187, 181),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Alfred Koshy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'xyz@gmail.com',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
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
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              'Phone',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart_checkout),
            title: Text(
              'Cart',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.shopping_cart),
            title: Text(
              'Orders',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
