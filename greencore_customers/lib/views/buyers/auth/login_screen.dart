import 'package:flutter/material.dart';
import 'package:greencore_1/controllers/auth_controller.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:greencore_1/views/buyers/auth/register_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // String? password = ''; //testing changes
  bool _isLoading = false;

//added login persistent status
  @override
  void initState() {
    super.initState();
    // Check if already logged in
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isCustomerLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainScreen()));
    }
  }
  //changes......

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password); //password

      if (res == 'success') {
        // setState(() {
        //   //_formKey.currentState!.reset();
        //   _isLoading = false;
        // });
        //
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isCustomerLoggedIn', true);
        //
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
                    key: Key('email_textfield'),
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
                    key: Key('password_textfield'),
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
                      //testing chnages
                      // setState(() {
                      //   password = value;
                      // });
                      //
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
                    //changes made for testing
                    onTap: () {
                      _loginUsers();
                      // Navigator.push(context,
                      //   MaterialPageRoute(builder: (context) {
                      //return MainScreen();
                      // }));
                    },
                    //
                    // onTap: () {
                    //   if (password != null && password!.length >= 6) {
                    //     _loginUsers();
                    //   } else {
                    //     showErrorSnack(context,
                    //         'Password length should be at least 6 characters');
                    //   }
                    // },
                    //
                    child: Container(
                      key: Key('navigate_to_main_button'),
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
