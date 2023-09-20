import 'package:flutter/material.dart';
import 'package:greencore_1/controllers/auth_controller.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:greencore_1/views/buyers/auth/register_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';

import '../../../vendor/views/auth/vendor_login_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  late String password;
  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);

      if (res == 'success') {
        // setState(() {
        //   //_formKey.currentState!.reset();
        //   _isLoading = false;
        // });
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MainScreen();
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        return showErrorSnack(context, 'User Not Found!!!');
      }

      //return showSnack(context, 'Logged in successfully!!!!');
    } else {
      setState(() {
        _isLoading = false;
      });
      return showErrorSnack(context, 'Please fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login Customer's Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter the email';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please Enter a Valid Email with @ and .";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(labelText: 'Enter Email '),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter the password';
                      } else if (value.length < 6) {
                        return 'password length should not be less than 6!!';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(labelText: 'Enter Password '),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainScreen();
                    }));
                  },
                  child: InkWell(
                    onTap: () {
                      _loginUsers();
                      // Navigator.push(context,
                      //   MaterialPageRoute(builder: (context) {
                      //return MainScreen();
                      // }));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  letterSpacing: 2.5,
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Need An Account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CustomerRegisterScreen();
                          }));
                        },
                        child: Text('Register'))
                  ],
                ),
                Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Are you a Vendor? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VendorLoginPage();
                      }));
                    },
                    child: Text('login'),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
