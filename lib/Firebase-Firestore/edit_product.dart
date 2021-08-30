import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_class/admin/admin_panel.dart';
import 'package:flutter/material.dart';

class EditProducts extends StatefulWidget {
  final String pID;
  EditProducts({Key? key, required this.pID}) : super(key: key);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _pdName, _pdDes, _pdActPrice, _pdDisPrice, _pdImg;

  @override
  Widget build(BuildContext context) {
    CollectionReference update =
        FirebaseFirestore.instance.collection('new_products');
    final CollectionReference _dataStream =
        FirebaseFirestore.instance.collection('new_products');
    return FutureBuilder<DocumentSnapshot>(
      future: _dataStream.doc(widget.pID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          _pdName!.text = data['name'];
          _pdDes!.text = data['description'];
          _pdActPrice!.text = data['actual_price'];
          _pdDisPrice!.text = data['discount_price'];
          _pdImg!.text = data['image_url'];

          return Scaffold(
            appBar: AppBar(
              title: Text('${data['name']}'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      AdminTextField(
                          controller: _pdName, label: 'Product Name'),
                      SizedBox(height: 10),
                      AdminTextField(
                        controller: _pdDes,
                        label: 'Product Description',
                        maxLines: 3,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AdminTextField(
                              controller: _pdActPrice,
                              label: 'Actual Price',
                              prefixText: '₦',
                              maxLength: 7,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: AdminTextField(
                              controller: _pdDisPrice,
                              label: 'Discout Price',
                              prefixText: '₦',
                              maxLength: 7,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      AdminTextField(
                        controller: _pdImg,
                        label: 'Product Image Url',
                        keyboardType: TextInputType.url,
                      ),
                      SizedBox(height: 10),
                      Image.network(data['image_url']),
                      SizedBox(height: 10),
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await update.doc(widget.pID).update({
                              "name": _pdName!.text,
                              "description": _pdDes!.text,
                              "actual_price": _pdActPrice!.text,
                              "discount_price": _pdDisPrice!.text,
                              "image_url": _pdImg!.text,
                              "avalability": 1,
                              "closed": false,
                            }).then((value) => print('Product updated!!'));
                            // await FirebaseFirestore.instance
                            //     .collection("new_products")
                            //     .add({
                            //   "name": _pdName!.text,
                            //   "description": _pdDes!.text,
                            //   "actual_price": _pdActPrice!.text,
                            //   "discount_price": _pdDisPrice!.text,
                            //   "image_url": _pdImg!.text,
                            //   "avalability": 1,
                            //   "closed": false,
                            // }).then((value) {
                            //   print('Product added successfully, Yay!');
                            // }).catchError((error) =>
                            //         print("Failed to add product: $error"));
                          }
                        },
                        child: Text('Edit Product'),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pdName = TextEditingController();
    _pdDes = TextEditingController();
    _pdActPrice = TextEditingController();
    _pdDisPrice = TextEditingController();
    _pdImg = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _pdName!.dispose();
    _pdDes!.dispose();
    _pdActPrice!.dispose();
    _pdDisPrice!.dispose();
    _pdImg!.dispose();
  }
}
