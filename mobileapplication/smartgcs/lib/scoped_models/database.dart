//import 'package:auto_mate_app1/models/classified.dart';
import 'package:smartgcs/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DatabaseServices{

  final String uid;
  DatabaseServices({this.uid});
final firestoreInstance = Firestore.instance;
String no=IDCardClass.userid;

  // collection refernces
  final CollectionReference smartgcsusers= Firestore.instance.collection("users");
  final CollectionReference smartgcsdrivers=Firestore.instance.collection("drivers");

  Future updateUserData({Client client, Vendor vendor})async{
    if(vendor==null){
     return await smartgcsusers.document(uid).setData({
      'name': client.name,
      'phone': client.phone,
      'email':client.email,
      'username': client.username,
      'address':client.address,
      'dateCreated':client.dateCreated,
    });
    }
    else{
      return await smartgcsdrivers.document(uid).setData({
      'name': vendor.name,
      'phone': vendor.phone,
      'email':vendor.email,
      'username': vendor.username,
      'address':vendor.address,
      'dateCreated':vendor.dateCreated,
    });
    }
    
  }

  //add classifieds
  // Future addClassifieds(String vehicleType,String usageDistance,String description) async{
  //   return await smartgcsdrivers.document(uid).setData({
  //     'vehicle type': vehicleType,
  //     'usage distance':usageDistance,
  //     'description': description,
  //   });
  // }


 
// void getData() {
//     firestoreInstance
//         .collection("users")
//         .getDocuments()
//         .then((QuerySnapshot snapshot) {
//       snapshot.documents.forEach((f) => print('${f.data}}'));
//     });
//   }



  //user data list from snapshots
  List<Client> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Client(
      name:  doc.data['name'] ?? '',
      phone: doc.data['phone'] ?? '',
      email:doc.data['email'] ?? '',
      username: doc.data['username'] ?? '',
      address:doc.data['address'] ?? '',
      dateCreated:doc.data['dateCreated'] ?? '',
        
        
      );
    }).toList();
  }

  //userdata from snapshot
  Client _userDataFromSnapshot(DocumentSnapshot snapshot){
    return Client(
      id: uid,
      name:snapshot.data['name'],
      phone: snapshot.data['phone'],
      email:snapshot.data['email'],
      username: snapshot.data['username'],
      address:snapshot.data['address'],
      dateCreated:snapshot.data['dateCreated'],
     
    );
  }

  //classified data from snapshots
  // ClassifiedData _classifiedDataFromSnapshots(DocumentSnapshot snapshot){
  //   return ClassifiedData(
  //     uid: uid,
  //     vehicleType: snapshot.data['vehicle type'],
  //     usageDistance: snapshot.data['usage distance'],
  //     description: snapshot.data['description']
  //   );
  // }

  //get users stream

  Stream<List<Client>>get users{
    return smartgcsusers.snapshots().map(_userListFromSnapshot);
  }

  //get user doc stream
  Stream<Client>get userDataModel{
    return smartgcsusers.document(uid).snapshots().map(_userDataFromSnapshot);
  }

 

  //get classified doc stream
  // Stream<ClassifiedData>get classifiedDataModel{
  //   return smartgcsdrivers.document(uid).snapshots().map(_classifiedDataFromSnapshots);
  // }

}