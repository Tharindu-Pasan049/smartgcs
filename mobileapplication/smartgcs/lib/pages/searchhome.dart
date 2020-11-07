import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smartgcs/scoped_models/geolocator_service.dart';
import 'package:smartgcs/pages/search.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class SearchhomePage extends StatelessWidget {
  final geoService= GeolocatorService();
  @override
  Widget build(BuildContext context){
    
    return FutureProvider(
      
      create: (context)=>geoService.getInitialLocation(),
      child: MaterialApp(
debugShowCheckedModeBanner: false,
        title: "Map",
        theme: ThemeData(
          primarySwatch:Colors.green,
        ),
        home: Consumer<Position>(builder: (context,position,widget){
return (position !=null)?SearchPage(position):Center(child: CircularProgressIndicator(),);
        },),
      )
    
    );

  }
}