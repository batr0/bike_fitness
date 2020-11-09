import 'package:bike_fitness/WEBtoMSC.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:bike_fitness/coffee.dart';
import 'package:bike_fitness/sensorData.dart';
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

                      Polyline(
                          points: sensorData,
                          strokeWidth: 4.0,
                          color: Colors.teal[200]),
                    ],
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Center(
                    child: Column(
                        children: [
                          Text(
                            'Coffee Ride, Campus to Bryan ',
                            style: TextStyle(fontSize: 18, color: Colors.purple),
                          ),
                          Text(
                            'WEB to MSC ',
                            style: TextStyle(fontSize: 18, color:Colors.redAccent[200]),
                          ),
                          Text(
                            'Bike Raw Sensor Data Test',
                            style: TextStyle(fontSize: 18, color: Colors.teal[200]),
                          ),
                        ]
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}

