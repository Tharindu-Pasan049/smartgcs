import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartgcs/models/user.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetlocationPage extends StatefulWidget {
  
  @override
   _SetlocationPageState createState() => _SetlocationPageState();
 //State<StatefulWidget> createState() {
   // return _SetlocationPageState();
  //}
}

class _SetlocationPageState extends State<SetlocationPage> {

  double p,r;
  List<Marker>myMarker=[];
@override
void initState(){
super.initState();
myMarker.add(Marker(
  markerId:MarkerId('myMarker'),
  draggable: true,
  onTap: (){
    print('Marker Tapped');
  },
  position: LatLng(7.8731,80.7718),
 
   ));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Map'),
         backgroundColor: Colors.green[500],
         actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              BinPosition.x=p;
              BinPosition.y=r;
              // print('x::'+BinPosition.x.toString());
              // print('y::'+BinPosition.y.toString());

              if(BinPosition.x!=null){
              Navigator.of(context).pop();}
              else{
                showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Set the Bin location'),
             // content: Text(data['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                   Navigator.of(context).pop();
                
                  },
                ),
              ],
            );
          });
              }
            },
          )
        ],
       
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
       target: LatLng(7.8731,80.7718),
       zoom: 14.0
      ),
      markers: Set.from(myMarker),
      mapType: MapType.hybrid,
      onTap: _handleTap,
    ));
  }


_handleTap(LatLng tappedPoint){
  print(tappedPoint.toString());
  p=tappedPoint.latitude;
  r=tappedPoint.longitude;
    setState(() {
myMarker=[]; 
myMarker.add(
  Marker(
    markerId:MarkerId(tappedPoint.toString()),
    position: tappedPoint,
    draggable: true,
    onDragEnd: (dragEndPosition){
      print(dragEndPosition.toString());
      p=dragEndPosition.latitude;
      r=dragEndPosition.longitude;
      
    }
  )
);

    });

  }



}


// class _SetlocationPageState extends State<SetlocationPage> {

// List<Marker>allMarkers=[];
// @override
// void initState(){
// super.initState();
// allMarkers.add(Marker(
//   markerId:MarkerId('myMarker'),
//   draggable: true,
//   onTap: (){
//     print('Marker Tapped');
//   },
//   position: LatLng(7.8731,80.7718),
//    ));
// }

//   @override
//    Widget build(BuildContext context) {
// return Scaffold(
//       appBar: AppBar(
//         title: Text('Map'),
//         backgroundColor: Colors.green[500],
       
//       ),
//       body: Center(
//         child: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: GoogleMap(
//          initialCameraPosition: CameraPosition(
//         target: LatLng(7.8731,80.7718),
//         zoom: 12.0
//          ),
//         markers: Set.from(allMarkers),
//         ),
        
//         ),
//         ),
       
//    );

//    }

// }
