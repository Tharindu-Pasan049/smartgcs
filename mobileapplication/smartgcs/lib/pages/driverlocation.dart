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

class DriverLocation extends StatelessWidget{
@override 
Widget build(BuildContext context){
  return MaterialApp(
debugShowCheckedModeBanner: false,
title: "Map",
theme: ThemeData(
  primarySwatch: Colors.green,
),
home: DriverLocationPage(title:'Map'),
  );
}
}
class DriverLocationPage extends StatefulWidget{

DriverLocationPage({Key key,this.title}):super(key: key);
final String title;
@override
_DriverLocationPageState createState()=> _DriverLocationPageState();

}
class _DriverLocationPageState extends State<DriverLocationPage>{
final firestoreInstance = Firestore.instance;
StreamSubscription _locationSubscription;
Location _locationTracker=Location();
//Marker marker;
Set<Marker> marker = {};
Circle circle;
GoogleMapController _controller;

static final CameraPosition initialLocation=CameraPosition(
  target:LatLng(7.8731,80.7718),
  zoom: 14.4746,
   );


 Future<Uint8List>getMarker()async{
     ByteData byteData=await DefaultAssetBundle.of(context).load("assets/car_icon.jpg");
     return byteData.buffer.asUint8List();
   }



void updateMarkerAndCircle(LocationData newLocalData,Uint8List imageData){
   LatLng latLng=LatLng(newLocalData.latitude,newLocalData.longitude);
   print("latit::"+newLocalData.latitude.toString());
   print("longi::"+newLocalData.longitude.toString());
   this.setState((){
marker.add(Marker(
  markerId: MarkerId("home"),
  position: latLng,
  rotation: newLocalData.heading,
  draggable: false,
  zIndex: 2,
  flat: true,
  anchor: Offset(0.5,0.5),
  icon: BitmapDescriptor.fromBytes(imageData)));
  circle=Circle(
    circleId:CircleId("car"),
    radius: newLocalData.accuracy,
    zIndex: 1,
    strokeColor: Colors.blue,
    center: latLng,
    fillColor: Colors.blue.withAlpha(70) 
  );
// marker.add(Marker(
//          markerId: MarkerId("destPin"),
//   draggable: false,
//          position: LatLng(7.8731,80.7718),
//         // icon: destinationIcon
//       ));
   });

 }  

void getCurrentLocation()async{

  try{
    Uint8List imageData = await getMarker();
    var location = await _locationTracker.getLocation();
    _onPressed(location);
   // updateMarkerAndCircle(location,imageData);
    if(_locationSubscription!=null){
      _locationSubscription.cancel();    
    }
    _locationSubscription= _locationTracker.onLocationChanged.listen((newLocalData){
   if(_controller!=null){
   _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(newLocalData.latitude,newLocalData.longitude),
   tilt: 0,
    zoom: 18.00
    )));
    _onPressed(newLocalData);
   // updateMarkerAndCircle(newLocalData,imageData);
   }

    });
  }on PlatformException catch(e){
    if(e.code=='PERMISSION_DENIED'){
      debugPrint("Permission Denied");
    }
  }
}
@override
void dispose(){
if(_locationSubscription!=null){
_locationSubscription.cancel();
}
super.dispose();
}

@override
Widget build(BuildContext context){
  
return Scaffold(
  
  appBar: AppBar(
    
    title: Text(widget.title),
  ),
  body: GoogleMap(
    
    mapType: MapType.satellite,
    initialCameraPosition: initialLocation,
    myLocationEnabled:true ,
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

              onPressed:(){ getCurrentLocation();
              }  ),           
          ],
        ),
),
  );
}
void _onPressed(LocationData newdata)async{
    firestoreInstance
        .collection("drivers")
        .document(IDCardClass.userid)
        .updateData({"location" :{
          "latit": newdata.latitude,
          "longi":newdata.longitude,        
        }        
        }).then((_) {
      print("success!");
    });
}

}



