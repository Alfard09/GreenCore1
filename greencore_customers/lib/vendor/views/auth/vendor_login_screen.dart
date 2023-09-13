import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/auth/vendor_registerpage(logreg).dart';
import 'package:greencore_1/vendor/views/screens/landing_screen.dart';

import 'auth_service.dart';

class VendorLoginPage extends StatefulWidget {
  @override
  State<VendorLoginPage> createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage> {
  late String email;
  late String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //sign vendor in method
  signUserIn() async {
    //show loading widget
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });

    //signin
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if sign-in was successful
        if (userCredential.user != null) {
          print('Sign-in successful');
          // Sign-in was successful, navigate to the next page (HomeScreen)
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LandingScreen()), // Replace with your desired next page widget
          ).whenComplete(() {
            _formKey.currentState!.reset();
          });
        } else {
          // Handle the case where userCredential.user is null (sign-in failed)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign-in failed. Please check your credentials.'),
            ),
          );
        }
        //print(cred.credential);
        //await cred.user!.getIdToken();

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print(e);
        Navigator.pop(context);
        //wrong email
        if (e.code == 'user-not-found') {
          print('No user found!!!');
          //show error to userr
          wrongEmailMessage();
        } else if (e.code == 'wrong-password') {
          print('Wrong password');

          //error message
          wrongPasswordMessage();
        }
      }
    }
  }

  //wrong email popup
  void wrongEmailMessage() {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Incorrect Email'),
    //       );
    //     });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('No User Found!!')));
  }

  void wrongPasswordMessage() {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Incorrect password'),
    //       );
    //     });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Incorrrect Password!!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back, you have been missed!!!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 8, 8),
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  //usrname
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      //controller: emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please email cannot be empty';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Please Enter a Valid Email";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Email',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //password form field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please Password must not be empty!';
                        } else if (value.length < 6) {
                          return 'please enter a password of atleast 6 character!';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //button sigin
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: GestureDetector(
                      onTap: () {
                        signUserIn();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Text('or continue with'),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton.extended(
                    icon: Icon(
                      Icons.security_rounded,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      AuthService().signInWithGoogle();
                    },
                    label: Text(
                      'Sign In with Google',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a Vendor? '),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VendorRegisterPage();
                            }));
                          },
                          child: Text(
                            'Register Now',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
