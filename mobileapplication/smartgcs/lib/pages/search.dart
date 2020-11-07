import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:smartgcs/models/user.dart';
import 'package:smartgcs/scoped_models/geolocator_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'package:smartgcs/pages/search.dart';



import 'package:provider/provider.dart';





class SearchPage extends StatefulWidget {
  final Position initialPosition;
  SearchPage(this.initialPosition);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final GeolocatorService geoService=GeolocatorService();
  Completer<GoogleMapController>_controller=Completer();
final firestoreInstance = Firestore.instance;

  @override
void initState(){
  geoService.getCurrentLocation().listen((position){
    _onPressed(position);

centerScreen(position);

  });
  super.initState();
}
  @override
  Widget build(BuildContext context) {
   // _onPressed(initialPosition);

print("ini:: "+widget.initialPosition.latitude.toString());
print("ini:: "+widget.initialPosition.longitude.toString());

    return Scaffold(
     appBar: AppBar(
         title: Text('Map'),
         backgroundColor: Colors.green[500],
         actions: <Widget>[
          
        ],
       
      ),
      // body: Center(
      //   child: Text('Search Vendors - TODO'),
      // ),
//      body: StreamBuilder<Position>(
//        stream: geoService.getCurrentLocation(),
//        builder:(context,snapshot){
//          if(!snapshot.hasData)return Center(child: CircularProgressIndicator(),);
// return Center(child:Text('lat:${snapshot.data.latitude},lng:${snapshot.data.longitude}'),);
//        }
//        ),
      body: Center(child: GoogleMap(
       initialCameraPosition:CameraPosition(target: LatLng(widget.initialPosition.latitude,widget.initialPosition.longitude),zoom: 18.0) ,
     mapType: MapType.satellite,
     myLocationEnabled:true ,
     onMapCreated: (GoogleMapController controller){
       _controller.complete(controller);

     },
     
     
     ),
    )
    );
    
  }

  Future<void>centerScreen(Position position)async{
    print("lati111:: "+position.latitude.toString());
print("langi11:: "+position.longitude.toString());
final GoogleMapController controller=await _controller.future;

controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude),zoom: 18.0)));
  }


  void _onPressed(Position position)async{
    firestoreInstance
        .collection("drivers")
        .document(IDCardClass.userid)
        .updateData({"location" :{
          "latit": position.latitude,
          "longi":position.longitude,        
        }        
        }).then((_) {
      print("success!");
    });
}
}
