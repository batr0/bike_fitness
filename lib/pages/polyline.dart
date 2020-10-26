import 'package:bike_fitness/WEBtoMSC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:bike_fitness/coffee.dart';

import '../widgets/drawer.dart';

class PolylinePage extends StatelessWidget {
  static const String route = 'polyline';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polylines')),
      drawer: buildDrawer(context, PolylinePage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(' Walk from MSC to WEB, Ride to Coffee Shop'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(30.619762, -96.334998),
                  zoom: 14.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: coffee,
                          strokeWidth: 4.0,
                          color: Colors.purple),
                      Polyline(
                          points: webMSC,
                          strokeWidth: 4.0,
                          color: Colors.redAccent[200]),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
