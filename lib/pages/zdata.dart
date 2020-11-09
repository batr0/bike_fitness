import 'package:bike_fitness/settings.dart';
import 'package:bike_fitness/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:bike_fitness/widgets/map_elevation.dart';

import '../heatmap.dart';


class MyHomePage extends StatefulWidget {
  static const String route = 'zdata';
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ElevationPoint hoverPoint = 	ElevationPoint(30.62734	,	-96.34081667	,	0.06);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Z-Data')),
      drawer: buildDrawer(context, MyHomePage.route),

      body: Stack(children: [
        FlutterMap(
          options: new MapOptions(
            center: LatLng(30.62734	,	-96.34081667),
            zoom: 14.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayerOptions(
              // Will only render visible polylines, increasing performance
              polylines: [
                Polyline(
                  // An optional tag to distinguish polylines in callback
                  points: getPoints(),
                  color: Colors.blueGrey[800],
                  strokeWidth: 3.0,
                ),
              ],
            ),
            MarkerLayerOptions(markers: [
              if (hoverPoint is LatLng)
                Marker(
                    point: hoverPoint,
                    width: 10,
                    height: 10,
                    builder: (BuildContext context) => Container(
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent[400],
                          borderRadius: BorderRadius.circular(8)),
                    ))
            ]),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            color: Colors.blueGrey[800].withOpacity(1),
            child: NotificationListener<ElevationHoverNotification>(
                onNotification: (ElevationHoverNotification notification) {
                  setState(() {
                    hoverPoint = notification.position;
                  });

                  return true;
                },
                child: Elevation(
                  getPoints(),
                  color: Colors.blueGrey[50],
                  elevationGradientColors: ElevationGradientColors(
                      gt10: Colors.pink[200],
                      gt20: Colors.pink[500],
                      gt30: Colors.pink[800]),
                )),
          ),
        )
      ]),
    );
  }
}