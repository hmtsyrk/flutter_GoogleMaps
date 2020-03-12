import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/src/model/place_item_res.dart';
import 'package:flutter_map/src/model/step_res.dart';
import 'package:flutter_map/src/model/trip_info_res.dart';
import 'package:flutter_map/src/repository/place_service.dart';
import 'package:flutter_map/src/resource/widgets/car_pickup.dart';
import 'package:flutter_map/src/resource/widgets/home_menu.dart';
import 'package:flutter_map/src/resource/widgets/ride_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _tripDistance = 0;
  final Map<String, Marker> _markers = <String, Marker>{};
  final Set<Polyline> _polyline = {};

  GoogleMapController _mapController;
  Marker markerSirnak = Marker(
    markerId: MarkerId("1"),
    position: LatLng(37.522758, 42.453972),
    icon: BitmapDescriptor.defaultMarker,
  );

  @override
  void initState() {
    // TODO: implement initState
    _markers["1"] = markerSirnak;
  }

  @override
  Widget build(BuildContext context) {
    // print("build UI");
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
//              key: ggKey,
              markers: Set.of(_markers.values),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(37.522758, 42.453972),
                zoom: 14.4746,
              ),

              // sonradan ekledim
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Araç Takip",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: FlatButton(
                        onPressed: () {
                          print("click menu");
                          Scaffold.of(context).openDrawer();
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset("assets/images/ic_menu.png")),
                    actions: <Widget>[
                      Image.asset("assets/images/ic_notify.png")
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              height: 248,
              child: CarPickup(_tripDistance),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: HomeMenu(),
      ),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";

    _addMarker(mkId, place);
    _moveCamera();
    print("*************************************************************");

    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlaceItemRes place) async {
    // remove old
    _markers.remove(mkId);
    _markers.clear();
    // _mapController.clearMarkers();
// final MarkerId markerId = MarkerId(mkId);
    Marker marker = Marker(
      markerId: MarkerId(mkId),
      position: LatLng(place.lat, place.lng),
      icon: BitmapDescriptor.defaultMarker,
    );

    // sonradan ekledim
    setState(() {
      _markers[mkId] = marker;
    });
    markers:
    Set<Marker>.of(_markers.values);

    // _markers[mkId] = Marker(
    //     mkId,
    //     MarkerOptions(
    //         position: LatLng(place.lat, place.lng),
    //         infoWindowText: InfoWindowText(place.name, place.address)));

    // for (var m in _markers.values) {
    //   await _mapController.addMarker(m.options);
    // }
  }

  void _moveCamera() {
    print("move camera: ");
    print(_markers);

    if (_markers.values.length > 1) {
      var fromLatLng = _markers["from_address"].position;
      var toLatLng = _markers["to_address"].position;

      var sLat, sLng, nLat, nLng;
      if (fromLatLng.latitude <= toLatLng.latitude) {
        sLat = fromLatLng.latitude;
        nLat = toLatLng.latitude;
      } else {
        sLat = toLatLng.latitude;
        nLat = fromLatLng.latitude;
      }

      if (fromLatLng.longitude <= toLatLng.longitude) {
        sLng = fromLatLng.longitude;
        nLng = toLatLng.longitude;
      } else {
        sLng = toLatLng.longitude;
        nLng = fromLatLng.longitude;
      }

      LatLngBounds bounds = LatLngBounds(
          northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      _mapController.animateCamera(
          CameraUpdate.newLatLng(_markers.values.elementAt(0).position));
    }
  }

  void _checkDrawPolyline() {
//  remove old polyline,
    markers:
    Set<Marker>.of(_markers.values);
    print("*************************************************************1");
    _polyline.clear();
    // _mapController.clearPolylines();

    print("*************************************************************2");
    if (_markers.length > 1) {
      print("*************************************************************4");
      var from = _markers["from_address"].position;
      var to = _markers["to_address"].position;
      print("*************************************************************3");
      PlaceService.getStep(
              from.latitude, from.longitude, to.latitude, to.longitude)
          .then((vl) {
        TripInfoRes infoRes = vl;

        _tripDistance = infoRes.distance;
        setState(() {});
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = new List();
        for (var t in rs) {
          print(
              "*************************************************************");
          print(t.startLocation.latitude + t.startLocation.longitude);
          paths
              .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }

        // sonradan ekledim
        _polyline.add(Polyline(
            polylineId: PolylineId("poly"),
            visible: true,
            points: paths,
            color: Color(0xFF3ADF00),
            width: 10));
//        print(paths);
        // _mapController.addPolyline(PolylineOptions(
        //     points: paths, color: Color(0xFF3ADF00).value, width: 10));
      });
    }
  }
}
