import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RetrieveData extends StatefulWidget {
  RetrieveData({Key? key}) : super(key: key);

  @override
  _RetrieveDataState createState() => _RetrieveDataState();
}

class _RetrieveDataState extends State<RetrieveData> {
  final dbRef = FirebaseDatabase.instance.ref().child("pets");
  List<Map<dynamic, dynamic>> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Retrieve Data - Database')),
      body: FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data!.snapshot.value as Map;
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
                      Text("Name: " + lists[index]["fname"]),
                      Text("Email: " + lists[index]["email"]),
                      Text("User ID: " + lists[index]["uid"]),
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
