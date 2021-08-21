import 'package:firebase_class/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Firebase-Authentication/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Firebase | everything you need to know',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/firebase-auth',
      routes: AppRoute.routes,
    );
  }
}

class AppRoute {
  static Map<String, Widget Function(BuildContext context)> routes = {
    '/firebase-auth': (_) => FirebaseAuthentication(),
    '/homepage': (_) => HomePage(),
  };
}
