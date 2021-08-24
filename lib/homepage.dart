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
        title: Text('Homepage'),
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbRef = FirebaseDatabase.instance.reference().child("pets");
  List<Map<dynamic, dynamic>> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data!.value;
            values.forEach((key, values) {
              lists.add(values);
            });
            return ListView.builder(
              shrinkWrap: true,
              itemCount: lists.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name: " + lists[index]["name"]),
                      Text("Age: " + lists[index]["age"]),
                      Text("Type: " + lists[index]["type"]),
                    ],
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
