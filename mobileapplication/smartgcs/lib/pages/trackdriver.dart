import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:smartgcs/scoped_models/geolocator_service.dart';
import 'package:smartgcs/pages/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgcs/models/user.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class Trackdriver extends StatelessWidget{
@override 
Widget build(BuildContext context){
  return MaterialApp(
debugShowCheckedModeBanner: false,
title: "Map",
theme: ThemeData(
  primarySwatch: Colors.green,
),
home: TrackdriverPage(title:'Map'),
  );
}
}
class TrackdriverPage extends StatefulWidget{

TrackdriverPage({Key key,this.title}):super(key: key);
final String title;
@override
_TrackdriverPageState createState()=> _TrackdriverPageState();

}
class _TrackdriverPageState extends State<TrackdriverPage>{
final firestoreInstance = Firestore.instance;
StreamSubscription _locationSubscription;
Location _locationTracker=Location();
//Marker marker;
Set<Marker> marker = {};
Circle circle;
GoogleMapController _controller;
LatLng la;
BitmapDescriptor sourceIcon;
BitmapDescriptor destinationIcon;
static final CameraPosition initialLocation=CameraPosition(
  target:LatLng(7.8731,80.7718),
  zoom: 14.4746,
   );


 Future<Uint8List>getMarker()async{
     ByteData byteData=await DefaultAssetBundle.of(context).load("assets/car_icon.jpg");
     return byteData.buffer.asUint8List();
   }



void updateMarkerAndCircle(){
  // LatLng latLng=LatLng(newLocalData.latitude,newLocalData.longitude);
   
   this.setState((){
marker.add(Marker(
  markerId: MarkerId("home"),
  position: la,
 // rotation: newLocalData.heading,
  draggable: false,
 // zIndex: 2,
  //flat: true,
 // anchor: Offset(0.5,0.5),
 // icon: BitmapDescriptor.fromBytes(imageData)));
 icon:sourceIcon));
  // circle=Circle(
  //   circleId:CircleId("car"),
  //   radius: newLocalData.accuracy,
  //   zIndex: 1,
  //   strokeColor: Colors.blue,
  //   center: la,
  //   fillColor: Colors.blue.withAlpha(70) 
  // );
// marker.add(Marker(
//          markerId: MarkerId("destPin"),
//   draggable: false,
//          position: LatLng(7.8731,80.7718),
//         // icon: destinationIcon
//       ));
   });

 }  

@override
void initState() {
   super.initState();
   setSourceAndDestinationIcons();
}

void setSourceAndDestinationIcons() async {
   sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/driving_pin.png');   
      
}

@override
Widget build(BuildContext context){
 _onPressed();                
 

return Scaffold(
  
  appBar: AppBar(
    
    title: Text(widget.title),
  ),
  body: GoogleMap(
    
    mapType: MapType.normal,
    initialCameraPosition: initialLocation,
    myLocationEnabled:true,
    markers: Set.of((marker!=null)?marker:[]),
    circles: Set.of((circle!=null)?[circle]:[]),
    onMapCreated: (GoogleMapController controller){
      _controller=controller;
    },
    ),
    
    // floatingActionButton: FloatingActionButton(
    //   elevation: 0.0,
    //   child: Icon(Icons.location_searching),

    //   onPressed:(){
    //     getCurrentLocation();
    //   }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 190.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.location_searching),

              onPressed:(){ 

              }  ),           
          ],
        ),
),
  );
}

// void _onPressed() {
//   firestoreInstance.collection("drivers").getDocuments().then((querySnapshot) {
//     querySnapshot.documents.forEach((result) {  
//      la=LatLng(result.data["location"]["latitude"],result.data["location"]["longitude"]); 

//       print(result.data["location"]["longitude"]);
//     });
//   });

// }
Future  _onPressed() {
  firestoreInstance
      .collection("drivers")
    
      .snapshots()
      .listen((result) {
    result.documents.forEach((result) {
     la=LatLng(result.data["location"]["latit"],result.data["location"]["longi"]); 
      print(result.data["location"]["longi"]);

    
    });
  }); 
   updateMarkerAndCircle();

}

//  void _onPressed() async{
//     firestoreInstance.collection("drivers").document("Q0wCXN767JSNpqgxrHmxNjSjZ9V2").get().then((value){
//   //  la=LatLng(value.data["location"]["latitude"],value.data["location"]["longitude"]); 
//       print(value.data["location"]["latitude"]);
//        print(value.data["location"]["longitude"]);
//     });
//   }


}
