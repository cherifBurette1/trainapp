import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'ui/train_tracking/model.dart';
import 'ui/tickets.dart';
import 'dart:ui' as ui;

import 'dart:convert';
import 'package:flutter/services.dart';

Position _currentPosition;
var allMarkers = HashSet<Marker>();
List<Polyline> myPolyline = [];
BitmapDescriptor customMarker;
dynamic loca = LatLng(31.218610752908937, 29.942156790466374);
getTrainmarker() async {
  customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'images/train_png.png');
}

class Mapss extends StatefulWidget {
  const Mapss({Key key}) : super(key: key);
  @override
  _MapssState createState() => _MapssState();
}

class _MapssState extends State<Mapss> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getcurrentlocation();
      getrainlocation();
      getTrainmarker();
      createPolyline();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_currentPosition.toString());
    return Scaffold(
      body: _currentPosition == null
          ? Center(child: Container(child: Text('Loading Maps...')))
          : GoogleMap(
              polylines: myPolyline.toSet(),
              initialCameraPosition: CameraPosition(
                  target: loca,
                  // LatLng(
                  //     _currentPosition.latitude, _currentPosition.longitude),
                  zoom: 15),
              onMapCreated: (GoogleMapController googleMapController) {
                allMarkers.add(
                  Marker(
                      markerId: MarkerId('train'),
                      icon: customMarker,
                      position: loca),
                );
                coffeeShops.forEach((element) {
                  allMarkers.add(Marker(
                      markerId: MarkerId(element.stationName),
                      draggable: false,
                      infoWindow: InfoWindow(
                          title: element.stationName, snippet: element.address),
                      position: element.locationCoords));
                });
              },
              markers: allMarkers,
            ),
    );
  }

  void getcurrentlocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  createPolyline() {
    myPolyline.add(Polyline(
        polylineId: PolylineId('1'),
        color: Colors.blue,
        width: 3,
        points: [
          LatLng(31.218610752908937, 29.942156790466374),
          LatLng(31.031580857134745, 30.488025875983332),
          LatLng(30.783109054618496, 30.993628700680027),
          LatLng(30.499529362952416, 31.16089471138503),
          LatLng(30.06460723927716, 31.25022562739004),
          LatLng(30.010296924484695, 31.20634973839642),
          LatLng(28.096427875759424, 30.751405415724406),
          LatLng(27.1733740916874, 31.18388237941898),
          LatLng(26.562536076692133, 31.676018321525998),
          LatLng(26.164224517611014, 32.70147891152025),
          LatLng(25.70088137302431, 32.64300448065244),
          LatLng(24.1003693156064, 32.899116499355685),
        ]));
  }

  getrainlocation() async {
    print(startloc);
    print(endloc);
    dynamic response = await rootBundle.loadString('assets/json/alexdam.json');
    dynamic responsedata = await json.decode(response);
    Future.delayed(const Duration(milliseconds: 200), () {
      for (int i = 0; i <= 25; i++) {
        print(loca.latitude.toString() + loca.longtude.toString());
        setState(() {
          loca = LatLng(responsedata[i.toString()]['lat'],
              responsedata[i.toString()]['lng']);
        });
        CameraPosition(
            target: LatLng(responsedata[i.toString()]['lat'],
                responsedata[i.toString()]['lng']));
      }
    });
  }
}
