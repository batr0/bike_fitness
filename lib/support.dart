import 'package:flutter/material.dart';

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
        appBar: AppBar(title: Text('FAQ and Support')),
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
  String myString = 'Team 47 Github\n Demo Videos\n Please view the following links for troubleshooting:';
  print(myString);
  return Text(
    myString,
    style: TextStyle(fontSize: 14.0),
  );
}