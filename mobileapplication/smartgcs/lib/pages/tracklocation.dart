import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';


const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(6.7225523,80.0127685);
const LatLng DEST_LOCATION = LatLng(6.585395,79.960739);

class MapPage extends StatefulWidget {

   @override
   State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  
 GoogleMapController _controller;
Set<Marker> _markers = Set<Marker>();// for my drawn routes on the map
Set<Polyline> _polylines = Set<Polyline>();
List<LatLng> polylineCoordinates = [];
PolylinePoints polylinePoints;

String googleAPIKey = "AIzaSyA8GY4o9vAR6URMqU6c4AE1UGLkfDG8iik";// for my custom marker pins
BitmapDescriptor sourceIcon;
BitmapDescriptor destinationIcon;// the user's initial location and current location
// as it moves
LocationData currentLocation;// a reference to the destination location
LocationData destinationLocation;// wrapper around the location API
Location location;
StreamSubscription _locationSubscription;



@override
void initState() {
  if(_locationSubscription!=null){
_locationSubscription.cancel();
}
   super.initState();
     
   // create an instance of Location
   location = new Location();
   polylinePoints = PolylinePoints();
   
   // subscribe to changes in the user's location
   // by "listening" to the location's onLocationChanged event

   _locationSubscription=location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      print(currentLocation.latitude);
      print(currentLocation.longitude);
        if(_controller!=null){
   updatePinOnMap();}
   });   // set custom marker pins
   setSourceAndDestinationIcons();   // set the initial location
   setInitialLocation();

}

void setSourceAndDestinationIcons() async {
   sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
         'assets/driving_pin.png');
  
   destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
         'assets/destination_map_marker.png');
}

void setInitialLocation() async {   // set the initial location by pulling the user's 
   // current location from the location's getLocation()
   currentLocation = await location.getLocation();
   
   // hard-coded destination for this example
   destinationLocation = LocationData.fromMap({
      "latit": DEST_LOCATION.latitude,
      "longi": DEST_LOCATION.longitude
   });
      showPinsOnMap();

}


@override
Widget build(BuildContext context) {   
  CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION
   );
   if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
         target: LatLng(currentLocation.latitude,
            currentLocation.longitude),
         zoom: CAMERA_ZOOM,
         tilt: CAMERA_TILT,
         bearing: CAMERA_BEARING
      );
   }return Scaffold(
      body: Stack(
      children: <Widget>[
         GoogleMap(
         myLocationEnabled: true,
         compassEnabled: true,
         tiltGesturesEnabled: false,
         markers: _markers,
         polylines: _polylines,
         mapType: MapType.normal,
         initialCameraPosition: initialCameraPosition,
         onMapCreated: (GoogleMapController controller) {
            _controller=controller;            // my map has completed being created;
            // i'm ready to show the pins on the map
           
         })
      ],
      
    ),
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

void showPinsOnMap() {   // get a LatLng for the source location
   // from the LocationData currentLocation object
   var pinPosition = LatLng(currentLocation.latitude,
   currentLocation.longitude);   // get a LatLng out of the LocationData object
   var destPosition = LatLng(destinationLocation.latitude,
   destinationLocation.longitude);
    setState(() {
   _markers.clear();
      // add the initial source location pin
   _markers.add(new Marker(
      markerId: MarkerId('sourcePin'),
      position: pinPosition,
      icon: sourceIcon
   ));   // destination pin
   _markers.add(new Marker(
      markerId: MarkerId('destPin'),
      position: destPosition,
      icon: destinationIcon
   )); 
      });  // set the route lines on the map from source to destination
   // for more info follow this tutorial
   _setPolylines();
}


 void _setPolylines() async {   
   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
   googleAPIKey,
   PointLatLng(currentLocation.latitude,  currentLocation.longitude),
      PointLatLng( destinationLocation.latitude,  destinationLocation.longitude),
      travelMode: TravelMode.driving,
  );  
  
   if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
         polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
         );
      });     setState(() {
      _polylines.add(Polyline(
        width: 5, // set the width of the polylines
        polylineId: PolylineId('poly'),
        color: Color.fromARGB(255, 40, 122, 198), 
        points: polylineCoordinates
        ));
    });
  }
}


void updatePinOnMap() async {
   
   // create a new CameraPosition instance
   // every time the location changes, so the camera
   // follows the pin as it moves with an animation  
  CameraPosition cPosition = CameraPosition(
   zoom: CAMERA_ZOOM,
   tilt: CAMERA_TILT,
   bearing: CAMERA_BEARING,
   target: LatLng(currentLocation.latitude,currentLocation.longitude),
   );
   
  // final GoogleMapController controller = await _controller.future;
_controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));   // do this inside the setState() so Flutter gets notified
   // that a widget update is due
   setState(() {      // updated position
      var pinPosition = LatLng(currentLocation.latitude,
      currentLocation.longitude);
      
      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
      (m) => m.markerId.value == 'sourcePin'); 
           _markers.add(new Marker(
         markerId: MarkerId('sourcePin'),
         position: pinPosition, // updated position
         icon: sourceIcon
      ));
   });
}







}
