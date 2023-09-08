import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    //sign in process
    await GoogleSignIn().signOut();
    //then signin
    GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
