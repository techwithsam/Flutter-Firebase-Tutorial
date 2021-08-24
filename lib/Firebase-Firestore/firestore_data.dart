import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirestoreData extends StatefulWidget {
  FirestoreData({Key key}) : super(key: key);

  @override
  _FirestoreDataState createState() => _FirestoreDataState();
}

class _FirestoreDataState extends State<FirestoreData> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference notification =
        FirebaseFirestore.instance.collection('data');
    final Stream<QuerySnapshot> _dataStream =
        FirebaseFirestore.instance.collection('data').snapshots();
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications',
            ),
        ),
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
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                        margin: EdgeInsets.only(
                            bottom: 6, left: 8, right: 8, top: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey[500].withOpacity(1.0),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => func(data['imgUrl']),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data['title']}',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.btnColor),
                                        ),
                                        Text(
                                          '${data['body']}',
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
                                          image: NetworkImage(data['imgUrl']),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(height: 3),
                            MaterialButton(
                              onPressed: () async {
                                int addCall = data['clicked'] + 1;
                                await notification
                                    .doc(document.id)
                                    .update({'clicked': addCall})
                                    .then((value) =>
                                        print("Action Called and added"))
                                    .catchError((error) =>
                                        print("Failed to add value: $error"));
                                callBackAction(data['btnAction']);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 40),
                              child: Text(data['btnName'],
                                  style: TextStyle(color: Colors.white)),
                              color: AppColor.btnColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }));
  }

  func(String img) {
    showDialog(context: context, builder: (_) => DownloadDialog(img: img));
  }

  callBackAction(values) {
    if (values == 'airtime') {
      Navigator.of(context).push(PageTransition(
        child: BuyAirtime(myAppSettings: widget.myAppSettings),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 600),
      ));
    } else if (values == 'data') {
      Navigator.of(context).push(PageTransition(
        child: BuyData(myAppSettings: widget.myAppSettings),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 800),
      ));
    } else if (values == 'wallet') {
      Navigator.of(context).push(PageTransition(
        child: FundWallet(
          myAppSettings: widget.myAppSettings,
        ),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 800),
      ));
    } else if (values == 'app') {
      Platform.isIOS ? launch(urls.appleStore) : launch(urls.playStore);
    } else if (values == 'cabletv') {
      Navigator.of(context).push(PageTransition(
        child: BuyCableTv(myAppSettings: widget.myAppSettings),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 800),
      ));
    } else if (values == 'electricity') {
      Navigator.of(context).push(PageTransition(
        child: PayElectricityBills(myAppSettings: widget.myAppSettings),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 800),
      ));
    } else if (values == 'sendmoney') {
      Navigator.of(context).push(PageTransition(
        child: SendMoney(myAppSettings: widget.myAppSettings),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 800),
      ));
    } else if (values == 'crowdfund') {
      Navigator.of(context).push(PageTransition(
        child: CrowndFundPage(myAppSettings: widget.myAppSettings),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 800),
      ));
    } else if (values == 'verification') {
      Navigator.of(context).push(
        PageTransition(
          duration: Duration(milliseconds: 800),
          type: PageTransitionType.fade,
          child: VerificationPage(myAppSettings: widget.myAppSettings),
        ),
      );
    } else if (values == 'investment') {
      Navigator.of(context).push(
        PageTransition(
            duration: Duration(milliseconds: 800),
            type: PageTransitionType.fade,
            child: AdvancedWebview(
              title: 'Investment',
              urli: '${urls.investment}?sesscode=$sesscode&userid=$uid&app=app',
            )),
      );
    } else {
      launch(values);
    }
  }

  @override
  void initState() {
    super.initState();
    userInfo();
    headlines = callApi.headlinesApi();
    requestpermission();
  }

  requestpermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  Future<void> userInfo() async {
    var prefs = await StreamingSharedPreferences.instance;
    var details = MyAppSettings(prefs);
    setState(() {
      sesscode = details.dsesscode.getValue();
      uid = details.duserid.getValue();
    });

