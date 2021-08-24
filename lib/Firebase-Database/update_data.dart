import 'dart:async';
import 'dart:io';
import 'package:firebase_class/Firebase-Authentication/sign_up.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateDatainDatabase extends StatefulWidget {
  UpdateDatainDatabase({Key? key}) : super(key: key);

  @override
  _UpdateDatainDatabaseState createState() => _UpdateDatainDatabaseState();
}

class _UpdateDatainDatabaseState extends State<UpdateDatainDatabase> {
  final _formKey = GlobalKey<FormState>();
  DatabaseReference db = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController? _fname;
  bool btnLoad = false;

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('Sign Up Page', style: kStyle)),
                    SizedBox(height: 20),
                    TextFieldd(_fname, 'Full name'),
                    SizedBox(height: 10),
                    !btnLoad
                        ? TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  btnLoad = true;
                                });
                                try {
                                  db.child('uid').update({
                                    "fname": _fname!.text,
                                  }).then((res) {
                                    btnLoad = false;
                                  }).timeout(timeOut);
                                } on SocketException catch (_) {
                                  snackBar(nointernet);
                                } on TimeoutException catch (_) {
                                  snackBar(timeMsg);
                                } catch (e) {
                                  snackBar('$e');
                                }
                                setState(() {
                                  btnLoad = false;
                                });
                              }
                            },
                            child: Text('Update user information'),
                          )
                        : Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                              ),
                            ),
                          ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  snackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$msg'),
        action: SnackBarAction(label: 'Close', onPressed: () {}),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fname = TextEditingController();
  }

  @override
  void dispose() {
    _fname!.dispose();
    super.dispose();
  }
}
