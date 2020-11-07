import 'package:smartgcs/background/background.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:smartgcs/userDetails/usertable.dart';


class GarbageBin extends StatefulWidget {
  @override
  _TrainTimeTableState createState() => _TrainTimeTableState();
}

class _TrainTimeTableState extends State<GarbageBin> {
   @override
  void initState() {
    super.initState();
    GoogleMap.init('AIzaSyBZ3CUFE9PFXcMLe0VvJeOgfvILx6JMEkA');
    WidgetsFlutterBinding.ensureInitialized();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  bool _darkMapStyle = false;
  String _mapStyle;
bool mapToggle=true;
  dynamic firebaseData;
  dynamic firebaseData1;
  DateTime birthDate;
String gid;

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

 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryColor),
    );
    return Scaffold(
    key: _scaffoldKey,

      appBar: AppBar(
        // backgroundColor:Colors.purpleAccent,
        title: Container(
          alignment: Alignment.topLeft,
          child: Text("All GarbageBin Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              )),
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('GarbageBin').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.data.docs != null) {
                    return ListView(
                      children: snapshot.data.docs
                          .map((DocumentSnapshot documentData) {
                          //  if(documentData.id!=null){};
                        print(documentData.id);
                        return ListTile(
                          title: Text(
                            documentData.id,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          onTap: () {
                            getData(documentData.id);
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                firebaseData != null
                    ? Text(
                        "Name            :  ${firebaseData['name']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "Address         :  ${firebaseData['address']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "Email           :  ${firebaseData['email']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData != null
                    ? Text(
                        "PhoneNo         :  ${firebaseData['phone']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData1 != null
                    ? Text(
                        "Waste_Type      :  ${firebaseData1['waste_type']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        '',
                      ),
                SizedBox(height: 10),
                firebaseData1 != null
                    ? Text(
                        "No_of_bins      :  ${firebaseData1['number_of_bins']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    : Text(
                        '',
                      ),
                
          //       SizedBox(height: 10),
          //       // firebaseData != null
          //       //     ? RaisedButton(
          //       //         onPressed: () => {
          //       //           // Navigator.of(context).push(MaterialPageRoute(
          //       //           //     builder: (BuildContext context) {
          //       //           //   return Feed(_userName);
          //       //           // })),
          //       //         },
          //       //         textColor: Colors.white,
          //       //         padding: const EdgeInsets.all(0.0),
          //       //         child: Container(
          //       //           decoration: const BoxDecoration(
          //       //             gradient: LinearGradient(
          //       //               colors: <Color>[
          //       //                 Color(0xFF0D47A1),
          //       //                 Color(0xFF1976D2),
          //       //                 Color(0xFF42A5F5),
          //       //               ],
          //       //             ),
          //       //           ),
          //       //           padding: const EdgeInsets.all(10.0),
          //       //           child: const Text('Patient\'s Medical Reports',
          //       //               style: TextStyle(fontSize: 20)),
          //       //         ),
          //       //       )
          //       //     : Text(''),
              ],
             ),
           ),


Expanded(
  flex: 11,
  
   child: (
              

     
               // SizedBox(height: 20),

   
             StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('GarbageBin')
              .doc(gid)
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
        print("nioo: "+gid);    
              
             // GeoPoint position = LatLng(snapshot.data.data()['location']['latitude'],snapshot.data.data()['location']['longitude']);
              double _destLatitude = snapshot.data.data()['location']['latit'];
              double _destLongitude = snapshot.data.data()['location']['longi'];
              
              print("lati: "+_destLatitude.toString());
              print("langi: "+_destLongitude.toString());
              return Stack(
                children:<Widget> [
                  Positioned(
                     key: _key,
                    left: 300.0,
                    right: 50.0,
                    top: 16.0,
                    bottom: 16.0,
                    child: GoogleMap(
                      key: _key,
                      markers: {
                        Marker(
                         GeoCoord(_destLatitude, _destLongitude),
                          
                    
                        ),
                      },
                      initialZoom: 8,
                      initialPosition: GeoCoord(
                          6.93162477957, 79.8421960567), 
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
                    right: kIsWeb ? 5 : 10,
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
                  // Positioned(
                  //   left: 22,
                  //   right: kIsWeb ? 5 : 10,
                  //   bottom: 16,
                  //   child: Row(
                  //     children: <Widget>[
                  //       LayoutBuilder(
                  //         builder: (context, constraints) =>
                  //             constraints.maxWidth < 1000
                  //                 ? Row(children: _buildClearButtons())
                  //                 : Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: _buildClearButtons(),
                  //                   ),
                  //       ),
                  //       Spacer(),
                  //       // ..._buildAddButtons(),
                  //     ],
                  //   ),
                  // ),
                ],
              );
           }


//  Navigator.of(context)
//                 .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
//               return MyApp();
//             }), (Route route) => false);

   showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User doesn\'t create a bin'),
             // content: Text(data['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Back'),
                  onPressed: () {
                  //  Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) => MyApp()
              ), (Route route) => false);
                  },
                ),
              ],
            );
          });








           // return MyApp();
          })
         
     
   ),
          ),




















        ],
      ),
    );
  }




  Future<dynamic> getData(String idNumber) async {
    gid=idNumber;
    final DocumentReference document =
        FirebaseFirestore.instance.collection("users").doc(idNumber);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        firebaseData = snapshot.data();
        
      });
    });
    getData1(idNumber);
  }


Future<dynamic> getData1(String idNumber1) async {
    
    final DocumentReference document =
        FirebaseFirestore.instance.collection("GarbageBin").doc(idNumber1);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        firebaseData1 = snapshot.data();
        
      });
    });
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
