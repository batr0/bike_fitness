import 'package:flutter/material.dart';

import './pages/animated_map_controller.dart';
import './pages/circle.dart';
import './pages/esri.dart';
import './pages/home.dart';
import './pages/map_controller.dart';
import './pages/marker_anchor.dart';
import './pages/moving_markers.dart';
import './pages/offline_map.dart';
import './pages/offline_mbtiles_map.dart';
import './pages/on_tap.dart';
import './pages/overlay_image.dart';
import './pages/plugin_api.dart';
import './pages/plugin_scalebar.dart';
import './pages/polyline.dart';
import './pages/tap_to_add.dart';
import './pages/zdata.dart';



class MapDisplay extends StatelessWidget {
 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   debugShowCheckedModeBanner: false,

   title: 'Map Display',
   theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
    accentColor: Colors.yellow[700],
    backgroundColor:  Colors.blueGrey[50],
   ),
   home: HomePage(),
   routes: <String, WidgetBuilder>{
    TapToAddPage.route: (context) => TapToAddPage(),
    EsriPage.route: (context) => EsriPage(),
    PolylinePage.route: (context) => PolylinePage(),
    MyHomePage.route: (context) => MyHomePage(),
    MapControllerPage.route: (context) => MapControllerPage(),
    AnimatedMapControllerPage.route: (context) => AnimatedMapControllerPage(),
    MarkerAnchorPage.route: (context) => MarkerAnchorPage(),
    PluginPage.route: (context) => PluginPage(),
    PluginScaleBar.route: (context) => PluginScaleBar(),
    OfflineMapPage.route: (context) => OfflineMapPage(),
    OfflineMBTilesMapPage.route: (context) => OfflineMBTilesMapPage(),
    OnTapPage.route: (context) => OnTapPage(),
    MovingMarkersPage.route: (context) => MovingMarkersPage(),
    CirclePage.route: (context) => CirclePage(),
    OverlayImagePage.route: (context) => OverlayImagePage(),

   },
  );
 }
}

