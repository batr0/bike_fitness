import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bike_fitness/widgets.dart';

class support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey[800], //Changing this will change the color of the TabBar
        accentColor: Colors.yellow[700],
        backgroundColor:  Colors.blueGrey[50],
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('FAQ and Support'),  ////BACK BUTTON FOR SUPPORT
                leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
        ),
        ),
        body: Container(
          child: Center(
            child: _myWidget(context),
          ),
        ),
      ),
    );
  }
}

// modify this widget with the example code below
Widget _myWidget(BuildContext context) {
  //Stream<List<int>> test = CharacteristicTile.characteristic.value;
  String myString = 'Bike Fitness by Team 47 \n\n https://github.com/batr0/bike_fitness \n\nQ:How do I use the app?\n\nA: First tab is settings, with Bluetooth Setup, Conversions, and other things to get you started. Second tab is live data input from the bike sensors, third tab is charted data from the live input, and fourth is the map displaying the route you rode';
  print(myString);
  return Card(
        child:GestureDetector(
         // onTap: () => _launchURL(),
         // padding: EdgeInsets.all(24.0),
          child: Text(myString),
        ),
  );
}
/*
_launchURL() async {
  const url = 'https://github.com/batr0/bike_fitness';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

 */