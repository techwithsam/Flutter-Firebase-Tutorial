import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? name;
  String? email;
  String? imageUrl;

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      assert(user!.email != null);
      assert(user!.displayName != null);
      assert(user!.displayName != null);
      name = user!.displayName;
      email = user.email;
      imageUrl = user.photoURL;
      print(user.displayName);
      print(user.email);
      print(user.phoneNumber);
      print(user.photoURL);
      print(user.providerData);
      print(user.uid);

      print('signInWithGoogle succeeded: $user');
      return 'signInWithGoogle succeeded: $user';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // throw e;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print('User signed out!');
  }
}
