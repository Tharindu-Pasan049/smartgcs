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
import 'package:smartgcs/scoped_models/geolocator_service.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class Loc extends StatelessWidget{
@override 
Widget build(BuildContext context){
  return MaterialApp(
debugShowCheckedModeBanner: false,
title: "Map",
theme: ThemeData(
  primarySwatch: Colors.green,
),
home: LocPage(title:'Map'),
  );
}
}
class LocPage extends StatefulWidget{

LocPage({Key key,this.title}):super(key: key);
final String title;
@override
_LocPageState createState()=> _LocPageState();

}
class _LocPageState extends State<LocPage>{
final firestoreInstance = Firestore.instance;
StreamSubscription _locationSubscription;
Location _locationTracker=Location();
//Marker marker;
Set<Marker> marker = {};
Circle circle;
GoogleMapController _controller;
String fiterdist;
var currentLocation;
bool mapToggle=false;




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
    circleId:CircleId("truck"),
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
    
    updateMarkerAndCircle(location,imageData);
    if(_locationSubscription!=null){
      _locationSubscription.cancel();    
    }
    _locationSubscription= _locationTracker.onLocationChanged.listen((newLocalData){
   if(_controller!=null){
  //  _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //   bearing: 192.8334901395799,
  //   target: LatLng(newLocalData.latitude,newLocalData.longitude),
  //  tilt: 0,
  //   zoom: 18.00
  //   )));
    
    updateMarkerAndCircle(newLocalData,imageData);
   }

    });
  }on PlatformException catch(e){
    if(e.code=='PERMISSION_DENIED'){
      debugPrint("Permission Denied");
    }
  }
}
//@override
// void dispose(){
// if(_locationSubscription!=null){
// _locationSubscription.cancel();
// }
// super.dispose();
// }

void initState(){
super.initState();
Geolocator().getCurrentPosition().then((currloc){
setState(() {
  currentLocation=currloc;
  mapToggle=true;
  fiterdist='30.0';
  
});

});

}
  

Widget loadMap(){
//print("filll:::"+dist.toString());

  return StreamBuilder(
    stream: Firestore.instance.collection('drivers').snapshots(),
    
    builder: (context,snapshot){


      if(!snapshot.hasData){
        return Text("Loading maps.. Please wait");
      }

      for(int i=0;i<snapshot.data.documents.length;i++){

Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, snapshot.data.documents[i]['location']['latit'], snapshot.data.documents[i]['location']['longi']).then((calDist){
        if(calDist/1000<50){
  String c=i.toString();
setState(() {
  marker.clear();

marker.add(new Marker(
   markerId: MarkerId(c),
  position: LatLng(snapshot.data.documents[i]['location']['latit'],snapshot.data.documents[i]['location']['longi']),
  draggable: false,
   )
);
});

        }
      });
}

return new GoogleMap(
    
    mapType: MapType.hybrid,
    initialCameraPosition:
    
     CameraPosition(
   target: LatLng(currentLocation.latitude,currentLocation.longitude),
    zoom: 10.0) ,
    myLocationEnabled:true ,
    markers: Set.of((marker!=null)?marker:[]),
    circles: Set.of((circle!=null)?[circle]:[]),
    onMapCreated: (GoogleMapController controller){
      _controller=controller;
    },

    );
   
      
    }
  );
}

@override
Widget build(BuildContext context){
  
return Scaffold(
  
  appBar: AppBar(
    
    title: Text(widget.title),
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
  loadMap():

Center(child: 
Text("Loading..!",style: TextStyle(
fontSize: 20.0

),)
)
  )
]

,)

       ],
     ) ,

















      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 190.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.location_searching),

              onPressed:(){ 
               // marker.clear();

    //loadMap(fiterdist);
               getCurrentLocation();
              }  ),           
          ],
        ),
),
  );
}


Future<bool>getDist(){
    return showDialog(context: context,
    barrierDismissible: true,
    builder: (context){
      return AlertDialog(
title: Text('Enter distance'),
contentPadding: EdgeInsets.all(10.0),
content: TextField(decoration: InputDecoration(hintText: 'Enter distance'),
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
//marker.clear();

//  loadMap(fiterdist);
    Navigator.of(context).pop();
  },
  )
],
      );
    }
    );
  }


}



