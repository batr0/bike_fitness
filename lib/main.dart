import 'package:bike_fitness/boxes.dart';

import 'package:flutter/material.dart';
import 'package:bike_fitness/map.dart';
import 'package:bike_fitness/bluetooth.dart';
import 'package:bike_fitness/graphs.dart';
import 'package:bike_fitness/settings.dart';
void main() => runApp(TabBarDemo());

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
        accentColor: Colors.yellow[700],
        backgroundColor:  Colors.blueGrey[50],
      ),

      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.settings)),
                //Tab(icon: Icon(Icons.contact_support)),
               // Tab(icon: Icon(Icons.bluetooth)),
           /*     Tab(icon: Icon(Icons.show_chart)),
                Tab(icon: Icon(Icons.bar_chart)),*/
                Tab(icon: Icon(Icons.terrain_outlined)),
              ],
            ),
            title: Text('Bike Fitness'),
          ),
          body: TabBarView(

            physics: NeverScrollableScrollPhysics(),

            children:<Widget>[

              Stack(
                  children: <Widget>[
                    new Container(
                      child: settings(), // Mapbox
                    )
                  ]

              ),
              /*
              Container(////////////////USAGE AND FAQ
                  color: Colors.grey[500],
                  child: Center(
                      child: Text('Support',
                        style: TextStyle(fontSize: 25,
                            color: Colors.white),))
              ),
              Stack(
                  children: <Widget>[
                    new Container(
                      height: 1000,
                      child: FindDevicesScreen(), // Mapbox
                    )
                  ]

              ),
              */

         /*     Container( //////////// LIVE DISPLAY DATA ///POWER ETC....

                  color: Colors.blueGrey[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: <Widget>[
                      BoxSpeed(),
                      BoxPower(),
                      BoxBattery(),
                      BoxDistance(),
                      BoxTemp(),
                    ],
                  )
              ),



              Container(///////////////MAAAPPPPPPPPPS
                  color: Colors.blueGrey[50],

                  child: Column(

                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //speedGraph(),
                     // powerGraph(),
                      gridGraph(),
                     batteryGraph(),
                     // distGraph(),
                      //tempGraph(),

                    ],
                  )
              ),*/

              Stack(///////////////MAAAPPPPPPPPPS
                  children: <Widget>[
                    new Container(
                      child: MapDisplay(), // openstreetmaps
                    )
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Page()
        )
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Bike Fitness')),
        body: Center(child:
        PageView(
          controller: controller,
          onPageChanged: (page)=>{ print(page.toString()) },
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Stack(
                children: <Widget>[
                  new Container(
                    height: 1000,
                    child: FindDevicesScreen(), // Mapbox
                  )
                ]

            ),

            Container( //////////// LIVE DISPLAY DATA ///POWER ETC....

                color: Colors.orangeAccent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: <Widget>[
                      BoxSpeed(),
                      BoxDistance(),
                      BoxPower(),
                      BoxBattery(),
                  ],
            )
            ),

            Stack(/////////////////////////////////MAAAAAAAAP

              children: <Widget>[
            new Container(
            height: 1000,
              child: MapDisplay(), // Mapbox
            )
            ]
            ),


            Container(////////////////UNITS AND CONVERSIONS FOR BIKES
                color: Colors.deepOrangeAccent,
                child: Center(
                    child: Text('Settings',
                      style: TextStyle(fontSize: 25,
                          color: Colors.white),))
            ),
            Container(///////////////////ABOUT USAGE APP
                color: Colors.blueGrey,
                child: Center(
                    child: Text('About Page',
                      style: TextStyle(fontSize: 25,
                          color: Colors.white),))
            ),

          ],
        ),
        )
    );
  }
}
*/
