import 'package:bike_fitness/bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:bike_fitness/support.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bike_fitness/btserial/example/btserial.dart';
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
    String myString = '             Bike Fitness by Team 47 \n\n https://github.com/batr0/bike_fitness\n\n                    Tap to View FAQ';
    print(myString);
    return Scaffold(

      appBar: AppBar(title: Text(title)),

     backgroundColor:  Colors.blueGrey[50],
      ///add image to the settings pages
      body:  Card(
    color: Colors.blueGrey[800],
      child: GestureDetector(
          onTap: () => _launchURL(),
          child:Column(
            children: [
              Expanded(
                flex:1 ,
                child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: Text(
                        myString, style: TextStyle(color: Colors.yellow[700]))),
              ),
              Expanded(
                  flex:2 ,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    child: Image.asset((("assets/graphics/bike2.jpg"))),
                  )
              ),
            ],
          )
      ),
    ),
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
                    MaterialPageRoute(builder: (context) => ExampleApplication()),
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
            /*
            ListTile(
              title: Text('Support'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => support()),

                );
              },
            )*/
          ],
        ),

      ),
    );
  }
}

_launchURL() async {
  const url = 'https://github.com/batr0/bike_fitness';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

