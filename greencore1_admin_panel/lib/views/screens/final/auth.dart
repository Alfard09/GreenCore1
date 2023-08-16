
// import 'dart:math';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';  
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// final GoogleSignIn googleSIgnIn = GoogleSignIn();
// String? useEmail;
// String? imageUrl;


// Future<User?> signInWithGoogle() async{
//   await Firebase.initializeApp();

//   User? user;

//   if(kIsWeb){
//     GoogleAuthProvider authProvider = GoogleAuthProvider();

//     try{
//       final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
//     }catch(e){
//       print(e);
//     }
//   }else{
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

//     if(googleSignInAccount !=null){
//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       try{
//         final UserCredential userCredential = await _auth.signInWithCredential(credential);
//         user = userCredential.user;

//       }on FirebaseAuthException catch(e){
//         if(e.code == 'account-exists-with-different-credentials'){
//           print("Account already exists");
//         }
//       else if(e.code == 'invalid-credentials'){
//         print("Try again");
//       }
//     }catch(e){
//       print(e);
//     }
//   }
// }

// if()
// }
