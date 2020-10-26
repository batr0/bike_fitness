import 'package:bike_fitness/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:bike_fitness/support.dart';

class settings extends StatelessWidget {
  final appTitle = 'Rides and Settings';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
        accentColor: Colors.yellow[700],
      ),
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text(title)),
     backgroundColor:  Colors.blueGrey[50],

   //   body: Image(image: AssetImage('assets/graphics/bike.jpg'), fit: BoxFit.fill,),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[

            DrawerHeader(
              //child: Text('Bike Fitness Settings', style: TextStyle(color: Colors.white),),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/graphics/bike.jpg"),
                      fit: BoxFit.cover)
              ),
              ),

            ListTile(
              title: Text('Bluetooth'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindDevicesScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Rides'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Data Conversions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Support'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => support()),

                );
              },
            )
          ],
        ),

      ),
    );
  }
}