import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:smartgcs/models/user.dart';
import 'package:smartgcs/scoped_models/geolocator_service.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
bool mapToggle=false;
var currentLocation;
var clients=[];
var fiterdist;
GoogleMapController mapController;
Set<Marker> marker = {};


void initState(){
super.initState();
Geolocator().getCurrentPosition().then((currloc){
setState(() {
  currentLocation=currloc;
  print(currentLocation.latitude);
  print(currentLocation.longitude);

  mapToggle=true;
  populateClients();
});

});

}
  
populateClients(){
clients=[];
Firestore.instance.collection('GarbageBin').getDocuments().then((docs)
{
if(docs.documents.isNotEmpty){
for(int i=0;i<docs.documents.length;++i){
clients.add(docs.documents[i].data);
String c= i.toString();
//initMarker(docs.documents[i].data,c);

}
  
}
});
}




 initMarker(clients,String i){
   
   
   this.setState((){
marker.add(Marker(
  markerId: MarkerId(i),
  position: LatLng(clients['location']['latit'],clients['location']['longi']),
  draggable: false,
  
  
));
   });
   

 }  

filterMarkers(dist){
marker.clear();

  for(int i=0;i<clients.length;i++){
Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, clients[i]['location']['latit'], clients[i]['location']['longi']).then((calDist){
if(calDist/1000<double.parse(dist)){
  String c=i.toString();
  placeFilteredMarker(clients[i],calDist/1000,c);
}
});
  }
}

placeFilteredMarker(client,distance,c){

 //this.setState((){
marker.add(Marker(
  markerId: MarkerId(c),
  position: LatLng(client['location']['latit'],client['location']['longi']),
  draggable: false,
  
  
));
 //  });

}

  @override
  Widget build(BuildContext context) {


    return Scaffold(
     appBar: AppBar(
         title: Text('Map'),
         backgroundColor: Colors.green[500],
         actions: <Widget>[
          IconButton(icon: Icon(Icons.filter_list),
           onPressed: getDist
          )

        ],
       
      ),
     body:Column(
       children: <Widget>[
Stack(
children: <Widget>[

  Container(
height:MediaQuery.of(context).size.height-80.0,
width: double.infinity,
child: mapToggle?
GoogleMap(
onMapCreated: onMapCreated,
 initialCameraPosition:CameraPosition(
   target: LatLng(currentLocation.latitude,currentLocation.longitude),
   zoom: 10.0) ,
     mapType: MapType.satellite,
     myLocationEnabled:true ,
    markers: marker,

):
Center(child: 
Text("Loading..Please wait",style: TextStyle(
fontSize: 20.0

),)
)
  )
]

,)

       ],
     ) ,
     
    );
    
  }
void onMapCreated(controller){
  setState(() {
    mapController=controller;
    
  });
}
  Future<bool>getDist(){
    return showDialog(context: context,
    barrierDismissible: true,
    builder: (context){
      return AlertDialog(
title: Text('Enter distance'),
contentPadding: EdgeInsets.all(10.0),
content: TextField(decoration: InputDecoration(hintText: 'enter distance'),
onChanged: (val){
setState(() {
  fiterdist=val;
});

},


),
actions: <Widget>[
  FlatButton(child: Text('ok'),
  color: Colors.transparent,
  textColor: Colors.blue,
  onPressed: (){

    filterMarkers(fiterdist);
    Navigator.of(context).pop();
  },
  )
],
      );
    }
    );
  }


}
