import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_class/Firebase-Storage/upload_img.dart';
import 'package:flutter/material.dart';

class FirestoreDataState extends StatefulWidget {
  FirestoreDataState({Key? key}) : super(key: key);

  @override
  __FirestoreDataStateState createState() => __FirestoreDataStateState();
}

class __FirestoreDataStateState extends State<FirestoreDataState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    final Stream<QuerySnapshot> _dataStream =
        FirebaseFirestore.instance.collection('products').snapshots();
    return Scaffold(
      appBar: AppBar(title: Text('Firestore'), actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadImage1(),
                ),
              );
            },
            icon: Icon(Icons.add)),
      ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Oops! Something went wrong 🥴'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0xffD6D6D6),
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              // dynamic ettt = '${data['prdTitle']} -- ' + data['test'] ?? '';
              return Column(
                children: [
                  SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                    margin:
                        EdgeInsets.only(bottom: 6, left: 8, right: 8, top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey[500]!.withOpacity(1.0),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['prdTitle']} -- ' +
                                        '${data['test']}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    '${data['prdTitle']}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 7,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: 60,
                                height: 86,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(data['prdImg']),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(height: 3),
                        MaterialButton(
                          onPressed: () async {
                            int addCall = data['clicked'] + 1;
                            await products
                                .doc(document.id)
                                .update({'clicked': addCall})
                                .then(
                                    (value) => print("Action Called and added"))
                                .catchError((error) =>
                                    print("Failed to add value: $error"));
                            // callBackAction(data['btnAction']);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                          child: Text('pay ' + data['prdPrice'],
                              style: TextStyle(color: Colors.white)),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
