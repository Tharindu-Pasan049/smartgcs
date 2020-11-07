import 'package:flutter/material.dart';
import 'package:smartgcs/scoped_models/secrets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartgcs/models/user.dart';

import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'dart:math' show cos, sqrt, asin;

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class Findpaths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final firestoreInstance = Firestore.instance;

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
bool _disposed = false;
  final Geolocator _geolocator = Geolocator();

  //Position _currentPosition;
LocationData _currentPosition;// a reference to the destination location

bool mapToggle=false;
StreamSubscription _locationSubscription;
  

 Position destinationCoordinates;

  Position startCoordinates;
  String _placeDistance;
Location location;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
BitmapDescriptor sourceIcon;
BitmapDescriptor destinationIcon;
var clients=[];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void setSourceAndDestinationIcons() async {
   sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
         'assets/driving_pin.png');
  
   destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
         'assets/destination_map_marker.png');
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








  // Method for retrieving the current location
  _getCurrentLocation() async {

   _currentPosition = await location.getLocation();
//     await _geolocator
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {

// // mounted to true means that the current page is hanging in the component tree. If false, the current page is not mounted.
if (!mounted) {
  return;
}

    _onPressed(_currentPosition);


      setState(() {
       

        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      
//     }).catchError((e) {
//       print(e);
//     });
populateClients();

  }


  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      

      
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
         startCoordinates = Position(latitude:_currentPosition.latitude,longitude:_currentPosition.longitude);
            
       destinationCoordinates = Position(latitude: 6.737151,longitude: 80.020080);
Position na=Position(latitude: 6.737151,longitude: 80.020080);
Position ma=Position(latitude: 6.724919,longitude: 80.068310);
         Position na1=Position(latitude: 6.724919,longitude: 80.068310);
         Position ma1=Position(latitude: 6.739026,longitude: 80.059245);

         Position na2=Position(latitude: 6.739026,longitude: 80.059245);
         Position ma2=Position(latitude: 6.733826,longitude: 80.041778);

         Position na3=Position(latitude: 6.733826,longitude: 80.041778);
         Position ma3=Position(latitude: 6.751555523061686,longitude: 79.98991012573244);
        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('sourcePin'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
          //  snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
          //  snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);
        
        placeFilteredMarker(ma,'m');///////////////////////////////adding new marker/////////
         placeFilteredMarker(ma1,'mnw');///////////////////////////////adding new marker/////////
         placeFilteredMarker(ma2,'mmt');///////////////////////////////adding new marker/////////
         placeFilteredMarker(ma3,'mmr');///////////////////////////////adding new marker/////////

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }

        // Accomodate the two locations within the
        // camera view of the map
        // mapController.animateCamera(
        //   CameraUpdate.newLatLngBounds(
        //     LatLngBounds(
        //       northeast: LatLng(
        //         _northeastCoordinates.latitude,
        //         _northeastCoordinates.longitude,
        //       ),
        //       southwest: LatLng(
        //         _southwestCoordinates.latitude,
        //         _southwestCoordinates.longitude,
        //       ),
        //     ),
        //     100.0,
        //   ),
        // );
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoom: 18.0,
            ),),
          );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates,'poly');
        await _createPolylines(na,ma,'npoly');
         await _createPolylines(na1,ma1,'npoly1');
         await _createPolylines(na2,ma2,'npoly2');
         await _createPolylines(na3,ma3,'npoly3');


         double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
Dio dio = new Dio();
Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origin_addresses:[40.6905615%2C,-73.9976592]&destination_addresses:[40.6655101,-73.89188969999998]&key=AIzaSyA8GY4o9vAR6URMqU6c4AE1UGLkfDG8iik");
print(response.data);


        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }





        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      
    } catch (e) {
      print(e);
    }
    return false;
  }
placeFilteredMarker(Position s,c){

 
markers.add(Marker(
  markerId: MarkerId(c),
  position: LatLng(s.latitude,s.longitude),
  draggable: false,
  
  
));
 

}



  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination,String name) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key 
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId(name);
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

 @override
  dispose() {
    _disposed = true;
    super.dispose();
  }


  @override
  void initState() {
    if(_locationSubscription!=null){
_locationSubscription.cancel();
}
    super.initState();
   location = new Location();

    _locationSubscription=location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
 

      // so we're holding on to it
      _currentPosition = cLoc;
      print(_currentPosition.latitude);
      print(_currentPosition.longitude);
        if(mapController!=null){
   updatePinOnMap();
   _onPressed( _currentPosition);
   }
   }); 
   setSourceAndDestinationIcons();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child:
      Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
                    

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,top:400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          RaisedButton(
                            onPressed: ( destinationCoordinates != '' &&
                                    startCoordinates != '')
                                ? () async {

if (!mounted) {
  return;
}
 


                                    setState(() {
                                      if (markers.isNotEmpty) markers.clear();
                                      if (polylines.isNotEmpty)
                                        polylines.clear();
                                      if (polylineCoordinates.isNotEmpty)
                                        polylineCoordinates.clear();
                                      _placeDistance = null;
                                    });

                                    _calculateDistance().then((isCalculated) {
                                      if (isCalculated) {
                                        _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Distance Calculated Sucessfully'),
                                          ),
                                        );
                                      } else {
                                        _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Error Calculating Distance'),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                : null,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Route'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(Icons.my_location),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                    ),
                                    zoom: 18.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void updatePinOnMap() async {
   
   // create a new CameraPosition instance
   // every time the location changes, so the camera
   // follows the pin as it moves with an animation  
  CameraPosition cPosition = CameraPosition(
   zoom: CAMERA_ZOOM,
   tilt: CAMERA_TILT,
   bearing: CAMERA_BEARING,
   target: LatLng(_currentPosition.latitude,_currentPosition.longitude),
   );
   
  // final GoogleMapController controller = await _controller.future;
mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));   // do this inside the setState() so Flutter gets notified
   // that a widget update is due
   setState(() {      // updated position
      var pinPosition = LatLng(_currentPosition.latitude,
      _currentPosition.longitude);
      
      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      markers.removeWhere(
      (m) => m.markerId.value == 'sourcePin'); 
           markers.add(new Marker(
         markerId: MarkerId('sourcePin'),
         position: pinPosition, // updated position
         icon: sourceIcon
      ));
   });
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