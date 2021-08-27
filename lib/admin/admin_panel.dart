import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_class/Firebase-Authentication/sign_up.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _pdName, _pdDes, _pdActPrice, _pdDisPrice, _pdImg;
  bool _btnLoad = false, _shwprw = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel'), centerTitle: true),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
            child: Column(
              children: [
                Center(child: Text('Add Product', style: kStyle)),
                SizedBox(height: 20),
                AdminTextField(controller: _pdName, label: 'Product Name'),
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
                Text('Or'),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return imagePick();
                      },
                    );
                  },
                  child: Text('Select Image to upload'),
                ),
                SizedBox(height: 20),
                _btnLoad
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _btnLoad = true;
                                });
                                try {
                                  await FirebaseFirestore.instance
                                      .collection("new_products")
                                      .add({
                                    "name": _pdName!.text,
                                    "description": _pdDes!.text,
                                    "actual_price": _pdActPrice!.text,
                                    "discount_price": _pdDisPrice!.text,
                                    "image_url": _pdImg!.text,
                                    "avalability": 1,
                                    "closed": false,
                                  }).then((value) {
                                    setState(() {
                                      _btnLoad = false;
                                    });
                                    return snackBar(
                                        'Product added successfully, Yay!');
                                  }).catchError((error) => snackBar(
                                          "Failed to add product: $error"));
                                } on SocketException catch (_) {
                                  snackBar(nointernet);
                                } on TimeoutException catch (_) {
                                  snackBar(timeMsg);
                                } catch (e) {
                                  snackBar('$e');
                                }
                                setState(() {
                                  _btnLoad = false;
                                });
                              }
                            },
                            child: Text('Add Product'),
                            color: Colors.blue,
                          ),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _shwprw = !_shwprw;
                                });
                              }
                            },
                            child: Text('Preview product'),
                          )
                        ],
                      ),
                SizedBox(height: 10),
                Visibility(
                  visible: _shwprw,
                  child: Container(
                    margin: EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            image: DecorationImage(
                              image: NetworkImage('${_pdImg!.text}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${_pdName!.text}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(height: 4),
                              Text(
                                "${_pdDes!.text}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "₦${_pdDisPrice!.text}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₦${_pdActPrice!.text}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Container(
                                    color: Colors.blue.withOpacity(0.2),
                                    padding: const EdgeInsets.all(2.3),
                                    child: Text('-32%'),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Center(
                                  child: MaterialButton(
                                minWidth: double.infinity,
                                onPressed: () {},
                                child: Text('Buy Now!'),
                                color: Colors.blue,
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  imagePick() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  child: Icon(Icons.photo_album),
                ),
                SizedBox(height: 8),
                Text('Gallery '),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  child: Icon(Icons.photo_album),
                ),
                SizedBox(height: 8),
                Text('Camera '),
              ],
            ),
          ),
        ],
      ),
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

class AdminTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label, prefixText;
  final int? maxLines, maxLength;
  final TextInputType? keyboardType;
  const AdminTextField({
    this.controller,
    this.label,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty)
          return 'Empty field detected';
        else
          return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5, 8, 10, 5),
        isDense: true,
        labelText: '$label',
        counterText: '',
        prefixText: prefixText,
      ),
    );
  }
}
