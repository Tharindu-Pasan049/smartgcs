import 'package:smartgcs/background/background.dart';
import 'package:smartgcs/locations/driverlocation.dart';

import 'package:smartgcs/background/background.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UserFeedbacks extends StatefulWidget {
  @override
  _FeedInformationState createState() => _FeedInformationState();
}

class _FeedInformationState extends State<UserFeedbacks> {
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
          child: Text("Feedbacks Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),





      ),
      body: Row(
        
        children: <Widget>[
          
          Expanded(
            flex: 6,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('feedbacks')
                    .snapshots(),
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
                             documentData.data()['customer_opinion']
                             +"  "+
                             documentData.data()['comment']+"   "+documentData.data()['Date_of_comment'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          onTap: () {



                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //  // return LocationDriver(documentData.id);
                          //    return MapViewMainRequest(documentData.id);
                            
                          // })),
                       

                            
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
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                firebaseData != null
                    ? Text(
                        "NAME                      :  ${firebaseData['name']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "ADDRESS      :  ${firebaseData['address']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    : Text(
                        '',
                      ),

 firebaseData != null
                    ? Text(
                        "Email      :  ${firebaseData['email']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    : Text(
                        '',
                      ),
                       firebaseData != null
                    ? Text(
                        "PhoneNo      :  ${firebaseData['phone']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    : Text(
                        '',
                      ),



                // SizedBox(height: 10),
                // firebaseData != null
                //     ? Text(
                //         "BIRTH DAY                 :  $birthDate",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 20),
                //       )
                //     : Text(
                //         '',
                //       ),
                // SizedBox(height: 10),
                // firebaseData != null
                //     ? Text(
                //         "NIC NUMBER                :  ${firebaseData['NIC Number']}",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 20),
                //       )
                //     : Text(
                //         '',
                //       ),
                // SizedBox(height: 10),
                // firebaseData != null
                //     ? Text(
                //         "BLOOD TYPE                :  ${firebaseData['Blood Type']}",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 20),
                //       )
                //     : Text(
                //         '',
                //       ),
                // SizedBox(height: 10),
                // firebaseData != null
                //     ? Text(
                //         "PHONE NUMBER       :  ${firebaseData['Phone Number']}",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 20),
                //       )
                //     : Text(
                //         '',
                //       ),
                // SizedBox(height: 10),
                // firebaseData != null
                //     ? Text(
                //         "GENDER                    : ${firebaseData['Gender']}",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 20),
                //       )
                //     : Text(
                //         '',
                //       ),
                // SizedBox(height: 10),
                // firebaseData != null
                //     ? Text(
                //         '',
                //       )
                //     : Text(
                //         '',
                //       ),
                SizedBox(height: 10),
                // firebaseData != null
                //     ? RaisedButton(
                //         onPressed: () => {
                //           // Navigator.of(context).push(MaterialPageRoute(
                //           //     builder: (BuildContext context) {
                //           //   return Feed(_userName);
                //           // })),
                //         },
                //         textColor: Colors.white,
                //         padding: const EdgeInsets.all(0.0),
                //         child: Container(
                //           decoration: const BoxDecoration(
                //             gradient: LinearGradient(
                //               colors: <Color>[
                //                 Color(0xFF0D47A1),
                //                 Color(0xFF1976D2),
                //                 Color(0xFF42A5F5),
                //               ],
                //             ),
                //           ),
                //           padding: const EdgeInsets.all(10.0),
                //           child: const Text('Driver\'s Location',
                //               style: TextStyle(fontSize: 20)),
                //         ),
                //       )
                //     : Text(''),
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
        FirebaseFirestore.instance.collection("users").doc(idNumber);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        firebaseData = snapshot.data();
        
      });
    });
  }
}
