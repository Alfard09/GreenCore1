import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/auth/vendor_login_screen.dart';

import '../screens/landing_screen.dart';
import 'auth_service.dart';

class VendorRegisterPage extends StatefulWidget {
  const VendorRegisterPage({super.key});

  @override
  State<VendorRegisterPage> createState() => _VendorRegisterPageState();
}

class _VendorRegisterPageState extends State<VendorRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late String Cpassword;

  //sign vendor in method
  void signUserUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
        if (password == Cpassword) {
          //creating user with email and pssword
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
              .whenComplete(() {
            setState(() {
              _formKey.currentState!.reset();
            });
          });

          Navigator.pop(context);
        } else {
          //show error
          Navigator.pop(context);
          PasswordMessage();
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        //wrong email
        if (e.code == 'user-not-found') {
          print('No user found!!!');
          //show error to userr
          wrongEmailMessage();
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          userExistMessage();
        } else if (e.code == 'wrong-password') {
          print('Wrong password');
          //error message
          wrongPasswordMessage();
        }
      }
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Congratulation Account have been Created!!')));
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
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: Border.all(),
            title: Text('Incorrect password'),
          );
        });
  }

  void userExistMessage() {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         shape: Border.all(),
    //         title: Text('User already exists!!'),
    //       );
    //     });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('User Already Exists!!')));
  }

  void PasswordMessage() {
    //showDialog(
    // context: context,
    // builder: (context) {
    //   return AlertDialog(
    //     // shape: Border.all(),
    //     title: Text('Password do not match!!'),
    //   );
    // });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password do not Match!!'),
      ),
    );
  }

  void signInWithGoogle() async {
    try {
      await AuthService().signInWithGoogle();
      // Navigate to the next screen after successful Google sign-in.
      print('successfull');
      // Example:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LandingScreen()));
    } catch (e) {
      print('Error signing in with Google: $e');
    }
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
                    "Let's create an account!!!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 8, 8, 8),
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  //usrname text field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
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
                  // password textfield
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please password must not be empty!!';
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
                  SizedBox(
                    height: 10,
                  ),
                  //confirm password text filrd
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      //controller: confirmpasswordcontroller,
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
                        Cpassword = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
                  //button for sign up
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: GestureDetector(
                      onTap: () {
                        return signUserUp();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25)),
                        child: Center(
                          child: Text(
                            "Sign Up",
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
                      signInWithGoogle();
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
                        Text('Already a Vendor? '),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VendorLoginPage();
                            }));
                          },
                          child: Text(
                            'Login Now',
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
