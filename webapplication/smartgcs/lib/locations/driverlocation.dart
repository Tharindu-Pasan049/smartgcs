import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:smartgcs/userDetails/drivertable.dart';

class LocationDriver extends StatefulWidget {
  LocationDriver(this._userID,{Key key}) : super(key: key);
  final String _userID;
  @override
  _MapDriverState createState() => _MapDriverState();
}

class _MapDriverState extends State<LocationDriver> {
@override
  void initState() {
    super.initState();
    GoogleMap.init('AIzaSyA8GY4o9vAR6URMqU6c4AE1UGLkfDG8iik');
    WidgetsFlutterBinding.ensureInitialized();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(widget._userID),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage(this._userID,{Key key}) : super(key: key);
  final String _userID;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  bool _darkMapStyle = false;
  String _mapStyle;

  List<Widget> _buildClearButtons() => [
        const SizedBox(width: 16),
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.pin_drop),
          label: Text('CLEAR MARKERS'),
          onPressed: () {
            GoogleMap.of(_key).clearMarkers();
          },
        ),
        const SizedBox(width: 16),
        RaisedButton.icon(
          color: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.directions),
          label: Text('CLEAR DIRECTIONS'),
          onPressed: () {
            GoogleMap.of(_key).clearDirections();
          },
        ),
      ];

  // List<Widget> _buildAddButtons() => [
  //       const SizedBox(width: 16),
  //       FloatingActionButton(
  //         child: Icon(Icons.directions),
  //         onPressed: () {
  //           GoogleMap.of(_key).addDirection(
  //             GeoCoord(34.0469058, -118.3503948),
  //             GeoCoord(35.0469058, -119.3503948),
  //             startLabel: '1',
  //             //startInfo: 'San Francisco, CA',
  //             endIcon: 'assets/images/map-marker-warehouse.png',
  //             //endInfo: 'San Jose, CA',
  //           );
  //         },
  //         heroTag: null,
  //       ),
  //     ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.topLeft,
          child: Text("Drivers\'s Location",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),
         leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
              return MyApp1();
            }), (Route route) => false);
          },
          child: Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('drivers')
              .doc(widget._userID)
              .snapshots(),
           
          
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {

             
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
           //   if (snapshot.hasData) {

            if (snapshot.data.data()!=null) {
              
             // GeoPoint position = LatLng(snapshot.data.data()['location']['latitude'],snapshot.data.data()['location']['longitude']);
              double _destLatitude = snapshot.data.data()['location']['latit'];
              double _destLongitude = snapshot.data.data()['location']['longi'];
              String name = snapshot.data.data()['name'];
              String telno = snapshot.data.data()['phone'];
              print("lati: "+_destLatitude.toString());
              print("langi: "+_destLongitude.toString());
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: GoogleMap(
                      key: _key,
                      markers: {
                        Marker(
                          GeoCoord(_destLatitude, _destLongitude),
                          onTap: (coord) =>
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text("Driver:  "+name+"   |   "+"Telno:  "+telno),
                        duration: const Duration(seconds: 5),
                      )),
                         // GeoCoord(33.775513, -117.450257),
                        ),
                      },
                      initialZoom: 8,
                      initialPosition: GeoCoord(
                          6.93162477957, 79.8421960567), // Los Angeles, CA
                      mapType: MapType.roadmap,
                      mapStyle: _mapStyle,
                      interactive: true,
                      
                      mobilePreferences: const MobileMapPreferences(
                        trafficEnabled: true,
                        zoomControlsEnabled: false,
                      ),
                      webPreferences: WebMapPreferences(
                        fullscreenControl: true,
                        zoomControl: true,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: kIsWeb ? 60 : 16,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (_darkMapStyle) {
                          GoogleMap.of(_key).changeMapStyle(null);
                          _mapStyle = null;
                        } else {
                          GoogleMap.of(_key).changeMapStyle(darkMapStyle);
                          _mapStyle = darkMapStyle;
                        }

                        setState(() => _darkMapStyle = !_darkMapStyle);
                      },
                      backgroundColor:
                          _darkMapStyle ? Colors.black : Colors.white,
                      child: Icon(
                        _darkMapStyle ? Icons.wb_sunny : Icons.brightness_3,
                        color: _darkMapStyle ? Colors.white : Colors.black,
                      ),
                      heroTag: null,
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: kIsWeb ? 60 : 16,
                    bottom: 16,
                    child: Row(
                      children: <Widget>[
                        // LayoutBuilder(
                        //   builder: (context, constraints) =>
                        //       constraints.maxWidth < 1000
                        //           ? Row(children: _buildClearButtons())
                        //           : Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: _buildClearButtons(),
                        //             ),
                        // ),
                        Spacer(),
                        // ..._buildAddButtons(),
                      ],
                    ),
                  ),
                ],
              );
           }
            return Container();
          }),
    );
  }
}

const darkMapStyle = r'''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
''';

const contentString = r'''
<div id="content">
  <div id="siteNotice"></div>
  <h1 id="firstHeading" class="firstHeading">Uluru</h1>
  <div id="bodyContent">
    <p>
      <b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large 
      sandstone rock formation in the southern part of the 
      Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) 
      south west of the nearest large town, Alice Springs; 450&#160;km 
      (280&#160;mi) by road. Kata Tjuta and Uluru are the two major 
      features of the Uluru - Kata Tjuta National Park. Uluru is 
      sacred to the Pitjantjatjara and Yankunytjatjara, the 
      Aboriginal people of the area. It has many springs, waterholes, 
      rock caves and ancient paintings. Uluru is listed as a World 
      Heritage Site.
    </p>
    <p>
      Attribution: Uluru, 
      <a href="http://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">
        http://en.wikipedia.org/w/index.php?title=Uluru
      </a>
      (last visited June 22, 2009).
    </p>
  </div>
</div>
''';
