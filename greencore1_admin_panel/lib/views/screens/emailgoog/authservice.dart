import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  signInWithGoogle() async {
    //begin sign in proceses
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //sigin
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}



// child: FloatingActionButton.extended(
//                     onPressed: () async {
//                       //GoogleSignIn().signIn();
//                       await AuthService().signInWithGoogle().then((isSuccess) {
//                         if (isSuccess) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MainScreen(),
//                             ),
//                           );
//                         }
//                       }).catchError((error) {
//                         print("Error during sign-in: $error");
//                       });
//                     },
//                     icon: Icon(Icons.security),
//                     label: Text(
//                       'Sign in with Google',
//                     ))),



 