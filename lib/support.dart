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
  String myString = '             Bike Fitness by Team 47 \n\n https://github.com/batr0/bike_fitness\n\n                    Tap to View FAQ';
  print(myString);
  return Card(
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
                      myString, style: TextStyle(color: Colors.blueGrey[50]))),
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
  );
}

_launchURL() async {
  const url = 'https://github.com/batr0/bike_fitness';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

