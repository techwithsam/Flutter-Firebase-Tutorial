import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_class/Firebase-Authentication/firebase_services.dart';
import 'package:firebase_class/Firebase-Authentication/sign_up.dart';
import 'package:firebase_class/homepage.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  FirebaseService service = FirebaseService();
  TextEditingController? _email, _password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Authentication')),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 22),
              child: Column(
                children: [
                  Center(child: Text('Sign In Page', style: kStyle)),
                  SizedBox(height: 20),
                  TextFieldd(_email, 'Email'),
                  SizedBox(height: 10),
                  TextFieldd(_password, 'Password'),
                  SizedBox(height: 10),
                  _isLoading
                      ? Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _email!.text,
                                        password: _password!.text)
                                    .then((value) {
                                  _isLoading = false;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(uid: value.user!.uid),
                                    ),
                                  );
                                }).timeout(timeOut);
                              } on SocketException catch (_) {
                                snackBar(nointernet);
                              } on TimeoutException catch (_) {
                                snackBar(timeMsg);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  snackBar('No user found for that email.');
                                } else if (e.code == 'wrong-password') {
                                  snackBar(
                                      'Wrong password provided for that user.');
                                } else
                                  snackBar('${e.message}');
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Text('Sign In | email & password.'),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  snackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$msg'),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    ));
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email!.dispose();
    _password!.dispose();
    super.dispose();
  }
}
