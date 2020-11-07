import 'package:smartgcs/background/background.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TrainTimeTable extends StatefulWidget {
  @override
  _TrainTimeTableState createState() => _TrainTimeTableState();
}

class _TrainTimeTableState extends State<TrainTimeTable> {
  dynamic firebaseData;
  DateTime birthDate;
  String _userName;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryColor),
    );
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:Colors.purpleAccent,
        title: Container(
          alignment: Alignment.center,
          child: Text("User's Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.data.docs != null) {
                    return ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentData) {
                        print(documentData.id);
                        return ListTile(
                          title: Text(
                            documentData.id,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onTap: () {
                            getData(documentData.id);
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                firebaseData != null
                    ? Text(
                        "NAME                      :  ${firebaseData['Name']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "EMAIL ADDRESS      :  ${firebaseData['Email Address']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "BIRTH DAY                 :  $birthDate",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "NIC NUMBER                :  ${firebaseData['NIC Number']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "BLOOD TYPE                :  ${firebaseData['Blood Type']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "PHONE NUMBER       :  ${firebaseData['Phone Number']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "GENDER                    : ${firebaseData['Gender']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        '',
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? RaisedButton(
                        onPressed: () => {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //   return Feed(_userName);
                          // })),
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text('Patient\'s Medical Reports',
                              style: TextStyle(fontSize: 20)),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> getData(String idNumber) async {
    _userName = idNumber;
    final DocumentReference document =
        FirebaseFirestore.instance.collection("Users").doc(idNumber);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        firebaseData = snapshot.data();
        print(firebaseData);
        Timestamp birthDayTimeStamp = firebaseData['Birth Day'];
        birthDate = birthDayTimeStamp.toDate();
      });
    });
  }
}
