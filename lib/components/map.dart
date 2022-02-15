// @dart=2.9
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart' as coder;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homelyvendor/Home/home_page.dart';
import 'package:homelyvendor/Registration/registration.dart';
import 'package:homelyvendor/components/constants.dart';
import 'package:location/location.dart';

import 'model.dart';



class MapScreen extends StatefulWidget {

  final LatLng loc;
  final String userRef;
  final String type;

  const MapScreen({Key key, this.loc, this.userRef, this.type}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  GoogleMapController _controller ;

  CameraPosition _kGooglePlex;

  Set<Marker> _markers={};

  LatLng latlng ;
  var addressArea = "";
  var addressFull = "";

  @override
  void initState() {
    super.initState();

    setState(() {

      latlng = LatLng(widget.loc.latitude, widget.loc.longitude);

      _kGooglePlex = CameraPosition(
        target: latlng,
        zoom: 20
        
      );

    });
    // getAddress(latlng).then((value) {
    //
    //   setState(() {
    //     addressArea = value.first.featureName;
    //     addressFull = value.first.addressLine;
    //   });
    //
    // });

  }

  Future<List<Address>>getAddress(LatLng locationdata) async {
    // // From a query
    // final query = "1600 Amphiteatre Parkway, Mountain View";
    // var addresses = await Geocoder.local.findAddressesFromQuery(query);
    // var first = addresses.first;
    // print("${first.featureName} : ${first.coordinates}");

// From coordinates
    final coordinates =  coder.Coordinates(locationdata.latitude, locationdata.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    return addresses;

  }

  @override
  Widget build(BuildContext context) {
    print("newLatLong $latlng");
    print("addressArea $addressFull");
    // getAddress(latlng).then((value) {
    //   addressArea = value.first.featureName;
    //   addressFull = value.first.addressLine;
    // });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title:Text("Set Delivery Location"),backgroundColor: kgreen,),
        body: Stack(
          children: [GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller.animateCamera(

                  CameraUpdate.newCameraPosition(_kGooglePlex));
            },
            markers: {
              Marker(
                  markerId: MarkerId("a"),
                  draggable: true,
                  position: latlng,
                  icon: BitmapDescriptor.defaultMarker,
                  onDragEnd: (currentlatlng) async {
                    final coordinates =  coder.Coordinates(currentlatlng.latitude, currentlatlng.longitude);
                    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

                    setState(()  {

                      latlng = currentlatlng;
                      addressArea = '';
                      addressFull = 'Full address';

                    });

                  }),
            },

          ),
          Positioned(
            bottom: 20,
            right: 15,
            left: 15,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.mapMarkerAlt,color: Colors.green,),

                        Text(
                          addressArea,
                          style: GoogleFonts.arvo(
                              fontWeight: FontWeight.bold,fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      ],
                    ),
                    Container(
                      child: Text(
                        addressFull,
                        style: GoogleFonts.arvo(fontSize: 10),
                        overflow: TextOverflow.ellipsis,

                      ),
                    ),
                    ElevatedButton(

                        onPressed: (){

                             Get.off(Registration(address:addressFull,latlng:latlng,type: widget.type,)) ;


                    }, child: Text("Set Delivery Location"))
                  ],
                ),
              ),
            ),
          )

          ]
        ),
      ),
    );
  }



  }


