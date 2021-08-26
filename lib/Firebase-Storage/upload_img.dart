import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class UploadImage1 extends StatefulWidget {
  UploadImage1({Key? key}) : super(key: key);

  @override
  _UploadImage1State createState() => _UploadImage1State();
}

class _UploadImage1State extends State<UploadImage1> {
  var storage = FirebaseStorage.instance;
  late List<AssetImage> listOfImage;
  bool clicked = false;
  List<String?> listOfStr = [];
  String? images;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Just a title')),
      body: Container(
        child: Column(
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: listOfImage.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 3.0),
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: Material(
                    child: GestureDetector(
                      child: Stack(children: <Widget>[
                        this.images == listOfImage[index].assetName ||
                                listOfStr.contains(listOfImage[index].assetName)
                            ? Positioned.fill(
                                child: Opacity(
                                  opacity: 0.7,
                                  child: Image.asset(
                                    listOfImage[index].assetName,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Positioned.fill(
                                child: Opacity(
                                  opacity: 1.0,
                                  child: Image.asset(
                                    listOfImage[index].assetName,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                        this.images == listOfImage[index].assetName ||
                                listOfStr.contains(listOfImage[index].assetName)
                            ? Positioned(
                                left: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ))
                            : Visibility(
                                visible: false,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.black,
                                ),
                              )
                      ]),
                      onTap: () {
                        setState(() {
                          if (listOfStr
                              .contains(listOfImage[index].assetName)) {
                            this.clicked = false;
                            listOfStr.remove(listOfImage[index].assetName);
                            this.images = null;
                          } else {
                            this.images = listOfImage[index].assetName;
                            listOfStr.add(this.images);
                            this.clicked = true;
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                  child: Text("Save Images"),
                  onPressed: () {
                    setState(() {
                      this.isLoading = true;
                    });
                    listOfStr.forEach((img) async {
                      String imageName = img!
                          .substring(img.lastIndexOf("/"), img.lastIndexOf("."))
                          .replaceAll("/", "");

                      final Directory systemTempDir = Directory.systemTemp;
                      final byteData = await rootBundle.load(img);

                      final file = File('${systemTempDir.path}/$imageName.jpg');
                      await file.writeAsBytes(byteData.buffer.asUint8List(
                          byteData.offsetInBytes, byteData.lengthInBytes));
                      TaskSnapshot snapshot = await storage
                          .ref()
                          .child("images/$imageName")
                          .putFile(file);
                      if (snapshot.state == TaskState.success) {
                        final String downloadUrl =
                            await snapshot.ref.getDownloadURL();
                        // Firestore Upload
                        await FirebaseFirestore.instance
                            .collection("images")
                            .add({
                          "url": downloadUrl,
                          "name": imageName,
                        });
                        setState(() {
                          isLoading = false;
                        });
                        final snackBar =
                            SnackBar(content: Text('Yay! Success'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print(
                            'Error from image repo ${snapshot.state.toString()}');
                        throw ('This file is not an image');
                      }
                    });
                  });
            }),
            ElevatedButton(
              child: Text("Get Images"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadImage()),
                );
              },
            ),
            isLoading
                ? CircularProgressIndicator()
                : Visibility(visible: false, child: Text("test")),
          ],
        ),
      ),
    );
  }

  void getImages() {
    listOfImage = [];
    for (int i = 1; i < 6; i++) {
      print('For - $i');
      listOfImage.add(
        AssetImage('images/EngrP' + i.toString() + '.jpg'),
      );
    }
  }
}

class UploadImage extends StatefulWidget {
  UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  File? _image;
  bool isLoading = false;
  bool isRetrieved = false;
  QuerySnapshot<Map<String, dynamic>>? cachedResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          !isRetrieved
              ? FutureBuilder(
                  future: getImages(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      isRetrieved = true;
                      cachedResult = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              contentPadding: EdgeInsets.all(8.0),
                              title: Text(
                                  snapshot.data!.docs[index].data()["name"]),
                              leading: Image.network(
                                  snapshot.data!.docs[index].data()["url"],
                                  fit: BoxFit.fill),
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Text("No data");
                    }
                    return CircularProgressIndicator();
                  },
                )
              : displayCachedList(),
          ElevatedButton(child: Text("Pick Image"), onPressed: getImage),
          _image == null
              ? Text('No image selected.')
              : Image.file(
                  _image!,
                  height: 300,
                ),
          !isLoading
              ? ElevatedButton(
                  child: Text("Save Image"),
                  onPressed: () async {
                    if (_image != null) {
                      setState(() {
                        this.isLoading = true;
                      });
                      Reference ref = FirebaseStorage.instance.ref();
                      TaskSnapshot addImg =
                          await ref.child("image/img").putFile(_image!);
                      if (addImg.state == TaskState.success) {
                        setState(() {
                          this.isLoading = false;
                        });
                        print("added to Firebase Storage");
                      }
                    }
                  })
              : CircularProgressIndicator(),
        ]),
      ),
    );
  }

  Future getImage() async {
    final _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getImages() {
    return fb.collection("images").get();
  }

  ListView displayCachedList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cachedResult!.docs.length,
        itemBuilder: (BuildContext context, int index) {
          print(cachedResult!.docs[index].data()["url"]);
          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(cachedResult!.docs[index].data()["name"]),
            leading: Image.network(cachedResult!.docs[index].data()["url"],
                fit: BoxFit.fill),
          );
        });
  }
}
