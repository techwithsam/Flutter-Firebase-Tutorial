import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _email, _password;
  bool isLoading = false, btnLoad = false;

  @override
  Widget build(BuildContext context) {
    FirebaseService service = FirebaseService();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !btnLoad
                  ? TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            btnLoad = true;
                          });
                          try {
                            await service.signInWithEmailAndPassword(
                                _email!.text, _password!.text);
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              print(e.message);
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              print(e.message);
                            } else
                              print(e.message);
                          }
                          setState(() {
                            btnLoad = false;
                          });
                        }
                      },
                      child: Text('Sign with email and password'))
                  : Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      ),
                    ),
              SizedBox(height: 12),
              !isLoading
                  ? TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await service.signInwithGoogle();
                          print(
                              'Sign with Google completed - navigate to home screen');
                        } catch (e) {
                          if (e is FirebaseAuthException) {
                            print(e.message!);
                          } else
                            print('$e');
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: Text('Sign in with google'),
                    )
                  : SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: email);

      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
      } else
        print(e.message);
      return e.message;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    print('User signed out!');
  }
}
