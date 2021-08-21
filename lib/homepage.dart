import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Firebase-Authentication/sign_up.dart';
import 'Firebase-Authentication/firebase_services.dart';

class HomePage extends StatefulWidget {
  final String uid;
  HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService service = FirebaseService();
  final dbRef = FirebaseDatabase.instance.reference().child("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await service.signOutFromGoogle().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingUpScreen(),
                  ),
                );
              });
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: FutureBuilder(
        future: dbRef.child(widget.uid).once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Full Name: " + snapshot.data!.value["fname"]),
                  Text("User Email: " + snapshot.data!.value["email"]),
                  Text("User ID: " + snapshot.data!.value["uid"]),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
