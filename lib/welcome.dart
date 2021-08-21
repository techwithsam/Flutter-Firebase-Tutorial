import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_class/Firebase-Authentication/firebase_auth.dart';
import 'package:firebase_class/homepage.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? result = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(result);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splash screen', style: TextStyle(fontSize: 30)),
            SizedBox(height: 15),
            SizedBox(width: 180, child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              result != null ? HomePage() : FirebaseAuthentication(),
        ),
      );
    });
    // result != null ? HomePage(uid: result.uid) : SignUp(),
  }

  @override
  void dispose() {
    super.dispose();
  }
}
